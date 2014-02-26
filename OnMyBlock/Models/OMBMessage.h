//
//  OMBMessage.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OMBConnectionProtocol.h"

@class OMBUser;

@interface OMBMessage : NSObject <OMBConnectionProtocol>

@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, strong) NSString *content;
@property (nonatomic) NSInteger uid;
@property (nonatomic) NSTimeInterval updatedAt;
@property (nonatomic, strong) OMBUser *user;
@property (nonatomic, strong) NSString *viewedUserIDs;

@property (nonatomic) CGSize sizeForMessageCell;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) calculateSizeForMessageCell;
- (void) createMessageConnectionWithConversationUID: (NSUInteger) uid;
- (BOOL) isFromUser: (OMBUser *) user;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (BOOL) viewedByUser: (OMBUser *) user;

@end
