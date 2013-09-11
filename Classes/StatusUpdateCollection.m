//
//  StatusUpdateCollection.m
//  WhatsUp
//
//  Created by Nathan Buggia on 12/25/10.
//  Copyright netorion.com 2011. All rights reserved.
//

#import "StatusUpdateCollection.h"

@implementation StatusUpdateCollection

#pragma mark -

@synthesize statusUpdates;
@synthesize updateQueue;

#pragma mark -
#pragma mark Instance methods


// TODO: store a small image URL and a large image URL. Use the small image for the CategoryViewController

- (id)init
{
	[super init];
	
	statusUpdates = [[NSMutableDictionary alloc] init];	
	updateQueue = [[NSMutableArray alloc] init];
		
	// Weather from NOAA
	UpdateQueueItem *noaa = [[UpdateQueueItem alloc] init];
	noaa.source = NOAA;
	noaa.refreshUrl = nil;
	noaa.curatedUserName = nil;
	noaa.lastUpdate = 0;
	noaa.category = CATEGORY_WEATHER;
	noaa.latitude = 0;
	noaa.longitude = 0;
	[updateQueue addObject:noaa];
	[noaa release];

	// Twitter Local
	UpdateQueueItem	*twitter = [[UpdateQueueItem alloc] init];
	twitter.source = Twitter;
	twitter.refreshUrl = nil;
	twitter.curatedUserName = nil;
	twitter.lastUpdate = 0;
	twitter.category = CATEGORY_LOCALTWEETS;
	twitter.latitude = 0;
	twitter.longitude = 0;
	[updateQueue addObject:twitter];		
	[twitter release];
	
	return self;
}


- (void)addCuratedAccountsToQueue:(NSArray*)accounts
{		
	for(CuratedAccountsResponse* account in accounts)
	{
		UpdateQueueItem *uqi = [[UpdateQueueItem alloc] init];
		uqi.source = CuratedTwitter;
		uqi.refreshUrl = nil;
		uqi.lastUpdate = 0;
		uqi.curatedUserName = account.name;
		uqi.category = account.category;
		uqi.latitude = account.latitude;
		uqi.longitude = account.longitude;
		[updateQueue addObject:uqi];
		[uqi release];
	}
}


- (void)expunge
{
	NSMutableArray* deletableQueueItems = [[NSMutableArray alloc] init];
	
	// bring the work queue back to its initialized state 
	for(UpdateQueueItem* item in updateQueue)
	{
		if(item.source == CuratedTwitter)
		{
			[deletableQueueItems addObject:item];
		}
		else 
		{
			// this is a work item we fetch for every lat/lon
			item.lastUpdate = 0;
			item.refreshUrl = nil;			
		}
	}
	
	[deletableQueueItems removeAllObjects];
	[deletableQueueItems release];

	[statusUpdates removeAllObjects];
}


- (void)addWeather:(WeatherForecast*)forecast
{		
	StatusUpdate* weatherUpdate = [[StatusUpdate alloc] init];
	weatherUpdate.source = NOAA;
	
	NSString* conditions = [NSString stringWithString:([forecast.conditionDescriptions objectAtIndex:0]) ? 
							[forecast.conditionDescriptions objectAtIndex:0] : @"Not available"];
	
	NSString* highTemp = [NSString stringWithString:([forecast.highTemps objectAtIndex:0]) ? 
						  [forecast.highTemps objectAtIndex:0] : @"-"];
	
	NSString* lowTemp = [NSString stringWithString:([forecast.lowTemps objectAtIndex:0]) ? 
						 [forecast.lowTemps objectAtIndex:0] : @"-"];

	// hack, repurposing the userName field for the new RootViewController template
	weatherUpdate.text = [NSString stringWithFormat:@"High: %@°, Low: %@°", highTemp, lowTemp];
	weatherUpdate.userName = conditions;
	
	weatherUpdate.url = [NSURL URLWithString:[NSString stringWithString:forecast.clickThroughUrl]];
	weatherUpdate.userPhotoUrl = [NSString stringWithString:[forecast.conditionIconUrls objectAtIndex:0]];
	weatherUpdate.date = [NSDate date];
	
	[statusUpdates setObject:weatherUpdate forKey:CATEGORY_WEATHER];	
		
	[weatherUpdate release];
}


int dateSort(id obj1, id obj2, void* context)
{
	double d1 = [((StatusUpdate*)obj1).date timeIntervalSince1970];
	double d2 = [((StatusUpdate*)obj2).date timeIntervalSince1970];

	if(d1>d2)
		return -1;
	else if(d1<d2)
		return 1;
	else
		return 0;
}


- (void)addTweets:(NSArray*)tweets inCategory:(NSString*)category
{
	NSMutableArray* wantedTweets = [[NSMutableArray alloc] init];
	
	for(StatusUpdate* t in tweets)
	{
		if(![self shouldDeleteUpdate:t])
			[wantedTweets addObject:t];
	}
	
	if([wantedTweets count] == 0)
	{
		[wantedTweets release];
		return;
	}
	
	if([wantedTweets count] > 1)
		[wantedTweets sortUsingFunction:dateSort context:nil];
	
	[statusUpdates setObject:wantedTweets forKey:category];
	[wantedTweets release];
}


- (bool)shouldDeleteUpdate:(StatusUpdate*)s
{
	// direct tweet, these tend to not be interesting to everyone
	if([s.text characterAtIndex:0] == '@')
		return YES;
	
	// retweet, we'll just include the original thank you very much
	if([s.text characterAtIndex:0] == 'R' &&
	   [s.text characterAtIndex:1] == 'T' &&
	   [s.text characterAtIndex:2] == ' ')
		return YES;
	
	// if update is more than 24 hours old
	if([[NSDate date] timeIntervalSince1970] - [s.date timeIntervalSince1970] > 86400)
		return YES;
	
	return NO;	
}


- (void)dealloc
{	
	[super dealloc];

	[updateQueue removeAllObjects];
	[updateQueue release];
	[statusUpdates removeAllObjects];
	[statusUpdates release];
}


@end
