//
//  OMBMessageCreateConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBConversation;
@class OMBMessage;

@interface OMBMessageCreateConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithMessage: (OMBMessage *) object 
conversation: (OMBConversation *) conversationObject;
- (id) initWithMessage: (OMBMessage *) object;

@end
