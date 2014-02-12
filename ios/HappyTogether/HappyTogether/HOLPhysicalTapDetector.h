//
//  HOLPhysicalTapDetector.h
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

// Adapted code from http://stackoverflow.com/questions/5179426/tap-pressure-strength-detection-using-accelerometer

#define CPBPressureNone         0.0f
#define CPBPressureLight        0.1f
#define CPBPressureMedium       0.3f
#define CPBPressureHard         0.5f
#define CPBPressureInfinite     2.0f

#define kUpdateFrequency            60.0f
#define KNumberOfPressureSamples    20

@protocol HOLPhysicalTapDetectorDelegate;

@interface HOLPhysicalTapDetector : NSObject <UIAccelerometerDelegate> {
@private
    float pressureValues[KNumberOfPressureSamples];
    uint currentPressureValueIndex;
    uint setNextPressureValue;
}

@property (readonly, assign) float pressure;
@property (readwrite, assign) float minimumPressureRequired;
@property (readwrite, assign) float maximumPressureRequired;
@property (nonatomic, strong) NSNumber *polarity;

@property (nonatomic, weak) id <HOLPhysicalTapDetectorDelegate> delegate;

@end

@protocol HOLPhysicalTapDetectorDelegate <NSObject>

- (void)physicalTapDetectorDidReceiveTap:(HOLPhysicalTapDetector *)physicalTapDetector;

@end