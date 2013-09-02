//
//  HRFAppDelegate.h
//  HowlerReader
//
//  Created by ian.calderon on 7/29/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRFMainViewController;

@interface HRFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HRFMainViewController *mainView;
@property (strong, nonatomic) UINavigationController *navController;

@end
