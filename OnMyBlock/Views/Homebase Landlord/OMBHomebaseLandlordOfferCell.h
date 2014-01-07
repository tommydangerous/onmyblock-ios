//
//  OMBHomebaseLandlordOfferCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBCenteredImageView;

@interface OMBHomebaseLandlordOfferCell : OMBTableViewCell
{
  UILabel *addressLabel;
  UILabel *nameLabel;
  UILabel *rentLabel;
  UILabel *timeLabel;
  UILabel *typeLabel;
  OMBCenteredImageView *userImageView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) adjustFrames;
- (void) loadConfirmedTenantData;
- (void) loadOfferData;

@end
