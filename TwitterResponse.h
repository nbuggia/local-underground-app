//
//  NOTwitterResponse.h
//
//  Created by Nathan Buggia on 1/28/11.
//  Copyright 2011 netorion.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusUpdate.h"


@interface TwitterResponse : NSObject 
{
	// all providers store the tweets we downloaded here
	NSMutableArray* tweets;

	// input parameter specifing when the last update was so we can determine how thorough of a refresh to perform
	double lastUpdate;
	
	// TwitterLocationTimeline uses this to store the incremental update URL for refreshing
	NSString* refreshUrl;

	// if the TwitterBulkTimelineProvider is returning this, then it will specify category the tweets are from
	NSString* category;
}

@property (nonatomic, retain) NSMutableArray* tweets;
@property (nonatomic, retain) NSString* refreshUrl;
@property (nonatomic, retain) NSString* category;
@property (nonatomic) double lastUpdate;

+ (NSString*)beautifyUpdateText:(NSString*)updateText;
+ (NSString*)simpleXMLUnencode:(NSString*)string;

@end
