//
//  StatusUpdateCellView.m
//  WhatsUp
//
//  Created by Nathan Buggia on 12/29/10.
//  Copyright 2010 netorion.com. All rights reserved.
//

#import "StatusUpdateCellView.h"


@implementation StatusUpdateCellView

#pragma mark -

@synthesize userPhoto;
@synthesize updateText;
@synthesize userName;
@synthesize updateTimePosted;
@synthesize gradient;

static const int PRIMARY_TEXT_FONT_SIZE = 14;
static const int SECONDARY_TEXT_FONT_SIZE = 12;
static const int IMAGE_COL_WIDTH = TWITTER_USER_ICON_MINI_WIDTH;
static const int MAX_ROW_HEIGHT = 300;
static const int PADDING = 10;
static const int FOOTER_ROW_HEIGHT = 14;
static const int UPDATE_COL_WIDTH = 266; // 320 - (TWITTER_USER_ICON_MINI_WIDTH + PADDING*3);

/*************************************************************************
 *
 * Class methods
 *
 ************************************************************************/

#pragma mark -
#pragma mark Class methods

//------------------------------------------------------------------------ getLabelHeightForStatusText
//
// calculate the height of the statusText label based on any given text string
//

+(int)getLabelHeightForStatusText:(NSString*)statusText
{
    UIFont *cellFont = [UIFont systemFontOfSize:PRIMARY_TEXT_FONT_SIZE];
    CGSize constraintSize = CGSizeMake(UPDATE_COL_WIDTH, MAX_ROW_HEIGHT);
    CGSize labelSize = [statusText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];

	return labelSize.height;
}

//------------------------------------------------------------------------ getRowHeightForStatusText
//
// calculate the height of an entire row adding in all the various padding and dynamic elements
//

+(int)getRowHeightForStatusText:(NSString*)statusText
{
    return PADDING + [StatusUpdateCellView getLabelHeightForStatusText:statusText] + PADDING + FOOTER_ROW_HEIGHT + PADDING;	
}

//------------------------------------------------------------------------ updateCellPositionsWithStatusTextLabelHeight
//
// helper function for the tableview to take care of resizing the dynamic elements at run time
//

+(StatusUpdateCellView*)updateCellPositionsWithStatusTextLabelHeight:(StatusUpdateCellView*)cell
{
	if(cell != nil)
	{
		int height = [StatusUpdateCellView getLabelHeightForStatusText:cell.updateText.text];
	
		cell.updateText.frame = CGRectMake(PADDING*2+IMAGE_COL_WIDTH, PADDING, UPDATE_COL_WIDTH, height);
		cell.userName.frame = CGRectMake(PADDING*2+IMAGE_COL_WIDTH, height+PADDING*2, 175, FOOTER_ROW_HEIGHT);
		cell.updateTimePosted.frame = CGRectMake(245-PADDING, height+PADDING*2, 75, FOOTER_ROW_HEIGHT);
	}
	
	return cell;
}

#pragma mark -

//------------------------------------------------------------------------ init
//
// Draws the custom cell for displaying status updates. There are two columns every row,
//	the first column is for the user icon and a quick display of how old the update is,
//	the second column contains the status update, username and full update time.
//
// Note that the height of the updateText field, and consequently the down (Y) position
//	for the userName and updateTimePosted won't be known until we see how many lines the 
//	updateText will wrap. This is calculated on the fly and updated via the 
//	+updateCellPositionsWithStatusTextLabelHeight method
//
// Location: (across, down, width, height)
// Colum 1: (  5,  5,  24,   x)
// Colum 2: ( 34,  5, 281,   x)

- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier 
{
	//TODO: round the corners of the icons: http://stackoverflow.com/questions/262156/uiimage-rounded-corners 
	
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
	{
		static const int PLACEHOLDER_HEIGHT = 100;
		
		// USER PHOTO
		// TODO: do I have another memory leak here? I say retain, but where do I release this memory?
		UIImage *defaultUserPhoto = [[UIImage imageNamed:@"user24.png"] retain];
		userPhoto = [[UIImageView alloc] initWithImage:defaultUserPhoto];
		self.userPhoto.frame = CGRectMake(PADDING, PADDING, IMAGE_COL_WIDTH, TWITTER_USER_ICON_MINI_HEIGHT);
		[self.contentView addSubview:userPhoto];
		[defaultUserPhoto release];
		
		// UPDATE TEXT
		updateText = [[UILabel alloc] initWithFrame:CGRectMake(PADDING*2+IMAGE_COL_WIDTH, PADDING, UPDATE_COL_WIDTH, PLACEHOLDER_HEIGHT)];
		updateText.textAlignment = UITextAlignmentLeft;
		updateText.font = [UIFont systemFontOfSize:PRIMARY_TEXT_FONT_SIZE];
		updateText.numberOfLines = 0;
		updateText.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:updateText];
		
		// USERNAME
		userName = [[UILabel alloc] initWithFrame:CGRectMake(PADDING*2+IMAGE_COL_WIDTH, PLACEHOLDER_HEIGHT, 175, FOOTER_ROW_HEIGHT)];
		userName.textAlignment = UITextAlignmentLeft;
		userName.font = [UIFont systemFontOfSize:SECONDARY_TEXT_FONT_SIZE];
		userName.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
		userName.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:userName];
		
		// UPDATE DATE/TIME
		updateTimePosted = [[UILabel alloc] initWithFrame:CGRectMake(245-PADDING, PLACEHOLDER_HEIGHT, 75, FOOTER_ROW_HEIGHT)];
		updateTimePosted.textAlignment = UITextAlignmentRight;
		updateTimePosted.font = [UIFont systemFontOfSize:SECONDARY_TEXT_FONT_SIZE];
		updateTimePosted.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
		updateTimePosted.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:updateTimePosted];		
    }
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc 
{
    [super dealloc];

	[userPhoto release];
	[updateText release];
	[userName release];
	[updateTimePosted release];
	[gradient release];
}

@end
