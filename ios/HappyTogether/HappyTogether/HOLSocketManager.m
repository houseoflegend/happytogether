//
//  HOLSocketManager.m
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import "HOLSocketManager.h"
#import <SRWebSocket.h>

@interface HOLSocketManager () <SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *webSocket;

@end

@implementation HOLSocketManager

#pragma mark - Public methods

- (void)connect
{
    [self reconnect];
}

- (void)sendString:(NSString *)string
{
    // The web socket library will throw an exception if we try to send a string when the socket is not open.
    // So check that the web socket is ready first.
    
    if ([self isWebSocketReady]) {
        [self.webSocket send:string];
    }
    else {
        NSLog(@"Couldn't send command to socket because socket is not yet open. Make sure the server application is running and you have the IP address configured correctly at the top of HOLPlaybackManager.m");
    }
}

- (BOOL)isWebSocketReady
{
    return (self.webSocket.readyState == SR_OPEN);
}

#pragma mark - Lifecycle

- (id)initWithSocketServerIPAddressString:(NSString *)socketServerIPAddressString
{
    self = [super init];
    if (self) {
        _socketServerIPAddressString = socketServerIPAddressString;
    }
    return self;
}

#pragma mark - Reconnect & disconnect

- (void)reconnect
{
    self.webSocket.delegate = nil;
    [self.webSocket close];
    
    NSAssert(self.socketServerIPAddressString, @"socketServerIPAddressString must be set before connecting.");
    NSString *webSocketURLString = [NSString stringWithFormat:@"ws://%@:13581", self.socketServerIPAddressString];
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webSocketURLString]]];
    self.webSocket.delegate = self;
    
    NSLog(@"Opening Connection...");
    
    [self.webSocket open];
}

- (void)disconnect
{
    self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;
}

#pragma mark - SRWebSocketDelegate meethods

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Websocket Connected");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Websocket Failed. Make sure the Mac server app is running before launching the iOS app, and the IP address of the server is configured correctly. Error: %@", error);
    self.webSocket = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Websocket Failed" message:[NSString stringWithFormat:@"Websocket Failed. Make sure the Mac server app is running before launching the iOS app, and the IP address of the server is configured correctly. %@", [error debugDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Websocket received message %@", message);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"WebSocket closed");
    self.webSocket = nil;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Websocket Closed" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
