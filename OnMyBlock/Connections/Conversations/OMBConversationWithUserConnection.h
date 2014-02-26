//
//  OMBConversationWithUserConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBConversationWithUserConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithUserUID: (NSUInteger) uid;

@end
