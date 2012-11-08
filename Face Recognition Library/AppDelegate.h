//
//  AppDelegate.h
//  Face Recognition Library
//
//  Created by Pedro Centieiro on 3/28/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const SessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)openSessionWithLoginUI:(BOOL)allowLoginUI;

@end
