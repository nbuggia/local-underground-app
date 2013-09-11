//
//  CategoryViewController.h
//  WhatsUp
//
//  Created by Nathan Buggia on 12/20/10.
//  Copyright netorion.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Types.h"
#import "BrowserViewController.h"
#import "StatusUpdateCollection.h"
#import "StatusUpdateCellView.h"
#import "CellViewGradient.h"
#import "NODateUtils.h"
#import "NOImageFetcher.h"
#import "GANTracker.h"

#define BUTTON_CANCEL @"Cancel"
#define BUTTON_URL_PREFIX @"%@"
#define BUTTON_SHARE @"Email"
#define BUTTON_BROWSER @"Open in Browser"

@interface CategoryViewController : UITableViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{	
	NSMutableDictionary* statusImages;
	NSArray* statusUpdates;
	NSOperationQueue* operationQueue;
	StatusUpdate* selectedUpdate;
}

@property (nonatomic, retain) NSMutableDictionary *statusImages;
@property (nonatomic, retain) NSArray* statusUpdates;
@property (nonatomic, retain) NSOperationQueue* operationQueue;
@property (nonatomic, retain) StatusUpdate* selectedUpdate;

- (UIImage*)getImageForUrl:(NSURL*)url;
- (void)handleImageUpdate:(NSDictionary*)result;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (NSArray*)getUrlsFromString:(NSString*)string;

- (void)displayComposerSheet;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

@end
