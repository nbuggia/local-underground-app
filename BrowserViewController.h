//
//  BrowserViewController.h
//  WhatsUp
//
//  Created by Nathan Buggia on 2/27/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GANTracker.h"


@interface BrowserViewController : UIViewController <UIWebViewDelegate>
{
	UIWebView* webView;
	NSURL* url;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) NSURL* url;


@end
