//
//  OMBPreviousRentalCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBPreviousRental;

@interface OMBPreviousRentalCell : UITableViewCell
{
  UILabel *addressLabel;
  UILabel *addressLabel2;
  UILabel *landlordEmailLabel;
  UILabel *landlordNameLabel;
  UILabel *landlordPhoneLabel;
  UILabel *rentLeaseMonthsLabel;
}

@property (nonatomic, strong) OMBPreviousRental *previousRental;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadData: (OMBPreviousRental *) object;

@end
