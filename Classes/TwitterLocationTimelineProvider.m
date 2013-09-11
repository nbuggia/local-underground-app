//
//  TwitterProvider.m
//
//  Created by Nathan Buggia on 1/27/11.
//  Copyright 2011 netorion.com. All rights reserved.
//

#import "TwitterLocationTimelineProvider.h"

@implementation TwitterLocationTimelineProvider

@synthesize twitterResponse;
@synthesize latitude;
@synthesize longitude;


- (id)initWithLatitude:(double)lat longitude:(double)lon lastUpdate:(double)update refreshUrl:(NSString*)newUrl
		 targetObject:(id)tarObject targetMethod:(SEL)tarMethod
{
	if(self = [super init])
	{
		latitude = lat;
		longitude = lon;
		targetObject = tarObject;
		targetMethod = tarMethod;

		twitterResponse = [[TwitterResponse alloc] init];
		twitterResponse.lastUpdate = update;
		twitterResponse.refreshUrl = newUrl;		
	}
	
	return self;
}


- (void)dealloc
{
	[super dealloc];
	[twitterResponse release];
}


- (void)main
{
	NSAutoreleasePool *fetcherPool;
	
	@try 
	{
		fetcherPool = [[NSAutoreleasePool alloc] init];
		
		if([self isCancelled])
			return;
		
		NSString *twitterUrl = [self buildTwitterApiUrl];
		if(twitterUrl == nil)
			return;

		NSLog(@"Twitter location endpoint: %@", twitterUrl);		
		
		NSError *error = nil;
		NSURL *url = [NSURL URLWithString:twitterUrl];
		NSString *json = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
		
		if(json)
		{
			twitterResponse.lastUpdate = [[NSDate date] timeIntervalSince1970];
			[self parseJson:json];
		}
		else 
		{
			NSLog(@"error: couldn't download tweets");
		}
		
		[targetObject performSelectorOnMainThread:targetMethod withObject:self.twitterResponse waitUntilDone:NO];
	}
	@catch (NSException *e) 
	{
		NSLog(@"Error downloading location-based tweets. %@", [e reason]);
	}
	@finally 
	{
		[fetcherPool release];
	}
}


- (NSString*)buildTwitterApiUrl
{
	double now = [[NSDate date] timeIntervalSince1970];
	NSString *updateUrl = nil;

	// don't update if it has been less than 30 seconds
	if(now - self.twitterResponse.lastUpdate < 30)
	{
		return nil;
	}

	// we're running this for the first time, full update!
	else if(0 == twitterResponse.lastUpdate)
	{
		updateUrl = [NSString stringWithFormat:@"http://search.twitter.com/search.json?geocode=%g,%g,1mi&rpp=%@&page=1", 
					 latitude, longitude, TWITTER_NUM_RESULTS];
	}

	// it has been updated before, but longer than 60 secs, so let's use the delta update	
	else 
	{
		updateUrl = [NSString stringWithFormat:@"http://search.twitter.com/search.json%@geocode=%g,%g,1mi&rpp=%@&page=1", 
					 twitterResponse.refreshUrl, latitude, longitude, TWITTER_NUM_RESULTS];
	}
	
	return updateUrl;
}


- (void)parseJson:(NSString*)json
{
	NSDictionary *results = [json JSONValue];
	NSArray *rawTweets = (NSArray *)[results valueForKey:@"results"];
	
	self.twitterResponse.refreshUrl = (NSString*)[results valueForKey:@"refresh_url"];
	
	// load the tweets into the array
	for (int i = 0; i < rawTweets.count; i++) 
	{
		NSDictionary *tweet = (NSDictionary *)[rawTweets objectAtIndex:i];
		
		StatusUpdate *update = [[StatusUpdate alloc] init];
		
		update.text = [TwitterResponse beautifyUpdateText:[tweet valueForKey:@"text"]];
		update.userName = [tweet valueForKey:@"from_user"];
		update.userId = [tweet valueForKey:@"from_user_id"];
		update.userPhotoUrl = [tweet valueForKey:@"profile_image_url"];
		update.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@/status/%@", update.userName, 
										   [tweet valueForKey:@"id"]]];		
		
		// date
		NSDateFormatter* df = [[NSDateFormatter alloc] init];
		[df setTimeStyle:NSDateFormatterFullStyle];
		[df setFormatterBehavior:NSDateFormatterBehavior10_4];
		[df setDateFormat:@"EEE, d LLL yyyy HH:mm:ss Z"];
		update.date = [df dateFromString:[tweet valueForKey:@"created_at"]];		
		[df release];
		
		NSString *source = [tweet valueForKey:@"source"];
		if([source rangeOfString:@"foursquare"].location != NSNotFound){
			update.source = Foursquare;
		}
		else if([source rangeOfString:@"yelp"].location != NSNotFound){
			update.source = Yelp;
		}
		else if([source rangeOfString:@"facebook"].location != NSNotFound){
			update.source = Facebook;
		}
		
		[twitterResponse.tweets addObject:update];
		[update release];			
	}
}


@end
