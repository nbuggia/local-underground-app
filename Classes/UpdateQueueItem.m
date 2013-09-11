//
//  UpdateQueueItem.m
//  WhatsUp
//
//  Created by Nathan Buggia on 1/3/11.
//  Copyright netorion.com 2011. All rights reserved.
//

#import "UpdateQueueItem.h"

@implementation UpdateQueueItem

#pragma mark -

@synthesize source;
@synthesize category;
@synthesize refreshUrl;
@synthesize lastUpdate;
@synthesize curatedUserName;
@synthesize latitude;
@synthesize longitude;

#pragma mark -

-(id)init
{
	[super init];
	return self;
}

- (void)dealloc
{	
	[super dealloc];
	
	[refreshUrl release];
	[curatedUserName release];
	[category release];
}

@end
