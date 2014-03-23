//
//  OMBModelListConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBModelConnection.h"

@interface OMBModelListConnection : OMBModelConnection

#pragma mark - Initializer

- (id) initWithModel: (OMBObject *) object userUID: (NSUInteger) userUID;

@end
