//
//  CellViewGradient.m
//  WhatsUp
//
//  Created by Nathan Buggia on 1/22/11.
//  Copyright 2011 netorion.com. All rights reserved.
//
// http://cocoawithlove.com/2009/08/adding-shadow-effects-to-uitableview.html

#import "CellViewGradient.h"


@implementation CellViewGradient

+(Class)layerClass
{
	return [CAGradientLayer class];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if (self)
	{
		CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
		gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], 
								(id)[[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0] CGColor], 
								nil];
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
