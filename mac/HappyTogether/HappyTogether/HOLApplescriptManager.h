//
//  HOLApplescriptManager.h
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HOLApplescriptManager : NSObject

+ (void)playTrackWithPlaybackInfoDictionary:(NSDictionary *)infoDictionary;
+ (void)stopPlayback;

@end
