//
//  WeatherForecast.m
//
//  Created by Nathan Buggia on 1/8/11.
//  Copyright netorion.com 2011. All rights reserved.
//

#import "WeatherForecast.h"


@implementation WeatherForecast

#pragma mark -

@synthesize clickThroughUrl;
@synthesize dayNames;
@synthesize conditionIconUrls;
@synthesize conditionDescriptions;
@synthesize highTemps;
@synthesize lowTemps;
@synthesize precpipitation;

#pragma mark -
#pragma mark Class methods

+ (void)printToConsole:(WeatherForecast*)forecast
{
	if(!forecast)
	{
		NSLog(@"WeatherForecast object is equal to nil.");
		return;
	}
	
	// Print the days
	for(int i=0; i<=7; i++)
	{
		NSLog(@"Day %d", i);
		NSLog(@"\tDay Name: %@", ([forecast.dayNames count] > i) ? [forecast.dayNames objectAtIndex:i] : @"<nil>");
		NSLog(@"\tCondition: %@", ([forecast.conditionDescriptions count] > i) ? [forecast.conditionDescriptions objectAtIndex:i] : @"<nil>");
		NSLog(@"\tHigh Temp: %@", ([forecast.highTemps count] > i) ? [forecast.highTemps objectAtIndex:i] : @"<nil>");
		NSLog(@"\tLow Temp: %@", ([forecast.lowTemps count] > i) ? [forecast.lowTemps objectAtIndex:i] : @"<nil>");
		NSLog(@"\tPrecipitation: %@", ([forecast.precpipitation count] > i) ? [forecast.precpipitation objectAtIndex:i] : @"<nil>");
		NSLog(@"\tIconUrl: %@", ([forecast.conditionIconUrls count] > i) ? [forecast.conditionIconUrls objectAtIndex:i] : @"<nil>");
	}
}

#pragma mark -
#pragma mark Instance methods

- (id)init
{
	[super init];
	
	dayNames = [[NSMutableArray alloc] init];
	conditionIconUrls = [[NSMutableArray alloc] init];
	conditionDescriptions = [[NSMutableArray alloc] init];
	highTemps = [[NSMutableArray alloc] init];
	lowTemps = [[NSMutableArray alloc] init];
	precipitation = [[NSMutableArray alloc] init];
	
	return self;
}


- (void)dealloc
{	
	[super dealloc];
	
	[clickThroughUrl release];
	[dayNames removeAllObjects];
	[dayNames release];
	[conditionIconUrls removeAllObjects];
	[conditionIconUrls release];
	[conditionDescriptions removeAllObjects];
	[conditionDescriptions release];
	[highTemps removeAllObjects];
	[highTemps release];
	[lowTemps removeAllObjects];
	[lowTemps release];
	[precipitation removeAllObjects];
	[precipitation release];
}

@end
