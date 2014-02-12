//
//  HOLAppDelegate.h
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

@class CMMotionManager;

@interface HOLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (CMMotionManager *)sharedMotionManager;

@end
