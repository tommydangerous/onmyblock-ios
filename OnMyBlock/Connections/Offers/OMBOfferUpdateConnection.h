//
//  OMBOfferUpdateConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBOffer;

@interface OMBOfferUpdateConnection : OMBConnection
{
  OMBOffer *offer;
}

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object attributes: (NSArray *) attributes;

@end
