//
//  RootViewController.h
//  WhatsUp
//
//  Created by Nathan Buggia on 2/21/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProviderManager.h"
#import "NOImageFetcher.h"
#import "NODateUtils.h"
#import "MapCellView.h"
#import "CellViewGradient.h"
#import "CategoryCellView.h"
#import "CategoryViewController.h"
#import "MapViewController.h"
#import "BrowserViewController.h"
#import "GANTracker.h"

#define ROW_MAP 0

@interface RootViewController : UITableViewController <CLLocationManagerDelegate, ProviderManagerDelegate>
{	
	// figure out where we are
	CLLocationManager* locationManager;
	double latitude;
	double longitude;
	bool haveLocation;
	
	// manages the downloading of all data sources, stores the results
	StatusUpdateCollection* statusUpdateCollection;	
	ProviderManager* providerManager;
	
	// stores our status update images which are lazy loaded
	NSMutableDictionary* statusImages;
	
	// used for updating our statusImages in the background (lazy load)
	NSOperationQueue *operationQueue;
	
	bool isReloading;
}

@property (nonatomic, retain) ProviderManager* providerManager;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) StatusUpdateCollection* statusUpdateCollection;
@property (nonatomic, retain) NSMutableDictionary* statusImages;
@property (nonatomic, retain) NSOperationQueue* operationQueue;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
- (void)operationComplete;

@end
