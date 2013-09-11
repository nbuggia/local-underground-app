//
//  UpdateQueueItem.h
//  WhatsUp
//
//  Created by Nathan Buggia on 1/3/11.
//  Copyright netorion.com 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Types.h"

@interface UpdateQueueItem : NSObject 
{
	// Stores who the data provider is
	UpdateSource source;
	
	// URL for the refresh parameters. Allows us to do a delta refresh on the web service
	NSString* refreshUrl;
	
	// NSDate stored as a string so it is mutable
	double lastUpdate;
	
	// if this is a curated twitter account, store the account name here
	NSString* curatedUserName;
	
	// if it is a curated account, it could also have a hard-coded lat/lon
	double latitude, longitude;

	// if it is a curated account, this stores which category it should be grouped with
	NSString* category;
}

@property (nonatomic) UpdateSource source;
@property (nonatomic, retain) NSString* refreshUrl;
@property (nonatomic, retain) NSString* category;
@property (nonatomic) double lastUpdate;
@property (nonatomic, retain) NSString* curatedUserName;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
