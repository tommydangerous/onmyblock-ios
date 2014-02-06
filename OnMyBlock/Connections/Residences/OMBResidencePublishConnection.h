//
//  OMBResidencePublishConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBResidence;

@interface OMBResidencePublishConnection : OMBConnection
{
  OMBResidence *newResidence;
  OMBResidence *residence;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;
- (id) initWithResidence: (OMBResidence *) object
newResidence: (OMBResidence *) object2;

@end
