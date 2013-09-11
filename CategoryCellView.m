//
//  CategoryCellView.m
//  WhatsUp
//
//  Created by Nathan Buggia on 2/24/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import "CategoryCellView.h"

@implementation CategoryCellView

@synthesize photo;
@synthesize name;
@synthesize updateCount;
@synthesize lastUpdate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		UIImage* defaultPhoto = [[UIImage imageNamed:@"user48.png"] retain];
		photo = [[UIImageView alloc] initWithImage:defaultPhoto];
		self.photo.frame = CGRectMake(7, 4, 48, 48);
		[self.contentView addSubview:photo];
		[defaultPhoto release];
		
		name = [[UILabel alloc] initWithFrame:CGRectMake(63, 8, 180, 24)];
		name.textAlignment = UITextAlignmentLeft;
		name.font = [UIFont boldSystemFontOfSize:20];
		name.numberOfLines = 1;
		name.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:name];

		lastUpdate = [[UILabel alloc] initWithFrame:CGRectMake(63, 30, 180, 24)];
		lastUpdate.textAlignment = UITextAlignmentLeft;
		lastUpdate.font = [UIFont systemFontOfSize:13];
		lastUpdate.numberOfLines = 1;
		lastUpdate.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
		lastUpdate.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:lastUpdate];
		
		updateCount = [[UILabel alloc] initWithFrame:CGRectMake(263, 19, 27, 18)];
		updateCount.textAlignment = UITextAlignmentCenter;
		updateCount.font = [UIFont systemFontOfSize:12];
		updateCount.numberOfLines = 1;
		updateCount.textColor = [UIColor whiteColor];
		updateCount.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
		[self.contentView addSubview:updateCount];		
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
	[photo release];
	[name release];
	[updateCount release];
	[lastUpdate release];
}


@end
