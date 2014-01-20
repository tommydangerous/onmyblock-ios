//
//  OMBResidenceUpdateConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBResidence;

@interface OMBResidenceUpdateConnection : OMBConnection
{
  OMBResidence *residence;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object 
attributes: (NSArray *) attributes;

@end
