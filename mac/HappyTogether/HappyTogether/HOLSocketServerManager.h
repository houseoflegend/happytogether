//
//  HOLSocketServerManager.h
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HOLSocketServerManagerDelegate;

@interface HOLSocketServerManager : NSObject

@property (nonatomic, weak) id <HOLSocketServerManagerDelegate> delegate;

@end

@protocol HOLSocketServerManagerDelegate <NSObject>

- (void)socketServerManagerReceivedPlaybackCommandWithPlaybackInfoDictionary:(NSDictionary *)playbackInfoDictionary;
- (void)socketServerManagerReceivedStopCommand;

@end
