//
//  HOLPlaybackManager.h
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HOLPlaybackManager : NSObject

- (void)movePlaybackFromDeviceToMac;
- (NSString *)nowPlayingTrackInfoString;
- (UIImage *)nowPlayingTrackArtworkImageWithSize:(CGSize)size;

@end
