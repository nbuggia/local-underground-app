//
//  TwitterResponse.m
//  WhatsUp
//
//  Created by Nathan Buggia on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TwitterResponse.h"

@implementation TwitterResponse

@synthesize tweets;
@synthesize refreshUrl;
@synthesize lastUpdate;
@synthesize category;

#pragma mark -
#pragma mark Instance methods


- (id)init
{
	[super init];

	tweets = [[NSMutableArray alloc] init];
	lastUpdate = 0.0;
	
	return self;
}


- (void)dealloc
{
	[tweets removeAllObjects];
	[tweets release];
	[category release];
	[refreshUrl release];
	refreshUrl = nil;
	
	[super dealloc];
}


#pragma mark -
#pragma mark Class methods


+ (NSString*)beautifyUpdateText:(NSString*)updateText
{
	return [TwitterResponse simpleXMLUnencode:updateText];
}


+ (NSString*)simpleXMLUnencode:(NSString*)string
{
	NSString *returnStr = nil;
	
    if(string)
    {
        returnStr = [string stringByReplacingOccurrencesOfString:@"&amp;" withString: @"&"];
        returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&#x27;" withString:@"'"];
        returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&#x39;" withString:@"'"];
        returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&#x92;" withString:@"'"];
        returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&#x96;" withString:@"'"];
        returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
		returnStr = [[NSString alloc] initWithString:returnStr];
    }
	
    return returnStr;
}


@end
