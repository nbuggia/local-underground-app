//
//  RootViewController.m
//  WhatsUp
//
//  Created by Nathan Buggia on 2/21/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

@synthesize providerManager;
@synthesize locationManager;
@synthesize statusUpdateCollection;
@synthesize statusImages;
@synthesize operationQueue;


/*** View Lifecycle ***************************************************************************************************/

#pragma mark -
#pragma mark View lifecycle


- (id)init
{
	if(self = [super init])
	{
		statusUpdateCollection = [[StatusUpdateCollection alloc] init];
		statusImages = [[NSMutableDictionary alloc] init];
		
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:2];
		[operationQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
		
		providerManager = [[ProviderManager alloc] initWithCollection:statusUpdateCollection queue:operationQueue];
		providerManager.delegate = self;
		
		latitude = longitude = 0.0;
		haveLocation = NO;
		
		// Location stuff
		if([CLLocationManager locationServicesEnabled])
		{
			locationManager = [[CLLocationManager alloc] init];
			locationManager.delegate = self;
			locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
			locationManager.distanceFilter = kCLDistanceFilterNone;
			[locationManager startUpdatingLocation];
		}
        else
        {
            NSLog(@"ERROR: location services are not enabled!");
        }
	}
	return self;
}


- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:animated];	
	self.title = @"Local Underground";
	
	// Google Analytics
	NSError *error;
	[[GANTracker sharedTracker] trackPageview:@"/RootView" withError:&error];	
}


/*** Data pipeline *******************************************************************************************/

#pragma mark -
#pragma mark Data pipeline


- (void)refreshDataAndUpdateLocation:(bool)updateLocation
{	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	isReloading = YES;
	
	if(updateLocation)
	{		
		haveLocation = NO;
		[statusUpdateCollection expunge];
		[locationManager startUpdatingLocation];
		
		return;
	}
		
	providerManager.latitude = latitude;
	providerManager.longitude = longitude;
	[providerManager refreshData:YES];
	
	// Google Analytics
	[[GANTracker sharedTracker] dispatch];
}


- (void)allOperationsCompleted
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	isReloading = NO;
}


- (void)operationComplete
{
	[[self tableView] reloadData];
}


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
	
	// we've downloaded this before, let's make sure it is a UIImage
	else if(![obj isKindOfClass:[UIImage class]])
		obj = nil;
	
	return obj;
}


- (void)handleImageUpdate:(NSDictionary*)result
{
	NSURL *url = [result objectForKey:@"url"];
	UIImage *image = [result objectForKey:@"image"];
	
	if(image){
		[statusImages setObject:image forKey:url];
	}
	else {
		NSLog(@"couldn't download image: %@", url);
	}
	
	
	[[self tableView] reloadData];
}


- (void)observeValueForKeyPath:(NSString *)keyPath 
					  ofObject:(id)object 
						change:(NSDictionary *)change 
					   context:(void *)context
{
	if(object == operationQueue && [keyPath isEqual:@"operations"])
	{
		if ([operationQueue.operations count] == 0)
		{
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		}
	}
	else 
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}	
}


/*** Table view data source *******************************************************************************************/

