//
//  CuratedAccountsResponse.h
//  WhatsUp
//
//  Created by Nathan Buggia on 2/19/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Types.h"


@interface CuratedAccountsResponse : NSObject 
{
	NSString* name;
	NSString* category;
	double latitude;
	double longitude;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* category;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

- (id)initWithAccount:(NSString*)n category:(NSString*)c latitude:(double)lat longitude:(double)lon;

@end
