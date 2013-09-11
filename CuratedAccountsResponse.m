//
//  CuratedAccountsResponse.m
//  WhatsUp
//
//  Created by Nathan Buggia on 2/19/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import "CuratedAccountsResponse.h"

@implementation CuratedAccountsResponse

@synthesize name;
@synthesize category;
@synthesize latitude;
@synthesize longitude;

- (id)initWithAccount:(NSString*)n category:(NSString*)c latitude:(double)lat longitude:(double)lon;
{
	if(self = [super init])
	{
		name = n;
		category = c;
		latitude = lat;
		longitude = lon;
	}

	return self;
}

- (void)dealloc
{
	[super dealloc];
	[name release];
	[category release];
}

@end
