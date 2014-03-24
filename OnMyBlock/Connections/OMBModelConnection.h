//
//  OMBModelConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBModelConnection : OMBConnection

@property NSString *resourceName;

#pragma mark - Initializer

- (id) initWithModel: (OMBObject *) object;

@end
