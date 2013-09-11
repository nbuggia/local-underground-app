//
//  CategoryViewController.m
//  WhatsUp
//
//  Created by Nathan Buggia on 12/20/10.
//  Copyright netorion.com 2010. All rights reserved.
//

#import "CategoryViewController.h"

@implementation CategoryViewController

@synthesize statusImages;
@synthesize statusUpdates;
@synthesize operationQueue;
@synthesize selectedUpdate;


/*** View Lifecycle ***************************************************************************************************/

#pragma mark -
#pragma mark View lifecycle


- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	
	if(!statusImages)
		statusImages = [[NSMutableDictionary alloc] init];
	
	// Google Analytics
	NSError *error;
	[[GANTracker sharedTracker] trackPageview:@"/CategoryView" withError:&error];	
}


/*** Memory Management ************************************************************************************************/

#pragma mark -
#pragma mark Memory management


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];	
	[statusImages removeAllObjects];
}


- (void)viewDidUnload 
{
	[super viewDidUnload];
}


-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	statusImages = nil;
}


- (void)dealloc 
{
    [super dealloc];

	[statusImages release];
	[statusUpdates release];
	[operationQueue release];
}

/*** Image Refresh ****************************************************************************************************/

#pragma mark -
#pragma mark Image Refresh


- (UIImage*)getImageForUrl:(NSURL*)url
{
	id obj = [statusImages objectForKey:url];
	
	if(!obj)
	{
		// we haven't downloaded this image yet, let's do that
		
		[statusImages setObject:@"na" forKey:url];
		NOImageFetcher *operation = [[NOImageFetcher alloc] initWithImageUrl:url targetObject:self 
															targetMethod:@selector(handleImageUpdate:)];
		[operationQueue addOperation:operation];
		[operation release];
	}
	else 
	{
		// we've downloaded this before, let's make sure it is a UIImage
		if(![obj isKindOfClass:[UIImage class]])
			obj = nil;
	}
	
	return obj;
}


- (void)handleImageUpdate:(NSDictionary*)result
{
	NSURL* url = [result objectForKey:@"url"];
	UIImage* image = [result objectForKey:@"image"];
	
	if(image)
		[statusImages setObject:image forKey:url];
	else
		NSLog(@"couldn't download image: %@", url);
	
	[[self tableView] reloadData];
}


/*** Table view data source *******************************************************************************************/

#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	int index = [indexPath indexAtPosition: [indexPath length] - 1];
	NSString* statusText = ((StatusUpdate*)[statusUpdates objectAtIndex:index]).text;
	int height = [StatusUpdateCellView getRowHeightForStatusText:statusText];
	
	return height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return statusUpdates.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int index = [indexPath indexAtPosition: [indexPath length] - 1];
	static NSString *CellIdentifier;

	CellIdentifier = @"Cell";
	
	StatusUpdateCellView *cell = (StatusUpdateCellView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
		cell = [[[StatusUpdateCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	StatusUpdate *currentStatusUpdate = (StatusUpdate*)[statusUpdates objectAtIndex:index];
	cell.updateText.text = currentStatusUpdate.text;
	
	if(currentStatusUpdate.source == Twitter)
		cell.userName.text = [NSString stringWithFormat:@"%@ via %@",[currentStatusUpdate.userName lowercaseString], @"twitter"];	
	else if(currentStatusUpdate.source == Foursquare)
		cell.userName.text = [NSString stringWithFormat:@"%@ via %@",[currentStatusUpdate.userName lowercaseString], @"foursquare"];	
	else if(currentStatusUpdate.source == Facebook)
		cell.userName.text = [NSString stringWithFormat:@"%@ via %@",[currentStatusUpdate.userName lowercaseString], @"facebook"];	
	else if(currentStatusUpdate.source == Yelp)
		cell.userName.text = [NSString stringWithFormat:@"%@ via %@",[currentStatusUpdate.userName lowercaseString], @"yelp"];	
	else
		cell.userName.text = [currentStatusUpdate.userName lowercaseString];	
	
	// use the friendly date
	cell.updateTimePosted.text = [NODateUtils getFriendlyTimeFromDateString:[NSDate date] referenceDate:currentStatusUpdate.date];
	
	// lazy load the user status image with NSOperationQueue, and round the corners
	cell.userPhoto.image = [self getImageForUrl:[NSURL URLWithString:currentStatusUpdate.userPhotoUrl]];
	CALayer *layer = [cell.userPhoto layer];
	[layer setMasksToBounds:YES];
	[layer setCornerRadius:2.0];
	[layer setBorderWidth:1.0];
	[layer setBorderColor:[[UIColor lightGrayColor]CGColor]];		
	
	// dynamically position the elements based on how big the statusText is
	cell = [StatusUpdateCellView updateCellPositionsWithStatusTextLabelHeight:cell];
	
	// create the gradient
	cell.bounds = CGRectMake(0, 0, 320, [StatusUpdateCellView getRowHeightForStatusText:cell.updateText.text]);
	cell.backgroundView = [[[CellViewGradient alloc] init] autorelease];
	
	return cell;
}


/*** Table view data source *******************************************************************************************/

#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{   
	// max num of URLs we'll show in the action sheet
	int MAX_URLS = 3;
	
	UIActionSheet* uias = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];

	// add buttons for the first two URLs found in 
	int index = [indexPath indexAtPosition: [indexPath length] - 1];
	selectedUpdate = (StatusUpdate*)[statusUpdates objectAtIndex:index];

	NSArray* urls = [self getUrlsFromString:selectedUpdate.text];
	
	int max = ([urls count] < MAX_URLS) ? [urls count] : MAX_URLS;
	for(int i=0; i<max; i++)
	{
		NSString* title = [NSString stringWithFormat:BUTTON_URL_PREFIX, [urls objectAtIndex:i]];
		[uias addButtonWithTitle:title];
	}

	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil && [mailClass canSendMail])
		[uias addButtonWithTitle:BUTTON_SHARE];
	
	[uias addButtonWithTitle:BUTTON_BROWSER];
	[uias addButtonWithTitle:BUTTON_CANCEL];
	
	uias.cancelButtonIndex = uias.numberOfButtons-1;
	
	[uias showInView:self.view];
	[uias release];
}


