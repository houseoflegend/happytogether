//
//  HOLSocketManager.h
//  HappyTogether
//
//  Created by Larry Legend on 2/11/14.
//  Copyright (c) 2014 Josh Clark & Larry Legend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HOLSocketManager : NSObject

@property (nonatomic, strong) NSString *socketServerIPAddressString;

- (id)initWithSocketServerIPAddressString:(NSString *)socketServerIPAddressString;
- (void)connect;
- (void)sendString:(NSString *)string;

@end
