//
//  OMBResidenceDetailAmenitiesCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailCell.h"

@interface OMBResidenceDetailAmenitiesCell : OMBResidenceDetailCell
{
  NSArray *amenities;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadAmenitiesData: (NSArray *) array;

@end
