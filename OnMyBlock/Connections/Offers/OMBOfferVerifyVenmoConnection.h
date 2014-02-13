//
//  OMBOfferVerifyVenmoConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/12/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBOffer;

@interface OMBOfferVerifyVenmoConnection : OMBConnection
{
  OMBOffer *offer;
}

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object 
dictionary: (NSDictionary *) dictionary;

@end
