//
//  WhatsUpAppDelegate.h
//  WhatsUp
//
//  Created by Nathan Buggia on 12/20/10.
//  Copyright netorion.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "GANTracker.h"

#define GA_ACCOUNT @"UA-21058955-2"
#define GA_DISPATCH_PERIOD 10

@interface WhatsUpAppDelegate : NSObject <UIApplicationDelegate> 
{    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

