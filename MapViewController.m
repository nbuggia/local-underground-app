//
//  MapViewController.m
//  WhatsUp
//
//  Created by Nathan Buggia on 2/6/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController

@synthesize latitude;
@synthesize longitude;
@synthesize mapView;


- (IBAction)clickMapTypeSegmentControl:(id)sender
{
	switch ([sender selectedSegmentIndex]) 
	{
		case HYBRID_MAP:
			self.mapView.mapType = MKMapTypeHybrid;
			break;
			
		case SATALITE_MAP:
			self.mapView.mapType = MKMapTypeSatellite;
			break;
			
		case NORMAL_MAP:
			self.mapView.mapType = MKMapTypeStandard;
		default:
			break;
	}

	// Google Analytics
	NSError *err;
	[[GANTracker sharedTracker] trackEvent:@"MapView" action:@"clickDifferentMap" label:@"Refresh" value:-1 withError:&err];		
}


- (IBAction)clickOpenMapsApp:(id)sender
{
	NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?ll=%d,%d&z=%@", latitude, longitude, @"8"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


- (void)viewDidLoad 
{
    [super viewDidLoad];

	// also MKMapTypeSatellite or MKMapTypeHybrid
	self.mapView.mapType = MKMapTypeStandard;	

	CLLocationCoordinate2D loc = {latitude, longitude};
	MKCoordinateRegion region;
	region.center = loc;
	
	MKCoordinateSpan span;
	span.latitudeDelta = span.longitudeDelta = 0.03; //desired size for both latDelta and lonDelta
	region.span = span;
	
	[mapView setRegion:region animated:YES];

	// Google Analytics
	NSError *error;
	[[GANTracker sharedTracker] trackPageview:@"/MapView" withError:&error];		
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
	mapView = nil;
}


- (void)dealloc 
{
    [super dealloc];
	[mapView release];
}


@end
