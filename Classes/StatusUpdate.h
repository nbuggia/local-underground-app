//
//  StatusUpdate.h
//  WhatsUp
//
//  Created by Nathan Buggia on 11/20/10.
//  Copyright netorion.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Types.h"

#define TWITTER_USER_ICON_NORMAL_WIDTH 48
#define TWITTER_USER_ICON_NORMAL_HEIGHT 48
#define TWITTER_USER_ICON_MINI_WIDTH 24
#define TWITTER_USER_ICON_MINI_HEIGHT 24


@interface StatusUpdate : NSObject 
{
	NSString* text;
	NSString* userName;
	NSString* userId;
	UIImage* userPhotoSmall;
	NSString* userPhotoUrl;
	NSDate* date;
	NSURL* url;
	UpdateSource source;
}

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) UIImage* userPhotoSmall;
@property (nonatomic, retain) NSString* userPhotoUrl;
@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic) UpdateSource source;

+(void)printToConsole:(StatusUpdate*)statusUpdate;

@end
