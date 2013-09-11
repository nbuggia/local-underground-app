//
//  AboutViewController.h
//  WhatsUp
//
//  Created by Nathan Buggia on 12/30/10.
//  Copyright netorion.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GANTracker.h"

@protocol AboutViewControllerDelegate;


@interface AboutViewController : UIViewController 
{
	id <AboutViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id delegate;

- (void)clickDone:(id)sender;

@end


@protocol AboutViewControllerDelegate

- (void)aboutViewClose:(AboutViewController *)aboutViewController;

@end
