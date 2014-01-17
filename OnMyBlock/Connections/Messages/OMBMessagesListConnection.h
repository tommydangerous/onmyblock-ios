//
//  OMBMessagesListConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBMessagesListConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithPage: (NSInteger) page;

@end
