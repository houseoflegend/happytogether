//
//  HOLApplescriptManager.m
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import "HOLApplescriptManager.h"

@implementation HOLApplescriptManager

#pragma mark - Public methods

+ (void)playTrackWithPlaybackInfoDictionary:(NSDictionary *)playbackInfoDictionary
{
    NSString *artistName = [playbackInfoDictionary valueForKey:@"artist"];
    NSString *trackName = [playbackInfoDictionary valueForKey:@"title"];
    NSString *albumName = [playbackInfoDictionary valueForKey:@"albumTitle"];
    double playPosition = [[playbackInfoDictionary valueForKey:@"playbackTime"] doubleValue];

    [self playTrackWithArtistName:artistName
                        trackName:trackName
                        albumName:albumName
                   atPlayPosition:playPosition];
}

+ (void)stopPlayback
{
    NSString *source = [self sourceForPause];
    [self runScriptWithSource:source];
}

#pragma mark - Private methods

+ (void)playTrackWithArtistName:(NSString *)artistName trackName:(NSString *)trackName albumName:(NSString *)albumName  atPlayPosition:(double)playPosition
{
    NSString *source = [self sourceWithArtistName:artistName trackName:trackName albumName:albumName atPlayPosition:playPosition];
    [self runScriptWithSource:source];
}

+ (NSString *)sourceWithArtistName:(NSString *)artistName trackName:(NSString *)trackName albumName:(NSString *)albumName atPlayPosition:(double)playPosition
{
    NSString *rawSource = [self sourceForScriptWithName:@"itunesPlay"];
    NSString *source = [[[[rawSource
                           stringByReplacingOccurrencesOfString:@"__artistName__" withString:artistName]
                          stringByReplacingOccurrencesOfString:@"__trackName__" withString:trackName]
                         stringByReplacingOccurrencesOfString:@"__albumName__" withString:albumName]
                        stringByReplacingOccurrencesOfString:@"__playPosition__" withString:[NSString stringWithFormat:@"%f", playPosition]];
    return source;
}

+ (NSString *)sourceForPause
{
    NSString *source = [self sourceForScriptWithName:@"itunesPause"];
    return source;
}

+ (NSString *)sourceForScriptWithName:(NSString *)scriptName
{
    NSError *error = nil;
    NSString *source = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:scriptName ofType:@"applescript"] encoding:NSUTF8StringEncoding error:&error];
    
    if (error || ! source) {
        NSLog(@"Error loading applescript -- couldn't load a script with the name %@: %@", scriptName, error);
    }
    
    return source;
}

+ (void)runScriptWithSource:(NSString *)source
{
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:source];
    if (! script) {
        NSLog(@"could not instantiate script: %@", source);
    }
    else {
        NSLog(@"script source:\n%@", [script source]);
    }
    
    NSDictionary *errorInfo = nil;
    [script executeAndReturnError:&errorInfo];
    
    if (errorInfo) {
        NSLog(@"error executing applescript: %@", errorInfo);
    }
}

@end
