//
//  MapViewController.h
//  WhatsUp
//
//  Created by Nathan Buggia on 2/6/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GANTracker.h"

#define NORMAL_MAP 0
#define SATALITE_MAP 1
#define HYBRID_MAP 2

@interface MapViewController : UIViewController 
{
	double latitude;
	double longitude;
	MKMapView* mapView;
}

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, retain) IBOutlet MKMapView* mapView;

- (IBAction)clickMapTypeSegmentControl:(id)sender;
- (IBAction)clickOpenMapsApp:(id)sender;

@end
