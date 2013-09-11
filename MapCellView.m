//
//  MapCellView.m
//  WhatsUp
//
//  Created by Nathan Buggia on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapCellView.h"


@implementation MapCellView

@synthesize mapView;

#pragma mark -


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
	{
		// Map
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
		mapView.zoomEnabled = NO;
		mapView.scrollEnabled = NO;
		mapView.userInteractionEnabled = NO;
		mapView.multipleTouchEnabled = NO;
		[self.contentView addSubview:mapView];		
    }
		
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
}


- (void)dealloc 
{
    [super dealloc];
	[mapView release];
}


@end
