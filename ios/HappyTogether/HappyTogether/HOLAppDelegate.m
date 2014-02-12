//
//  HOLAppDelegate.m
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import "HOLAppDelegate.h"
#import <CoreMotion/CoreMotion.h>

// Constants
static const NSTimeInterval kHOLAppDelegateBackgroundTaskDuration = 60 * 10; // 10 minutes

// CMMotionManager singleton
static CMMotionManager *_sharedMotionManager = nil;

@interface HOLAppDelegate ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation HOLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self getBackgroundTime];
}

#pragma mark - CMMotionManager singleton

- (CMMotionManager *)sharedMotionManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMotionManager = [[CMMotionManager alloc] init];
    });
    return _sharedMotionManager;
}

#pragma mark - Background time

// This is a hack to stay alive in the background. This would get killed after some undefined amount of time (possibly 10 minutes), and would not be likely to be approved by Apple.

- (void)getBackgroundTime
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperationWithBlock:^{
        // Create a task that does nothing but will take 10 minutes (60 seconds * 10)
        for (NSInteger i = 0; i < kHOLAppDelegateBackgroundTaskDuration; i++) {
            NSLog(@"staying alive...");
            sleep(1);
        }
    }];
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [operationQueue waitUntilAllOperationsAreFinished];
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
}

@end
