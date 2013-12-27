//
//  OMBMessage.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBUser;

@interface OMBMessage : NSObject

@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) OMBUser *recipient;
@property (nonatomic, strong) OMBUser *sender;
@property (nonatomic) int uid;
@property (nonatomic) BOOL viewed;

@property (nonatomic) CGSize sizeForMessageCell;

#pragma mark - Methods

- (void) calculateSizeForMessageCell;

@end
