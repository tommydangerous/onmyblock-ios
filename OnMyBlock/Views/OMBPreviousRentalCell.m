//
//  OMBPreviousRentalCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPreviousRentalCell.h"

#import "NSString+PhoneNumber.h"
#import "OMBPreviousRental.h"
#import "UIColor+Extensions.h"

@implementation OMBPreviousRentalCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;

  CGRect screen     = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;

  float padding = 20.0f;

  float originX = padding;
  float height  = 22.0f;
  float width   = screenWidth - (originX * 2);

  addressLabel = [[UILabel alloc] init];
  addressLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  addressLabel.frame = CGRectMake(originX, padding, width, height);
  addressLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: addressLabel];

  addressLabel2 = [[UILabel alloc] init];
  addressLabel2.font = addressLabel.font;
  addressLabel2.frame = CGRectMake(originX,
    addressLabel.frame.origin.y + addressLabel.frame.size.height,
      width, height);
  addressLabel2.textColor = addressLabel.textColor;
  [self.contentView addSubview: addressLabel2];

  rentLeaseMonthsLabel = [[UILabel alloc] init];
  rentLeaseMonthsLabel.font = addressLabel.font;
  rentLeaseMonthsLabel.frame = CGRectMake(originX,
    addressLabel2.frame.origin.y + addressLabel2.frame.size.height,
      width, height);
  rentLeaseMonthsLabel.textColor = addressLabel.textColor;
  [self.contentView addSubview: rentLeaseMonthsLabel];

  landlordNameLabel = [[UILabel alloc] init];
  landlordNameLabel.font = addressLabel.font;
  landlordNameLabel.frame = CGRectMake(originX, 0, width, height);
  landlordNameLabel.textColor = addressLabel.textColor;
  [self.contentView addSubview: landlordNameLabel];

  landlordEmailLabel = [[UILabel alloc] init];
  landlordEmailLabel.font = addressLabel.font;
  landlordEmailLabel.frame = CGRectMake(originX, 0, width, height);
  landlordEmailLabel.textColor = addressLabel.textColor;
  [self.contentView addSubview: landlordEmailLabel];

  landlordPhoneLabel = [[UILabel alloc] init];
  landlordPhoneLabel.font = addressLabel.font;
  landlordPhoneLabel.frame = CGRectMake(originX, 0, width, height);
  landlordPhoneLabel.textColor = addressLabel.textColor;
  [self.contentView addSubview: landlordPhoneLabel];

  return self;
}

#pragma mark - Override

#pragma mark - Override UITableViewCell

- (void) setSelected: (BOOL) selected animated: (BOOL) animated
{
  [super setSelected:selected animated:animated];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadData: (OMBPreviousRental *) object
{
  _previousRental = object;
  addressLabel.text = [_previousRental.address capitalizedString];
  addressLabel2.text = [NSString stringWithFormat: @"%@, %@ %@",
    [_previousRental.city capitalizedString], 
      [_previousRental.state capitalizedString], _previousRental.zip];
  rentLeaseMonthsLabel.text = [NSString stringWithFormat: @"%i month lease",
    _previousRental.leaseMonths];
  if (_previousRental.rent) {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *string = [numberFormatter stringFromNumber: 
      [NSNumber numberWithFloat: _previousRental.rent]];
    rentLeaseMonthsLabel.text = [NSString stringWithFormat: @"%@ - %@",
      string, rentLeaseMonthsLabel.text];
  }
  float originX = rentLeaseMonthsLabel.frame.origin.y +
    rentLeaseMonthsLabel.frame.size.height + 20;
  float spacing = 0;
  if ([_previousRental.landlordName length] > 0) {
    landlordNameLabel.frame = CGRectMake(landlordNameLabel.frame.origin.x,
      originX, landlordNameLabel.frame.size.width, 
      landlordNameLabel.frame.size.height);
    landlordNameLabel.text = 
      [_previousRental.landlordName capitalizedString];
    spacing += landlordNameLabel.frame.size.height;
  }
  if ([_previousRental.landlordEmail length] > 0) {
    landlordEmailLabel.frame = CGRectMake(landlordEmailLabel.frame.origin.x,
      originX + spacing,
        landlordEmailLabel.frame.size.width, 
          landlordEmailLabel.frame.size.height);
    landlordEmailLabel.text = 
      [_previousRental.landlordEmail lowercaseString];
    spacing += landlordEmailLabel.frame.size.height;
  }
  if ([[_previousRental.landlordPhone phoneNumberString] length] > 0) {
    landlordPhoneLabel.frame = CGRectMake(landlordPhoneLabel.frame.origin.x,
      originX + spacing, landlordPhoneLabel.frame.size.width,
        landlordPhoneLabel.frame.size.height);
    landlordPhoneLabel.text = 
      [_previousRental.landlordPhone phoneNumberString];
  }
}

@end
