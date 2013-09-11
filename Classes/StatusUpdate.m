//
//  StatusUpdate.m
//  WhatsUp
//
//  Created by Nathan Buggia on 11/20/10.
//  Copyright netorion.com 2010. All rights reserved.
//

#import "StatusUpdate.h"
#import "JSON.h"

@implementation StatusUpdate

#pragma mark -

@synthesize text;
@synthesize userName;
@synthesize userId;
@synthesize userPhotoSmall;
@synthesize userPhotoUrl;
@synthesize date;
@synthesize url;
@synthesize source;

#pragma mark -
#pragma mark Class methods

+ (void)printToConsole:(StatusUpdate*)statusUpdate
{
	if(!statusUpdate)
	{
		NSLog(@"StatusUpdate object is equal to nil.");
		return;
	}
	
	NSLog(@"Status Update");
	NSLog(@"text: %@", statusUpdate.text);
	NSLog(@"userName: %@", statusUpdate.userName);
	NSLog(@"userId: %@", statusUpdate.userId);
	NSLog(@"userPhotoUrl: %@", statusUpdate.userPhotoUrl);
	NSLog(@"url: %@", statusUpdate.url);

	switch (statusUpdate.source) 
	{
		case CuratedTwitter:
		case Twitter:
			NSLog(@"source: %@", @"Twitter");
			break;
			
		case NOAA:
			NSLog(@"source: %@", @"NOAA");
			break;
			
		case Foursquare:
			NSLog(@"source: %@", @"Foursquare");
			break;

		case Yelp:
			NSLog(@"source: %@", @"Yelp");
			break;

		case Facebook:
			NSLog(@"source: %@", @"Facebook");
			break;
	}
}

#pragma mark -
#pragma mark Instance methods

- (NSComparisonResult)compare:(id)otherObject 
{
    return [self.date compare:otherObject];
}

- (id)init
{
	[super init];
	return self;
}

- (void)dealloc
{
	[text release];
	[userName release];
	[userId release];
	[userPhotoUrl release];
	[date release];
	[url release];
	[userPhotoSmall release];

	[super dealloc];
}

@end
