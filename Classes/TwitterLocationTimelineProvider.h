//
//  NOTwitterProvider.h
//
//  Created by Nathan Buggia on 1/27/11.
//  Copyright 2011 netorion.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "StatusUpdate.h"
#import "TwitterResponse.h"

#define TWITTER_NUM_RESULTS @"100"

// Twitter has 3 sizes for each profile photo, this is how we distinguish between them
typedef enum {TwitterProfilePhotoSmall, TwitterProfilePhotoMedium, TwitterProfilePhotoLarge} TwitterProfilePhotoSize;

@interface TwitterLocationTimelineProvider : NSOperation 
{
	TwitterResponse* twitterResponse;
	double latitude, longitude;
	id targetObject;
	SEL targetMethod;
}

@property (nonatomic, retain) TwitterResponse* twitterResponse;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;


- (id)initWithLatitude:(double)lat longitude:(double)lon lastUpdate:(double)update refreshUrl:(NSString*)newUrl
		 targetObject:(id)tarObject targetMethod:(SEL)tarMethod;

- (NSString*)buildTwitterApiUrl;
- (void)parseJson:(NSString *)json;

@end
