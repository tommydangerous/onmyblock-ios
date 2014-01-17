//
//  OMBMessageCreateConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBMessage;

@interface OMBMessageCreateConnection : OMBConnection
{
  OMBMessage *message;
}

#pragma mark - Initializer

- (id) initWithMessage: (OMBMessage *) object;

@end