#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	// adding +1 because the map is an extra row
	int rows = [[statusUpdateCollection.statusUpdates allKeys] count] + 1;
    return rows;
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	int index = [indexPath indexAtPosition: [indexPath length] - 1];
	
	if(index == ROW_MAP)
		return 120;
	else
		return 58;		
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int index = [indexPath indexAtPosition: [indexPath length] - 1];
	static NSString *CellIdentifier;
	
	if(index == ROW_MAP)
	{
		CellIdentifier = @"MapCell";
		
		MapCellView* mapCell = (MapCellView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];		
		
		if(mapCell == nil)
			mapCell = [[[MapCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		CLLocationCoordinate2D loc = {latitude, longitude};
		
		MKCoordinateRegion region;
		region.center = loc;
		
		MKCoordinateSpan span;
		span.latitudeDelta = span.longitudeDelta = 0.03; //desired size for both latDelta and lonDelta
		region.span = span;
		
		[mapCell.mapView setRegion:region animated:YES];		
		
		return mapCell;
	}
    else
	{
		NSArray* categoryList = [statusUpdateCollection.statusUpdates allKeys];
		NSString* categoryName = (NSString*)[categoryList objectAtIndex:index-1];

		if([categoryName isEqualToString:CATEGORY_WEATHER])
		{
			StatusUpdate* weather = (StatusUpdate*)[statusUpdateCollection.statusUpdates objectForKey:CATEGORY_WEATHER];
			
			CellIdentifier = @"WeatherCell";
			CategoryCellView* weatherCell = (CategoryCellView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (weatherCell == nil)
				weatherCell = [[[CategoryCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			
			weatherCell.name.text = weather.userName;
			weatherCell.lastUpdate.text = weather.text;
			weatherCell.updateCount.hidden = YES;
			
			weatherCell.photo.image = [self getImageForUrl:[NSURL URLWithString:weather.userPhotoUrl]];
			CALayer *layer = [weatherCell.photo layer];
			[layer setMasksToBounds:YES];
			[layer setCornerRadius:5.0];
			[layer setBorderWidth:1.0];
			[layer setBorderColor:[[UIColor lightGrayColor]CGColor]];		
			
			// create the gradient
			weatherCell.bounds = CGRectMake(0, 0, 320, 58);
			weatherCell.backgroundView = [[[CellViewGradient alloc] init] autorelease];			
			
			return weatherCell;
		}
		else
		{
			NSArray* updatesInCategory = (NSArray*)[statusUpdateCollection.statusUpdates objectForKey:categoryName];
			StatusUpdate* firstUpdate = (StatusUpdate*)[updatesInCategory objectAtIndex:0];

			CellIdentifier = @"CategoryCell";
			CategoryCellView* categoryCell = (CategoryCellView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (categoryCell == nil)
				categoryCell = [[[CategoryCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			
			categoryCell.name.text = categoryName;
			NSString* friendlyDate = [NODateUtils getFriendlyTimeFromDateString:[NSDate date] referenceDate:firstUpdate.date];
			categoryCell.lastUpdate.text = [NSString stringWithFormat:@"%@ ago", friendlyDate];
			categoryCell.updateCount.text = [NSString stringWithFormat:@"%d", [updatesInCategory count]];
			
			categoryCell.photo.image = [self getImageForUrl:[NSURL URLWithString:firstUpdate.userPhotoUrl]];
			CALayer *layer = [categoryCell.photo layer];
			[layer setMasksToBounds:YES];
			[layer setCornerRadius:5.0];
			[layer setBorderWidth:1.0];
			[layer setBorderColor:[[UIColor lightGrayColor]CGColor]];		
			
			// create the gradient
			categoryCell.bounds = CGRectMake(0, 0, 320, 58);
			categoryCell.backgroundView = [[[CellViewGradient alloc] init] autorelease];
			
			return categoryCell;			
		}		
	}
}


/*** Table view delegate **********************************************************************************************/


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int index = [indexPath indexAtPosition: [indexPath length] - 1];
	
	if(index == ROW_MAP)
	{
		MapViewController* mvc = [[MapViewController alloc] initWithNibName:@"MapView" bundle:nil];
		mvc.latitude = latitude;
		mvc.longitude = longitude;
		mvc.title = @"Area Map";
		[self.navigationController pushViewController:mvc animated:YES];
		[mvc release];
	}
	else
	{
		//
		// Figure out what type of cell it is by looking at the category name
		
		NSArray* categoryList = [statusUpdateCollection.statusUpdates allKeys];
		NSString* categoryName = (NSString*)[categoryList objectAtIndex:index-1];		

		if([categoryName isEqualToString:CATEGORY_WEATHER])
		{		
			BrowserViewController* bvc = [[BrowserViewController alloc] initWithNibName:@"BrowserView" bundle:nil];
			bvc.title = @"Weather";
			StatusUpdate* weather = (StatusUpdate*)[statusUpdateCollection.statusUpdates objectForKey:CATEGORY_WEATHER];
			bvc.url = weather.url;
			[self.navigationController pushViewController:bvc animated:YES];
			[bvc release];
		}
		else 
		{
			
			CategoryViewController* cvc = [[CategoryViewController alloc] initWithNibName:@"CategoryView" bundle:nil];
			cvc.statusUpdates = (NSArray*)[statusUpdateCollection.statusUpdates objectForKey:categoryName];
			cvc.operationQueue = operationQueue;
			cvc.title = categoryName;
			[self.navigationController pushViewController:cvc animated:YES];
			[cvc release];
		}
	}
	
	// create a back button so the user can get back to root view
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
	[self.navigationItem setBackBarButtonItem:backButton];
	[backButton release];
}


/*** Memory management ************************************************************************************************/


#pragma mark -
#pragma mark Memory management


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
	[statusImages removeAllObjects];
}


- (void)viewDidUnload 
{
	self.statusImages = nil;
//	self.refreshHeaderView = nil;
}


- (void)dealloc 
{
    [super dealloc];
	[providerManager release];
	[locationManager release];
	[statusUpdateCollection release];
	[statusImages release];
	[operationQueue release];

}

/*** CLLocationManager methods ****************************************************************************************/

#pragma mark -
#pragma mark CLLocationManager methods


- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation
{
	if(!haveLocation)
	{
		haveLocation = YES;
		
		[locationManager stopUpdatingLocation];
		
		latitude = newLocation.coordinate.latitude;
		longitude = newLocation.coordinate.longitude;
		
		NSLog(@"New Location, Lat: %g Lon: %g", newLocation.coordinate.latitude, newLocation.coordinate.longitude);

		[self refreshDataAndUpdateLocation:NO];	
	}
}


- (void)locationManager:(CLLocationManager *)manager 
	   didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error description]);
	[locationManager stopUpdatingHeading];
}


@end


