//
//  NODateUtils.m
//
//  Created by Nathan Buggia on 1/17/11.
//  Copyright 2011 netorion.com. All rights reserved.
//

#import "NODateUtils.h"


@implementation NODateUtils


+(NSString*)getFriendlyTimeFromDateString:(NSDate*)startDate referenceDate:(NSDate*)referenceDate
{	
	NSString *friendlyDate = nil;
	double difference = fabs([startDate timeIntervalSince1970] - [referenceDate timeIntervalSince1970]);
	
	int num;
		
	// 0 secs	
	if (difference <= 1) {
		friendlyDate = [NSString stringWithFormat:@"%d secs", (int)difference];
	}
	
	// 1 sec
	else if(difference > 1 && difference <= 2){
		friendlyDate = [NSString stringWithFormat:@"%d sec", (int)difference];		
	}

	// 59 secs
	else if(difference > 2 && difference <= 59){
		friendlyDate = [NSString stringWithFormat:@"%d secs", (int)difference];
	}
	
	// 1 min
	else if(difference >= 60 && difference < 120){
		num = (int)(difference / 60);
		friendlyDate = [NSString stringWithFormat:@"%d min", num];
	}
	
	// 59 mins
	else if(difference >= 120 && difference <= 3600){
		num = (int)(difference / 60);
		friendlyDate = [NSString stringWithFormat:@"%d min", num];		
	}
	
	// 1 hr
	else if(difference > 3600 && difference < 7200){
		num = (int)(difference / 3600);
		friendlyDate = [NSString stringWithFormat:@"%d hour", num];		
	}
	
	// 23 hrs
	else if(difference > 7200 && difference < 86400){
		num = (int)(difference / 3600);
		friendlyDate = [NSString stringWithFormat:@"%d hours", num];
	}
	
	// 1 day
	else if(difference > 86400 /*secs in a day*/ && difference < 172800 /*secs in two days*/){
		num = (int)(difference / 86400);
		friendlyDate = [NSString stringWithFormat:@"%d day", num];
	}
	
	// TODO: forgot weeks and months. Seriously, how could I forget those!!
	
	// 364 days
	else if(difference > 172800 /*secs in two days*/ && difference < 31556926 /*secs in a year*/)
	{
		num = (int)(difference / 86499);
		friendlyDate = [NSString stringWithFormat:@"%d days", num];
	}
	
	// 999 years
	else if(difference > 31556926){
		num = (int)(difference / 31556926);
		
		if(num == 1)
			friendlyDate = [NSString stringWithFormat:@"%d year", num];
		else 
			friendlyDate = [NSString stringWithFormat:@"%d years", num];
	}
	
	return friendlyDate;
}

@end
