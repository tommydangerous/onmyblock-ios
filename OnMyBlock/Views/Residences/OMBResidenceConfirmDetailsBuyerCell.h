//
//  OMBResidenceConfirmDetailsBuyerCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBCenteredImageView;
@class OMBUser;

@interface OMBResidenceConfirmDetailsBuyerCell : OMBTableViewCell
{
  OMBCenteredImageView *imageView;
  UILabel *nameLabel;
  UILabel *schoolLabel;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadUser: (OMBUser *) object;

@end
