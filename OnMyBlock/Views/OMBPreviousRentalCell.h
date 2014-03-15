//
//  OMBPreviousRentalCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBPreviousRental;

@interface OMBPreviousRentalCell : OMBTableViewCell
{
  UILabel *addressLabel;
  UILabel *addressLabel2;
  UILabel *landlordEmailLabel;
  UIImageView *landlordImageView;
  UILabel *landlordNameLabel;
  UILabel *landlordPhoneLabel;
  UILabel *rentLeaseMonthsLabel;
  UIImageView *residenceImageView;
}

@property (nonatomic, strong) OMBPreviousRental *previousRental;

#pragma mark - Methods

#pragma mark - Class methods

+ (CGFloat) heightForCell2;

#pragma mark - Instance Methods

- (void) loadData: (OMBPreviousRental *) object;
- (void) loadData2: (OMBPreviousRental *) object;
- (void) loadFakeData1;
- (void) loadFakeData2;

@end
