//
//  NoaaProvider.m
//
//  Created by Nathan Buggia on 1/27/11.
//  Copyright 2011 netorion.com. All rights reserved.
//

#import "NoaaProvider.h"


@implementation NoaaProvider

@synthesize forecast;
@synthesize wasError;
@synthesize whereAreWe;
@synthesize tempStringBuffer;
@synthesize shouldWriteToTempStringBuffer;
@synthesize lastUpdate;


- (id)initWithLatitude:(double)lat longitude:(double)lon lastUpdate:(double)update targetObject:(id)tarObject targetMethod:(SEL)tarMethod;
{
	if(self = [super init])
	{
		latitude = lat;
		longitude = lon;
		targetObject = tarObject;
		targetMethod = tarMethod;
		lastUpdate = update;
		
		forecast = [[WeatherForecast alloc] init];
		wasError = NO;
		whereAreWe = kUnknown;
		shouldWriteToTempStringBuffer = NO;
		tempStringBuffer = [[NSMutableString alloc] init];
	}
	
	return self;
}


- (void)dealloc
{
	[super dealloc];
	[forecast release];
}


- (void)main
{
	NSAutoreleasePool *fetcherPool;
	
	@try 
	{
		fetcherPool = [[NSAutoreleasePool alloc] init];
		
		if([self isCancelled])
			return;

		// don't update if it has been less than 30 minutes
		if([[NSDate date] timeIntervalSince1970] - self.lastUpdate < 1800)
			return;
		
		NSString *lat = [NSString stringWithFormat:@"%g", latitude];
		NSString *lon = [NSString stringWithFormat:@"%g", longitude];
		
		forecast.clickThroughUrl = [NSString stringWithFormat:NOAA_CLICKTHROUGH_URL, lat, lon];	

		NSURL *apiUrl = [NSURL URLWithString:[NSString stringWithFormat:NOAA_API_ENDPOINT, lat, lon]];
		
		NSLog(@"NOAA endpoint: %@", [apiUrl absoluteURL]);		
		
	    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:apiUrl];
		[parser setDelegate:self];
		[parser parse];	
		[parser release];		
	}
	@catch (NSException *e) 
	{
		NSLog(@"Error downloading weather from NOAA. %@", [e reason]);
	}
	@finally 
	{
		[fetcherPool release];
	}
}


#pragma mark -
#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict 
{
	//
	// check if we got a valid response back or if it is an error
	//
	
	if([elementName isEqualToString:@"h2"])
	{
		NSLog(@"NOAA sent back an error message, hit \'refresh\'");
		return;
	}
	
	//
	// weather conditions is different because it is stored in an attribute, not an element
	// 
	
	if([elementName isEqualToString:@"weather-conditions"])
	{
        NSString *newStr = [attributeDict objectForKey:@"weather-summary"];
		if(newStr != nil)
			[forecast.conditionDescriptions addObject:newStr];
		else
			NSLog(@"Error: NOAA returned nil for weather-condition.");
		
		return;
	}	
	
	//
	// figure out where we are in the xml file
	//
	
	if([elementName isEqualToString:@"temperature"])
	{
		NSString *typeAttribute = [attributeDict valueForKey:@"type"];
		
		if([typeAttribute isEqualToString:@"maximum"])
		{
			whereAreWe = kHighTemp;
		}
		else
		{
			whereAreWe = kLowTemp;
		}
	}
	else if([elementName isEqualToString:@"probability-of-precipitation"])
	{
		whereAreWe = kPrecipitation;
	}
	
	//
	// Turn on recording if we're within one of our tags
	//
	
	if([elementName isEqualToString:@"value"] ||
	   [elementName isEqualToString:@"icon-link"])
	{
		shouldWriteToTempStringBuffer = YES;
		[tempStringBuffer setString:@""];
	}	
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName 
{ 
	NSString* newStr;
	
	// HIGH TEMP, LOW TEMP, PERCIPITATION
	if([elementName isEqualToString:@"value"])
	{
		newStr = [NSString stringWithString:tempStringBuffer];
		
		switch (whereAreWe) 
		{
			case kHighTemp:
				if(newStr != nil)
					[forecast.highTemps addObject:newStr];
				else
					NSLog(@"Error: NOAA returned nil for high temp.");
				break;
				
			case kLowTemp:
				if(newStr != nil)
					[forecast.lowTemps addObject:newStr];
				else
					NSLog(@"Error: NOAA returned nil for low temp.");
				break;
				
			case kPrecipitation:
				if(newStr != nil)
					[forecast.precpipitation addObject:newStr];
				else
					NSLog(@"Error: NOAA returned nil for precipitation.");
				break;
		}
	}
	
	// WEATHER CONDITIONS
	else if([elementName isEqualToString:@"weather-conditions"])
	{
		newStr = [NSString stringWithString:tempStringBuffer];
		[forecast.conditionDescriptions addObject:newStr];
	}
	
	// ICON Url
	else if([elementName isEqualToString:@"icon-link"])
	{
		newStr = [NSString stringWithString:tempStringBuffer];
		[forecast.conditionIconUrls addObject:newStr];
	}
	
	// now that we're at the end of the element, turn off writing to buffer until didStartElement
	//	finds a new tag we're interested in.
	shouldWriteToTempStringBuffer = NO;	
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{
	if(shouldWriteToTempStringBuffer)
	{
		[tempStringBuffer appendString:string];
	}
}


-(void)parserDidEndDocument:(NSXMLParser*)parser
{	
	if(!wasError)
	{
		// does this really keep it from crashing?
		[forecast retain];
		[targetObject performSelectorOnMainThread:targetMethod withObject:forecast waitUntilDone:NO];
	}
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
	wasError = YES;
	NSLog(@"Error downloading weather from NOAA. %@", [parser description]);
}

@end
