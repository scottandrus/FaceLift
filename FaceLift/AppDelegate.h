//
//  AppDelegate.h
//  FaceLift
//
//  Created by Pedro Centieiro on 3/28/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSSlidingViewController.h"
#import "FLMenuViewController.h"
#import "FLViewController.h"

extern NSString *const SessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate, JSSlidingViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JSSlidingViewController *viewController;

@property (strong, nonatomic) FLMenuViewController *backVC;
@property (strong, nonatomic) FLViewController *frontVC;

- (void)openSessionWithLoginUI:(BOOL)allowLoginUI;
- (void)slidingViewControllerWillOpen:(JSSlidingViewController *)viewController;

@end
