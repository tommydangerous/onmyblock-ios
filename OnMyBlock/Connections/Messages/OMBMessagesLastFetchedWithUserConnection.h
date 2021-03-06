//
//  OMBMessagesLastFetchedWithUserConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBMessagesLastFetchedWithUserConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithConversationUID: (NSUInteger) uid 
lastFetched: (NSTimeInterval) lastFetched;

@end
