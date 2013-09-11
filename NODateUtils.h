//
//  NODateUtils.h
//
//  Created by Nathan Buggia on 1/17/11.
//  Copyright 2011 netorion.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NODateUtils : NSObject 
{

}

// Returns a string with a friendly representation of the difference between
//	two dates (startDate - referenceDate). E.g. 18min ago, or 1hour ago
+(NSString*)getFriendlyTimeFromDateString:(NSDate*)startDate referenceDate:(NSDate*)referenceDate;

@end
