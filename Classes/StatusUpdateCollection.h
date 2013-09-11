//
//  StatusUpdateCollection.h
//  WhatsUp
//
//  Created by Nathan Buggia on 12/25/10.
//  Copyright netorion.com 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "Types.h"
#import "StatusUpdate.h"
#import "UpdateQueueItem.h"
#import "WeatherForecast.h"
#import "CuratedAccountsResponse.h"

#define WORK_ITEM_WEATHER 0
#define WORK_ITEM_TWITTER 1

// INTERFACE
@interface StatusUpdateCollection : NSObject
{	
	NSMutableArray* updateQueue;
	NSMutableDictionary* statusUpdates;
}
@property (nonatomic, retain) NSMutableArray* updateQueue;
@property (nonatomic, retain) NSMutableDictionary* statusUpdates;

- (void)addTweets:(NSArray *)tweets inCategory:(NSString*)category;
- (void)addWeather:(WeatherForecast*)forecast;
- (void)expunge;
- (void)addCuratedAccountsToQueue:(NSArray*)accounts;
- (bool)shouldDeleteUpdate:(StatusUpdate*)s;

@end
