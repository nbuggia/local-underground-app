//
//  TwitterUserTimelineProvider.m
//  WhatsUp
//
//  Created by Nathan Buggia on 2/4/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import "TwitterUserTimelineProvider.h"


@implementation TwitterUserTimelineProvider

@synthesize userName;
@synthesize twitterResponse;


- (id)initWithUser:(NSString*)user lastUpdate:(double)update targetObject:(id)tarObject targetMethod:(SEL)tarMethod
{
	if(self = [super init])
	{
		userName = user;
		targetObject = tarObject;
		targetMethod = tarMethod;

		twitterResponse = [[TwitterResponse alloc] init];
		twitterResponse.lastUpdate = update;
	}
	
	return self;
}


- (void)dealloc
{
	[super dealloc];
	[userName release];
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
		
		NSString* twitterUrl;
		
		twitterUrl = [NSString stringWithFormat:@"http://twitter.com/statuses/user_timeline/%@.json", userName];
		
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
		NSLog(@"Error downloading twitter user account %@. Error: %@", userName, [e reason]);
	}
	@finally 
	{
		[fetcherPool release];
	}
}


- (void)parseJson:(NSString*)json
{
	SBJSON* parser = [[SBJSON alloc] init];
	
	NSArray* tweets = [parser objectWithString:json error:nil];
		
	// load the tweets into the array
	for (NSDictionary* tweet in tweets)		
	{
		StatusUpdate *update = [[StatusUpdate alloc] init];
		NSDictionary* userInfo = (NSDictionary*)[tweet valueForKey:@"user"];		
		
		update.source = CuratedTwitter;

		// user information located in the user object
		update.userName = [userInfo valueForKey:@"screen_name"];
		update.userId = [userInfo valueForKey:@"id"];
		update.userPhotoUrl = [userInfo valueForKey:@"profile_image_url"];

		// get tweet information out of the base object
		update.text = [TwitterResponse beautifyUpdateText:[tweet valueForKey:@"text"]];
		update.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@/status/%@", update.userName, 
										   [tweet valueForKey:@"id"]]];

		// date
		NSDateFormatter* df = [[NSDateFormatter alloc] init];
		[df setTimeStyle:NSDateFormatterFullStyle];
		[df setFormatterBehavior:NSDateFormatterBehavior10_4];
		[df setDateFormat:@"EEE LLL d HH:mm:ss Z yyyy"];
		update.date = [df dateFromString:[tweet valueForKey:@"created_at"]];		
		[df release];
		
		[twitterResponse.tweets addObject:update];
		[update release];
	}
	
	[parser release];
}


@end
