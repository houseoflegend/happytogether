//
//  HOLPlaybackManager.m
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import "HOLPlaybackManager.h"
#import "HOLSocketManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#warning Set this IP address for your Mac's local IP address and then delete this warning.
static NSString * const kSocketServerIPAddressString = @"192.168.0.11";

@interface HOLPlaybackManager ()

@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, assign) MPMusicPlaybackState previousMusicPlayerState;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) HOLSocketManager *socketManager;

@end

@implementation HOLPlaybackManager

#pragma mark - Public methods

- (void)movePlaybackFromDeviceToMac
{
//    NSString *textToSend = [self.textField.text copy];
//    
//    if (textToSend.length > 0) {
//        NSDictionary *dictionary = @{@"text": textToSend};
//        
//        NSError *error = nil;
//        NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
//        
//        if (! error) {
//            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            [self.socketManager sendString:string];
//            self.textField.text = @"";
//        }
//        else {
//            NSLog(@"%@", error);
//        }
//    }
    
    if ([self.musicPlayer playbackState] == MPMoviePlaybackStatePlaying) {
        NSString *artistString = [[self.musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyArtist];
        NSString *titleString = [[self.musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle];
        NSString *albumTitleString = [[self.musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
        NSTimeInterval currentPlaybackTime = [self.musicPlayer currentPlaybackTime];
        if (artistString.length > 0 &&
            titleString.length > 0) {
            NSDictionary *playbackInfo = @{@"playback": @{
                                                   @"artist": artistString,
                                                   @"title": titleString,
                                                   @"albumTitle": albumTitleString,
                                                   @"playbackTime": [NSNumber numberWithDouble:currentPlaybackTime]
                                                   }};
            
            NSError *error = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:playbackInfo options:0 error:&error];
            
            if (! error) {
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [self.socketManager sendString:string];
//                self.textField.text = @"";
                
                [self.musicPlayer stop];
            }
            else {
                NSLog(@"%@", error);
            }
        }
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setupMusicPlayer];
    [self startObserving];
    [self.musicPlayer beginGeneratingPlaybackNotifications];
        
    self.socketManager = [[HOLSocketManager alloc] initWithSocketServerIPAddressString:kSocketServerIPAddressString];
    [self.socketManager connect];
}

- (void)startObserving
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handlePlaybackStateDidChange:)
                               name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object:nil];
}

- (void)setupMusicPlayer
{
    _musicPlayer = [[MPMusicPlayerController alloc] init];
}

#pragma mark - Playback notifictions

- (void)handlePlaybackStateDidChange:(id)notification
{
    MPMusicPlaybackState currentPlaybackState = self.musicPlayer.playbackState;
    
    if (currentPlaybackState == MPMusicPlaybackStatePlaying &&
        currentPlaybackState != self.previousMusicPlayerState) {
        // Music just started playing. Halt audio on Mac.
        [self stopOnComputer];
    }
    else {
        // Ask the music player for the current song.
        MPMediaItem *currentItem = self.musicPlayer.nowPlayingItem;
        NSLog(@"currentItem: %@", currentItem);
    }
    
    self.previousMusicPlayerState = self.musicPlayer.playbackState;
}

- (void)stopOnComputer
{
    NSDictionary *dictionary = @{@"stop" : @"stop"};
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    
    if (! error) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.socketManager sendString:string];
    }
    else {
        NSLog(@"%@", error);
    }
}

#pragma mark - Now playing track info and artwork

- (NSString *)nowPlayingTrackInfoString
{
    NSString *infoString = nil;
    
    if ([self.musicPlayer nowPlayingItem]) {
        NSString *artistString = [[self.musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyArtist];
        NSString *titleString = [[self.musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle];
        NSString *albumTitleString = [[self.musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
        NSTimeInterval currentPlaybackTime = [self.musicPlayer currentPlaybackTime];
        NSString *formattedPlaybackTimeString = [self formattedPlaybackTimeStringForPlaybackTime:currentPlaybackTime];

        infoString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
                      artistString,
                      albumTitleString,
                      titleString,
                      formattedPlaybackTimeString];
    }
    else {
        infoString = @"(no track playing)";
    }

    return infoString;
}

- (UIImage *)nowPlayingTrackArtworkImageWithSize:(CGSize)size
{
    UIImage *image = nil;
    
    if ([self.musicPlayer nowPlayingItem]) {
        MPMediaItemArtwork *artwork = [[self.musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyArtwork];
        image = [artwork imageWithSize:size];
    }
    
    return image;
}

- (NSString *)formattedPlaybackTimeStringForPlaybackTime:(NSTimeInterval)playbackTime
{
    return [NSString stringWithFormat:@"%.0f:%02.0f", floor(playbackTime / 60), fmod(playbackTime, 60)];
}

@end
