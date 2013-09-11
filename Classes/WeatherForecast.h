//
//  WeatherForecast.h
//
//  Created by Nathan Buggia on 1/8/11.
//  Copyright netorion.com 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherForecast : NSObject 
{
	@private
	NSString *clickThroughUrl;
	NSMutableArray *dayNames;
	NSMutableArray *conditionIconUrls;
	NSMutableArray *conditionDescriptions;
	NSMutableArray *highTemps;
	NSMutableArray *lowTemps;
	NSMutableArray *precipitation;
}

@property (nonatomic, retain) NSString *clickThroughUrl;
@property (nonatomic, retain) NSMutableArray *dayNames;
@property (nonatomic, retain) NSMutableArray *conditionIconUrls;
@property (nonatomic, retain) NSMutableArray *conditionDescriptions;
@property (nonatomic, retain) NSMutableArray *highTemps;
@property (nonatomic, retain) NSMutableArray *lowTemps;
@property (nonatomic, retain) NSMutableArray *precpipitation;

+ (void)printToConsole:(WeatherForecast*)forecast;

@end
