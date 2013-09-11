//
//  CategoryCellView.h
//  WhatsUp
//
//  Created by Nathan Buggia on 2/24/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategoryCellView : UITableViewCell 
{
	UIImageView* photo;
	UILabel* name;
	UILabel* updateCount;
	UILabel* lastUpdate;
}

@property (nonatomic, retain) IBOutlet UIImageView *photo;
@property (nonatomic, retain) IBOutlet UILabel* name;
@property (nonatomic, retain) IBOutlet UILabel* updateCount;
@property (nonatomic, retain) IBOutlet UILabel* lastUpdate;

@end
