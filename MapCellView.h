//
//  MapCellView.h
//  WhatsUp
//
//  Created by Nathan Buggia on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapCellView : UITableViewCell 
{
	MKMapView *mapView;
}

@property (nonatomic, retain) MKMapView *mapView;

@end
