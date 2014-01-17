//
//  OMBMessageDetailConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBMessageDetailConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithPage: (NSInteger) page withUser: (OMBUser *) user;

@end
