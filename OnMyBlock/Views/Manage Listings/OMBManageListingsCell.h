//
//  OMBManageListingsCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBCenteredImageView;
@class OMBResidence;

@interface OMBManageListingsCell : OMBTableViewCell
{
  UILabel *addressLabel;
  OMBCenteredImageView *centeredImageView;
  UILabel *propertyTypeLabel;
  OMBResidence *residence;
}

@property (nonatomic, strong) UILabel *statusLabel;;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) clearImage;
- (void) loadResidenceData: (OMBResidence *) object;
- (void) setStatusLabelText: (NSString *) string;

@end
