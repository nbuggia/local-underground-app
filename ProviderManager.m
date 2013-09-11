//
//  ProviderManager.m
//  WhatsUp
//
//  Created by Nathan Buggia on 2/21/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import "ProviderManager.h"

@implementation ProviderManager

@synthesize delegate;
@synthesize statusUpdateCollection;
@synthesize operationQueue;
@synthesize latitude;
@synthesize longitude;
@synthesize numUpdatingOperations;

- (id)initWithCollection:(StatusUpdateCollection*)collection queue:(NSOperationQueue*)queue
{
	if(self = [super init])
	{
		statusUpdateCollection = collection;
		operationQueue = queue;
		numUpdatingOperations = 0;
	}
	
	return self;
}


- (void)refreshData:(bool)completeRefresh
{
	CuratedAccountsProvider* curatedTweets;
	curatedTweets = [[CuratedAccountsProvider alloc] initWithLatitude:latitude longitude:longitude targetObject:self targetMethod:@selector(handleCuratedAccountsUpdate:)];
	[operationQueue addOperation:curatedTweets];
	numUpdatingOperations++;
	[curatedTweets release];
	
	UpdateQueueItem *itemNoaa = (UpdateQueueItem*)[statusUpdateCollection.updateQueue objectAtIndex:WORK_ITEM_WEATHER];	
	NoaaProvider *noaa = [[NoaaProvider alloc] initWithLatitude:latitude longitude:longitude lastUpdate:itemNoaa.lastUpdate targetObject:self targetMethod:@selector(handleWeatherUpdate:)];
	itemNoaa.lastUpdate = [[NSDate date] timeIntervalSince1970];
	[operationQueue addOperation:noaa];
	numUpdatingOperations++;
	[noaa release];
	
	UpdateQueueItem *itemTwitter = (UpdateQueueItem*)[statusUpdateCollection.updateQueue objectAtIndex:WORK_ITEM_TWITTER];
	TwitterLocationTimelineProvider *twitter;
	twitter = [[TwitterLocationTimelineProvider alloc] initWithLatitude:latitude longitude:longitude lastUpdate:itemTwitter.lastUpdate refreshUrl:itemTwitter.refreshUrl targetObject:self targetMethod:@selector(handleTwitterLocationUpdate:)];
	[operationQueue addOperation:twitter];
	numUpdatingOperations++;
	[twitter release];
}


- (void)handleWeatherUpdate:(WeatherForecast*)forecast
{
	if(nil == forecast)
		return;
	
	[statusUpdateCollection addWeather:forecast];
	
	[self notifyDelegateIfLastOperation];
	[[self delegate] operationComplete];
}


- (void)handleTwitterBulkUpdate:(TwitterResponse*)response
{
	if(nil == response)
		return;
	
	[statusUpdateCollection addTweets:response.tweets inCategory:response.category];
	
	[self notifyDelegateIfLastOperation];
	[[self delegate] operationComplete];
}


- (void)handleTwitterLocationUpdate:(TwitterResponse*)response
{
	if(nil == response)
		return;
	
	UpdateQueueItem *itemTwitter = (UpdateQueueItem*)[statusUpdateCollection.updateQueue objectAtIndex:WORK_ITEM_TWITTER];
	itemTwitter.refreshUrl = [response.refreshUrl retain];
	itemTwitter.lastUpdate = response.lastUpdate;
	
	[statusUpdateCollection addTweets:response.tweets inCategory:CATEGORY_LOCALTWEETS];
	
	[self notifyDelegateIfLastOperation];
	[[self delegate] operationComplete];
}


- (void)handleCuratedAccountsUpdate:(NSArray*)accounts
{
	if(nil == accounts)
		return;
	
	[statusUpdateCollection addCuratedAccountsToQueue:accounts];
	[self notifyDelegateIfLastOperation];
	
	//
	// create bulk download queries for twitter by grouping curated accounts by category
	
	NSMutableDictionary* bulkUrls = [[NSMutableDictionary alloc] init];
	
	for(UpdateQueueItem* workQueue in statusUpdateCollection.updateQueue)
	{
		// make sure we're only including the curated tweets in our categories
		if(workQueue.source == CuratedTwitter)
		{
			if([bulkUrls objectForKey:workQueue.category] == nil)
			{
				// we don't have a bulk query URL started yet for this category
				NSString* newUrl = [NSString stringWithFormat:TWITTER_BULK_ENDPOINT, workQueue.curatedUserName];
				[bulkUrls setObject:newUrl forKey:workQueue.category];
			}
			else 
			{
				// bulk query URL already started for this category, let's just append
				NSString* theUrl = [bulkUrls objectForKey:workQueue.category];
				if(theUrl.length < 1000)
				{
					theUrl = [NSString stringWithFormat:TWITTER_BULK_ADDITIONAL_ACCOUNT,theUrl, workQueue.curatedUserName];
					[bulkUrls setObject:theUrl forKey:workQueue.category];
				}
			}
		}
	}
	
	//
	// spin up a new twitter download user timeline object for each category
	
	NSArray* allUrls = [bulkUrls allKeys];
	for(NSString* categoryName in allUrls)
	{		
		TwitterBulkTimelineProvider* tbtp;
		tbtp = [[TwitterBulkTimelineProvider alloc] initBulk:[bulkUrls objectForKey:categoryName]
													category:categoryName
												targetObject:self 
												targetMethod:@selector(handleTwitterBulkUpdate:)];
		[operationQueue addOperation:tbtp];
		numUpdatingOperations++;
		[tbtp release];
	}
	
	[bulkUrls release];
}


- (void)notifyDelegateIfLastOperation
{
	numUpdatingOperations--;
	
	if(numUpdatingOperations==0)
		[[self delegate] allOperationsCompleted];
}


- (bool)isCurrentlyRefreshing
{
	if(numUpdatingOperations==0)
		return NO;
	else 
		return YES;
}


@end
