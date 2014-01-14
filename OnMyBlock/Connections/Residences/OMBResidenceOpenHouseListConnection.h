//
//  OMBResidenceOpenHouseListConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBResidence;

@interface OMBResidenceOpenHouseListConnection : OMBConnection
{
  OMBResidence *residence;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
