//
//  OMBPayoutMethodUpdateConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBPayoutMethod;

@interface OMBPayoutMethodUpdateConnection : OMBConnection
{
  OMBPayoutMethod *payoutMethod;
}

#pragma mark - Initializer

- (id) initWithPayoutMethod: (OMBPayoutMethod *) object 
attributes: (NSArray *) attributes;

@end
