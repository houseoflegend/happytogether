//
//  HOLPhysicalDoubleTapDetector.h
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

@protocol HOLPhysicalDoubleTapDetectorDelegate;

@interface HOLPhysicalDoubleTapDetector : NSObject

@property (nonatomic, weak) id <HOLPhysicalDoubleTapDetectorDelegate> delegate;

@end

@protocol HOLPhysicalDoubleTapDetectorDelegate <NSObject>

- (void)physicalDoubleTapDetectorDidReceiveDoubleTap:(HOLPhysicalDoubleTapDetector *)physicalDoubleTapDetector;

@end