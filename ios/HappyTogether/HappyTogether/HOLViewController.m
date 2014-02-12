//
//  HOLViewController.m
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import "HOLViewController.h"
#import "HOLPhysicalDoubleTapDetector.h"
#import "HOLPlaybackManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface HOLViewController () <HOLPhysicalDoubleTapDetectorDelegate>

@property (nonatomic, strong) HOLPhysicalDoubleTapDetector *physicalDoubleTapDetector;
@property (nonatomic, strong) HOLPlaybackManager *playbackManager;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, assign, getter = isFirstAppearance) BOOL firstAppearance;

@end

@implementation HOLViewController

#pragma mark - Lifecycle

- (void)dealloc
{
    [self teardown];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self isFirstAppearance]) {
        [self setupAfterFirstApperance];
        [self setFirstAppearance:NO];
    }
}

#pragma mark - Setup

- (void)setup
{
    _firstAppearance = YES;
}

- (void)setupAfterFirstApperance
{
    [self setupPlaybackManager];
    [self updateDisplay];
    
    [self setupDoubleTapDetector];
    
    [self setupTimer];
}

- (void)setupTimer
{
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateDisplay) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)setupDoubleTapDetector
{
    self.physicalDoubleTapDetector = [[HOLPhysicalDoubleTapDetector alloc] init];
    self.physicalDoubleTapDetector.delegate = self;
}

- (void)setupPlaybackManager
{
    self.playbackManager = [[HOLPlaybackManager alloc] init];
}

#pragma mark - Teardown

- (void)teardown
{
    [self.timer invalidate];
    
    [self stopObserving];
}

- (void)stopObserving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - HOLPhysicalDoubleTapDetector delegate methods

- (void)physicalDoubleTapDetectorDidReceiveDoubleTap:(HOLPhysicalDoubleTapDetector *)physicalDoubleTapDetector
{
    [self takeDoubleTapAction];
}

- (void)takeDoubleTapAction
{
    [self.playbackManager movePlaybackFromDeviceToMac];
}

#pragma mark - IBActions

- (IBAction)didTapDoubleTapButton:(id)sender
{
    [self takeDoubleTapAction];
}

#pragma mark - Display update methods

- (void)updateDisplay
{
    self.label.text = [self.playbackManager nowPlayingTrackInfoString];
    self.imageView.image = [self.playbackManager nowPlayingTrackArtworkImageWithSize:self.imageView.frame.size];
}

@end
