//
//  TwitterBulkTimelineProvider.h
//  WhatsUp
//
//  Created by Nathan Buggia on 2/20/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "StatusUpdate.h"
#import "TwitterResponse.h"

#define TWITTER_BULK_ENDPOINT @"http://search.twitter.com/search.json?q=from:%@"
#define TWITTER_BULK_ADDITIONAL_ACCOUNT @"%@+OR+from:%@"

@interface TwitterBulkTimelineProvider : NSOperation 
{
	TwitterResponse* twitterResponse;
	NSString* bulkQuery;	
	id targetObject;
	SEL targetMethod;
}

@property (nonatomic, retain) NSString* bulkQuery;
@property (nonatomic, retain) TwitterResponse* twitterResponse;

- (id)initBulk:(NSString*)request category:(NSString*)cat targetObject:(id)tarObject targetMethod:(SEL)tarMethod;
- (void)parseJson:(NSString *)json;

@end
