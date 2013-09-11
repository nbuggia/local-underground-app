//
//  ProviderManager.h
//  WhatsUp
//
//  Created by Nathan Buggia on 2/21/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusUpdateCollection.h"
#import "TwitterResponse.h"
#import "TwitterBulkTimelineProvider.h"
#import "TwitterLocationTimelineProvider.h"
#import "CuratedAccountsProvider.h"
#import "NoaaProvider.h"
#import "WeatherForecast.h"

@protocol ProviderManagerDelegate;

@interface ProviderManager : NSObject 
{
	// a pointer to the data source to update with each of the providers
	StatusUpdateCollection* statusUpdateCollection;

	// the delegate asking us politely to update their datasource
	id <ProviderManagerDelegate> delegate;
	
	// a pointer to the delegate's operation queue for conducting the updates in the background
	NSOperationQueue* operationQueue;
	
	// used to formulate the query to the datasources
	double latitude, longitude;
	
	// keeps track of the number of updates we have pending, when it is zero we are not refreshing anymore
	int numUpdatingOperations;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) StatusUpdateCollection* statusUpdateCollection;
@property (nonatomic, retain) NSOperationQueue* operationQueue;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) int numUpdatingOperations;

- (id)initWithCollection:(StatusUpdateCollection*)collection queue:(NSOperationQueue*)queue;
- (void)refreshData:(bool)completeRefresh;

- (void)handleWeatherUpdate:(WeatherForecast*)forecast;
- (void)handleCuratedAccountsUpdate:(NSArray*)accounts;
- (void)handleTwitterBulkUpdate:(TwitterResponse*)response;
- (void)handleTwitterLocationUpdate:(TwitterResponse*)response;

- (void)notifyDelegateIfLastOperation;
- (bool)isCurrentlyRefreshing;

@end

@protocol ProviderManagerDelegate

- (void)operationComplete;
- (void)allOperationsCompleted;

@end

