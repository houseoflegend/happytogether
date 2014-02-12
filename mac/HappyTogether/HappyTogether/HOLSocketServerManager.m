//
//  HOLSocketServerManager.m
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import "HOLSocketServerManager.h"
#import "MBWebSocketServer.h"

@interface HOLSocketServerManager () <MBWebSocketServerDelegate>

@property (nonatomic, strong) MBWebSocketServer *ws;

@end

@implementation HOLSocketServerManager

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        [self reconnect];
    }
    return self;
}

#pragma mark - Connection methods

- (void)reconnect
{
    [self.ws disconnect];
    NSLog(@"starting server...");
    self.ws = [[MBWebSocketServer alloc] initWithPort:13581 delegate:self];
}

#pragma mark - MBWebSocketServer delegate methods

- (void)webSocketServer:(MBWebSocketServer *)webSocketServer didAcceptConnection:(GCDAsyncSocket *)connection
{
    NSLog(@"Connected to a client, we accept multiple connections");
}

- (void)webSocketServer:(MBWebSocketServer *)webSocket didReceiveData:(NSData *)data fromConnection:(GCDAsyncSocket *)connection
{
    NSLog(@"received data...");
    
    NSError *error = nil;
    NSDictionary *JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (! error) {
        // text or playback
        if ([JSONObject valueForKey:@"text"]) {
            NSString *textString = [JSONObject valueForKey:@"text"];
            NSLog(@"%@", textString);
        }
        if ([JSONObject valueForKey:@"playback"]) {
            [self.delegate socketServerManagerReceivedPlaybackCommandWithPlaybackInfoDictionary:[JSONObject valueForKey:@"playback"]];
        }
        if ([JSONObject valueForKey:@"stop"]) {
            [self.delegate socketServerManagerReceivedStopCommand];
        }
    }
    else {
    }
}

- (void)webSocketServer:(MBWebSocketServer *)webSocketServer clientDisconnected:(GCDAsyncSocket *)connection
{
    NSLog(@"Disconnected from client: %@", connection);
}

- (void)webSocketServer:(MBWebSocketServer *)webSocketServer couldNotParseRawData:(NSData *)rawData fromConnection:(GCDAsyncSocket *)connection error:(NSError *)error
{
    NSLog(@"MBWebSocketServer error: %@", error);
}

@end