- (NSArray*)getUrlsFromString:(NSString*)string
{
	int minUrlLength = 10;
	NSArray* segments = [string componentsSeparatedByString:@" "];
	NSMutableArray* urls = [[[NSMutableArray alloc] init] autorelease];
	
	for(NSString* line in segments)
	{
		// not long enough to contain a valid URL
		if([line length] < minUrlLength)
			continue;
		
		// TODO: see if they wrapped the string in (, [, " or '
		
		NSString* http = [line substringToIndex:4];
		if([http isEqualToString:@"http"])
			[urls addObject:line];
	}
	
	return urls;
}


/*** UI Action Sheet Delegate *******************************************************************************************/

#pragma mark - UI Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)uias clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString* button = [uias buttonTitleAtIndex:buttonIndex];
	NSError *err;
	
	if([button isEqualToString:BUTTON_SHARE])
	{
		Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
		if (mailClass != nil && [mailClass canSendMail])
			[self displayComposerSheet];
		
		[[GANTracker sharedTracker] trackEvent:@"CategoryView" action:@"emailUpdate" label:@"emailUpdate" value:-1 withError:&err];	
	}
	else if([button isEqualToString:BUTTON_BROWSER])
	{
		BrowserViewController* bvc = [[BrowserViewController alloc] initWithNibName:@"BrowserView" bundle:nil];
		bvc.title = @"Browser";
		bvc.url = selectedUpdate.url;
		[self.navigationController pushViewController:bvc animated:YES];
		[bvc release];
		
		[[GANTracker sharedTracker] trackEvent:@"CategoryView" action:@"openUpdateInBrowser" label:@"emailUpdate" value:-1 withError:&err];	

	}
	else if([button isEqualToString:BUTTON_CANCEL])
	{
		// thank you, come again
		return;
	}
	else 
	{
		// must be an "Open http://bit.ly/asFDdf" type button. Let's parse out the URL
		//NSArray* segments = [button componentsSeparatedByString:@" "];
		//NSString* urlString = (NSString*)[segments lastObject];
		NSString* urlString = button;
		
		BrowserViewController* bvc = [[BrowserViewController alloc] initWithNibName:@"BrowserView" bundle:nil];
		bvc.title = @"Browser";
		bvc.url = [NSURL URLWithString:urlString];
		[self.navigationController pushViewController:bvc animated:YES];
		[bvc release];
		
		[[GANTracker sharedTracker] trackEvent:@"CategoryView" action:@"openUpdateLinkInBrowser" label:@"emailUpdate" value:-1 withError:&err];		
	}	
}

/*** MailViewController delegate *******************************************************************************************/

#pragma mark -
#pragma mark MailViewController delegate


- (void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;

	if(selectedUpdate)
	{
		NSString* emailBody;

		emailBody = [NSString stringWithFormat:@"\n\n\n%@\n%@\n\n(via LocalUndegroundApp.com)", 
					 selectedUpdate.text,
					 selectedUpdate.url];

		[picker setMessageBody:emailBody isHTML:NO];	
	}
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error 
{	
	[self dismissModalViewControllerAnimated:YES];
}


@end