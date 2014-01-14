//
//  OMBOpenHouseDeleteConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBOpenHouse;

@interface OMBOpenHouseDeleteConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithOpenHouse: (OMBOpenHouse *) object;

@end
