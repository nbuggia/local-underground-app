//
//  TwitterUserTimelineProvider.h
//  WhatsUp
//
//  Created by Nathan Buggia on 2/4/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "StatusUpdate.h"
#import "TwitterResponse.h"


@interface TwitterUserTimelineProvider : NSOperation 
{
	NSString* userName;
	TwitterResponse* twitterResponse;
	id targetObject;
	SEL targetMethod;
}

@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) TwitterResponse* twitterResponse;

- (id)initWithUser:(NSString*)user lastUpdate:(double)update targetObject:(id)tarObject targetMethod:(SEL)tarMethod;
- (void)parseJson:(NSString*)json;

@end
