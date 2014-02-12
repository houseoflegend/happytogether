//
//  HOLStatusItemController.m
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import "HOLStatusItemController.h"

@interface HOLStatusItemController ()

@property (nonatomic, strong) IBOutlet NSMenu *menu;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSImage *statusImage;
@property (nonatomic, strong) NSImage *statusHighlightedImage;

- (IBAction)didSelectAbout:(id)sender;

@end

@implementation HOLStatusItemController

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [self setupStatusItem];
}

#pragma mark - Setup

- (void)setupStatusItem
{
    NSBundle *bundle = [NSBundle mainBundle];
    self.statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"Status"]];
    self.statusHighlightedImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"StatusHighlighted"]];
 
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [self.statusItem setImage:self.statusImage];
    [self.statusItem setAlternateImage:self.statusHighlightedImage];
    [self.statusItem setHighlightMode:YES];

    [self.statusItem setMenu:self.menu];
}

#pragma mark - IBActions

- (IBAction)didSelectAbout:(id)sender
{
    NSLog(@"didSelectAbout:");
}

@end
