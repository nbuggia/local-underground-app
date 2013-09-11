//
//  AboutViewController.m
//  WhatsUp
//
//  Created by Nathan Buggia on 12/30/10.
//  Copyright netorion.com 2010. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

@synthesize delegate;

-(void)clickDone:(id)sender
{
	[self.delegate aboutViewClose:self];	
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

	// Google Analytics
	NSError *error;
	[[GANTracker sharedTracker] trackPageview:@"/AboutView" withError:&error];		
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}


- (void)dealloc 
{
    [super dealloc];
}


@end
