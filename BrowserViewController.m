//
//  BrowserViewController.m
//  WhatsUp
//
//  Created by Nathan Buggia on 2/27/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import "BrowserViewController.h"


@implementation BrowserViewController

@synthesize webView;
@synthesize url;


- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	webView.scalesPageToFit = YES;
	
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.url];	
	[webView loadRequest:requestObj];
	
	// Google Analytics
	NSError *error;
	[[GANTracker sharedTracker] trackPageview:@"/BrowserView" withError:&error];	
}


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
	[webView release];
	[url release];
}


@end
