//
//  OMBResidenceFavoriteCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceCell.h"

@class OMBFavoriteResidence;

@interface OMBFavoriteResidenceCell : OMBResidenceCell
{
  UILabel *userNameLabel;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadFavoriteResidenceData: (OMBFavoriteResidence *) object;

@end
