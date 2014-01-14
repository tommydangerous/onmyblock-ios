//
//  OMBOpenHouseCreateConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBOpenHouse;
@class OMBResidence;

@interface OMBOpenHouseCreateConnection : OMBConnection
{
  OMBOpenHouse *openHouse;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) residence 
openHouse: (OMBOpenHouse *) object;

@end
