//
//  OMBPreviousRentalCreateConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/9/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBPreviousRental;

@interface OMBPreviousRentalCreateConnection : OMBConnection
{
  OMBPreviousRental *previousRental;
}

#pragma mark - Initializer

- (id) initWithPreviousRental: (OMBPreviousRental *) object;

@end
