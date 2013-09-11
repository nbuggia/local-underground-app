//
//  StatusUpdateCellView.h
//  WhatsUp
//
//  Created by Nathan Buggia on 12/29/10.
//  Copyright 2010 netion.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "StatusUpdate.h"

@interface StatusUpdateCellView : UITableViewCell 
{
	UIImageView *userPhoto;
	UILabel *updateText;
	UILabel *userName;
	UILabel *updateTimePosted;
	CAGradientLayer *gradient;
	
}

@property (nonatomic, retain) UIImageView *userPhoto;
@property (nonatomic, retain) UILabel *updateText;
@property (nonatomic, retain) UILabel *userName;
@property (nonatomic, retain) UILabel *updateTimePosted;
@property (nonatomic, retain) CAGradientLayer *gradient;

+(int)getLabelHeightForStatusText:(NSString*)statusText;
+(int)getRowHeightForStatusText:(NSString*)statusText;
+(StatusUpdateCellView*)updateCellPositionsWithStatusTextLabelHeight:(StatusUpdateCellView*)cell;

@end
