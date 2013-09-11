//
//  TwitterBulkTimelineProvider.m
//  WhatsUp
//
//  Created by Nathan Buggia on 2/20/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import "TwitterBulkTimelineProvider.h"


@implementation TwitterBulkTimelineProvider

@synthesize twitterResponse;
@synthesize bulkQuery;


- (id)initBulk:(NSString*)request category:(NSString*)cat targetObject:(id)tarObject targetMethod:(SEL)tarMethod
{
	if(self = [super init])
	{
		self.bulkQuery = request;
		targetObject = tarObject;
		targetMethod = tarMethod;

		twitterResponse = [[TwitterResponse alloc] init];
		twitterResponse.category = cat;
	}
	
	return self;
}


- (void)dealloc
{
	[super dealloc];
	[twitterResponse release];
	[bulkQuery release];
}


- (void)main
{
	NSAutoreleasePool *fetcherPool;
	
	@try 
	{
		fetcherPool = [[NSAutoreleasePool alloc] init];
		
		if([self isCancelled])
			return;
		
		if(bulkQuery == nil)
			return;

		NSLog(@"bulkQuery endpoint: %@", bulkQuery);
				
		NSError *error = nil;
		NSURL *url = [NSURL URLWithString:bulkQuery];
		NSString *json = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
		
		if(json)
		{
			twitterResponse.lastUpdate = [[NSDate date] timeIntervalSince1970];
			[self parseJson:json];
		}
		else 
		{
			NSLog(@"error: couldn't download bulk tweets");
		}
		
		// does this really keep it from crashing?
		[twitterResponse retain];
		
		[targetObject performSelectorOnMainThread:targetMethod withObject:twitterResponse waitUntilDone:NO];
	}
	@catch (NSException *e) 
	{
		NSLog(@"Error downloading bulk twitter feeds. Error: %@", [e reason]);
	}
	@finally 
	{
		[fetcherPool release];
	}
}


- (void)parseJson:(NSString*)json
{
	NSDictionary *results = [json JSONValue];
	NSArray *rawTweets = (NSArray *)[results valueForKey:@"results"];
		
	// load the tweets into the array
	for (int i = 0; i < rawTweets.count; i++) 
	{
		NSDictionary *tweet = (NSDictionary *)[rawTweets objectAtIndex:i];
		
		StatusUpdate *update = [[StatusUpdate alloc] init];
		
		update.text = [tweet valueForKey:@"text"];
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
		
		update.source = Twitter;
		
		[twitterResponse.tweets addObject:update];
		[update release];			
	}
}


@end