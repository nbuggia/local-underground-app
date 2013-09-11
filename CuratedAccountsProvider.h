//
//  CuratedAccountsProvider.h
//  WhatsUp
//
//  Created by Nathan Buggia on 2/5/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CuratedAccountsResponse.h"
#import "Types.h"

@interface CuratedAccountsProvider : NSOperation
{
	double latitude, longitude;
	id targetObject;
	SEL targetMethod;
}

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

- (id)initWithLatitude:(double)lat longitude:(double)lon targetObject:(id)tarObject targetMethod:(SEL)tarMethod;

@end
