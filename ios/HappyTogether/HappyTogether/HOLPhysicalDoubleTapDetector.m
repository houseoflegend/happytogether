//
//  HOLPhysicalDoubleTapDetector.m
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import "HOLPhysicalDoubleTapDetector.h"
#import "HOLPhysicalTapDetector.h"

#define kMinimumDoubleTapInterval 0.1
#define kMaximumDoubleTapInterval 0.5

@interface HOLPhysicalDoubleTapDetector () <HOLPhysicalTapDetectorDelegate>

@property (nonatomic, strong) HOLPhysicalTapDetector *physicalTapDetector;
@property (nonatomic, strong) NSDate *firstTapDate;
@property (nonatomic, strong) NSNumber *firstTapPolarity;

@end


@implementation HOLPhysicalDoubleTapDetector

- (id)init
{
    self = [super init];
    if (self) {
        _physicalTapDetector = [[HOLPhysicalTapDetector alloc] init];
        _physicalTapDetector.delegate = self;
    }
    return self;
}

- (void)physicalTapDetectorDidReceiveTap:(HOLPhysicalTapDetector *)physicalTapDetector
{
    NSLog(@"tap");
    
    
    if (self.firstTapDate == nil) {
        self.firstTapDate = [NSDate date];
        self.firstTapPolarity = self.physicalTapDetector.polarity;
    }
    else {
        // check for double tap
        NSDate *now = [NSDate date];
        BOOL polarityMatches = self.physicalTapDetector.polarity == nil || [self.physicalTapDetector.polarity isEqual:self.firstTapPolarity];

        NSTimeInterval timeSinceFirstTap = [now timeIntervalSinceDate:self.firstTapDate];
        if (polarityMatches &&
            timeSinceFirstTap >= kMinimumDoubleTapInterval &&
            timeSinceFirstTap <= kMaximumDoubleTapInterval) {
            // yes, double tap!
            NSLog(@"DOUBLE TAP (%.3f)", timeSinceFirstTap);
            [self.delegate physicalDoubleTapDetectorDidReceiveDoubleTap:self];
            
            // reset to zero taps
            self.firstTapDate = nil;
            self.firstTapPolarity = nil;
        }
        else {
            // Count this tap as the first tap.
            self.firstTapDate = now;
            self.firstTapPolarity = self.physicalTapDetector.polarity;
        }
        
    }
}

@end

