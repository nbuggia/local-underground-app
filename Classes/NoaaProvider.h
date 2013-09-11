//
//  NoaaProvider.h
//
//  Created by Nathan Buggia on 1/27/11.
//  Copyright 2011 netorion.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherForecast.h"

#define NOAA_CLICKTHROUGH_URL @"http://forecast.weather.gov/MapClick.php?lat=%@&lon=%@"
#define NOAA_API_ENDPOINT @"http://www.weather.gov/forecasts/xml/sample_products/browser_interface/ndfdBrowserClientByDay.php?lat=%@&lon=%@&format=24+hourly"

typedef enum {kUnknown, kHighTemp, kLowTemp, kPrecipitation} NoaaXmlPathLocations;

@interface NoaaProvider : NSOperation <NSXMLParserDelegate>
{
	double latitude, longitude;
	id targetObject;
	SEL targetMethod;
	double lastUpdate;
	
	WeatherForecast *forecast;
	bool wasError;
	bool shouldWriteToTempStringBuffer;	
	NSMutableString *tempStringBuffer;
	NoaaXmlPathLocations whereAreWe;		
}

@property (nonatomic, retain) WeatherForecast *forecast;
@property (nonatomic) double lastUpdate;
@property (nonatomic) bool wasError;
@property (nonatomic) NoaaXmlPathLocations whereAreWe;
@property (nonatomic, retain) NSString *tempStringBuffer;
@property (nonatomic) bool shouldWriteToTempStringBuffer;

- (id)initWithLatitude:(double)lat longitude:(double)lon lastUpdate:(double)update targetObject:(id)tarObject targetMethod:(SEL)tarMethod;


@end
