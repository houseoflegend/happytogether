//
//  HOLPhysicalTapDetector.m
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import "HOLPhysicalTapDetector.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "HOLAppDelegate.h"
#import <CoreMotion/CoreMotion.h>

@interface HOLPhysicalTapDetector ()

@end

@implementation HOLPhysicalTapDetector

- (id)init {
    self = [super init];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _minimumPressureRequired = CPBPressureMedium;
    _maximumPressureRequired = CPBPressureInfinite;
    _pressure = CPBPressureNone;
    
    [self resetForNextTap];
    
    [self startUpdates];
}

#pragma mark - UIAccelerometerDelegate methods

- (void)startUpdates
{
    NSTimeInterval updateInterval = 1.0 / kUpdateFrequency;
    
    CMMotionManager *motionManager = [(HOLAppDelegate *)[[UIApplication sharedApplication] delegate] sharedMotionManager];
    __weak __typeof(self) weakSelf = self;
    if ([motionManager isAccelerometerAvailable] == YES) {
        [motionManager setAccelerometerUpdateInterval:updateInterval];
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            if ([weakSelf checkForTap:accelerometerData]) {
                [weakSelf.delegate physicalTapDetectorDidReceiveTap:weakSelf];
            }
        }];
    }
}

#pragma -

- (void)reset {
    _pressure = CPBPressureNone;
    setNextPressureValue = 0;
    currentPressureValueIndex = 0;
    
    [self resetForNextTap];
}

- (void)resetForNextTap {
    setNextPressureValue = KNumberOfPressureSamples;
}

#pragma mark -

- (BOOL)checkForTap:(CMAccelerometerData *)accelerometerData
{
    BOOL isTap = NO;
    
    int sz = (sizeof pressureValues) / (sizeof pressureValues[0]);
    
    // set current pressure value
    pressureValues[currentPressureValueIndex%sz] = accelerometerData.acceleration.y;
    
    if (setNextPressureValue > 0) {
        
        // calculate average pressure
        float total = 0.0f;
        for (int loop=0; loop<sz; loop++) total += pressureValues[loop];
        float average = total / sz;
        
        // start with most recent past pressure sample
        if (setNextPressureValue == KNumberOfPressureSamples) {
            float mostRecent = pressureValues[(currentPressureValueIndex-1)%sz];
            _pressure = fabsf(average - mostRecent);
        }
        
        // caluculate pressure as difference between average and current acceleration
        float diff = fabsf(average - accelerometerData.acceleration.y);
        if (_pressure < diff) _pressure = diff;
        setNextPressureValue--;
        
        if (setNextPressureValue == 0) {
            if (_pressure >= _minimumPressureRequired && _pressure <= _maximumPressureRequired) {
                self.polarity = [NSNumber numberWithBool:((average - accelerometerData.acceleration.y) > 0)];
                isTap = YES;
            }
            
            [self resetForNextTap];
        }
    }
    
    currentPressureValueIndex++;
    
    return isTap;
}

@end