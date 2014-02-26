//
//  OMBConversationDetailConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBConversationDetailConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithConversationUID: (NSUInteger) uid page: (NSUInteger) page;

@end
