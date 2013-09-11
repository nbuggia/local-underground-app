//
//  Types.h
//  WhatsUp
//
//  Created by Nathan Buggia on 2/20/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {Twitter, CuratedTwitter, NOAA, Foursquare, Yelp, Facebook} UpdateSource;
typedef enum {Weather, Transit, News, Museums, Nightlife, Coupons, Sports, Food, LocalTweets} UpdateCategory;

#define CATEGORY_WEATHER @"Weather"
#define CATEGORY_TRANSIT @"Transit"
#define CATEGORY_NEWS @"News"
#define CATEGORY_MUSEUMS @"Museums"
#define CATEGORY_NIGHTLIFE @"Nightlife"
#define CATEGORY_COUPONS @"Coupons"
#define CATEGORY_SPORTS @"Sports"
#define CATEGORY_FOOD @"Food"
#define CATEGORY_LOCALTWEETS @"Local tweets"
#define CATEGORY_MUNICIPAL @"Municipal"
#define CATEGORY_OUTDOORS @"Parks"
#define CATEGORY_THEATER @"Theater"


@interface Types : NSObject 
{

}

@end
