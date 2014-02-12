//
//  HOLAppDelegate.m
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import "HOLAppDelegate.h"
#import "HOLSocketServerManager.h"
#import "HOLApplescriptManager.h"

@interface HOLAppDelegate () <HOLSocketServerManagerDelegate>

@property HOLSocketServerManager *socketServerManager;

@end

@implementation HOLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.socketServerManager = [[HOLSocketServerManager alloc] init];
    self.socketServerManager.delegate = self;
}

#pragma HOLSocketServerManagerDelegate methods

- (void)socketServerManagerReceivedPlaybackCommandWithPlaybackInfoDictionary:(NSDictionary *)playbackInfoDictionary
{
    [HOLApplescriptManager playTrackWithPlaybackInfoDictionary:playbackInfoDictionary];
}

- (void)socketServerManagerReceivedStopCommand
{
    [HOLApplescriptManager stopPlayback];
}

@end
