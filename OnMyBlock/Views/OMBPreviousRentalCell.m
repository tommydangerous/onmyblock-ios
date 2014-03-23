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
#import "UIFont+OnMyBlock.h"

@implementation OMBPreviousRentalCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;

  CGFloat height  = 22.0f;
  CGFloat imageSize = height * 3;
  CGFloat width = screenWidth - (padding + imageSize + padding + padding);
  CGFloat originX = padding + imageSize + padding;

  // Residence icon
  residenceImageView = [UIImageView new];
  residenceImageView.frame = CGRectMake(padding, padding, height * 3,
    height * 3);
  residenceImageView.image = [UIImage imageNamed: @"house_icon.png"];
  [self.contentView addSubview: residenceImageView];
  // Landlord icon
  landlordImageView = [UIImageView new];
  landlordImageView.frame = CGRectMake(padding, 
    residenceImageView.frame.origin.y + 
    residenceImageView.frame.size.height + padding, 
      residenceImageView.frame.size.width, 
        residenceImageView.frame.size.height);
  landlordImageView.image = [UIImage imageNamed: @"landlord_icon.png"];
  [self.contentView addSubview: landlordImageView];

  addressLabel = [[UILabel alloc] init];
  addressLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  addressLabel.frame = CGRectMake(originX, padding, width, height);
  addressLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: addressLabel];

  addressLabel2 = [[UILabel alloc] init];
  addressLabel2.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  addressLabel2.frame = CGRectMake(originX,
    addressLabel.frame.origin.y + addressLabel.frame.size.height,
      width, height);
  addressLabel2.textColor = addressLabel.textColor;
  [self.contentView addSubview: addressLabel2];

  rentLeaseMonthsLabel = [[UILabel alloc] init];
  rentLeaseMonthsLabel.font = addressLabel2.font;
  rentLeaseMonthsLabel.frame = CGRectMake(originX,
    addressLabel2.frame.origin.y + addressLabel2.frame.size.height,
      width, height);
  rentLeaseMonthsLabel.textColor = addressLabel.textColor;
  [self.contentView addSubview: rentLeaseMonthsLabel];

  landlordNameLabel = [[UILabel alloc] init];
  landlordNameLabel.font = addressLabel2.font;
  landlordNameLabel.frame = CGRectMake(originX, 0, width, height);
  landlordNameLabel.textColor = addressLabel.textColor;
  [self.contentView addSubview: landlordNameLabel];

  landlordEmailLabel = [[UILabel alloc] init];
  landlordEmailLabel.font = addressLabel2.font;
  landlordEmailLabel.frame = CGRectMake(originX, 0, width, height);
  landlordEmailLabel.textColor = addressLabel.textColor;
  [self.contentView addSubview: landlordEmailLabel];

  landlordPhoneLabel = [[UILabel alloc] init];
  landlordPhoneLabel.font = addressLabel2.font;
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

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 20.0f;
  return padding + (22.0f * 3) + padding + (22.0f * 3) + padding;
}

+ (CGFloat) heightForCell2
{
  CGFloat padding = 20.0f;
  return padding + (22.0f * 3) + padding;
}

#pragma mark - Instance Methods

- (void) loadData: (OMBPreviousRental *) object
{
  self.previousRental = object;
  addressLabel.text = [self.previousRental.address capitalizedString];
  addressLabel2.text = [NSString stringWithFormat: @"%@, %@ %@",
    [self.previousRental.city capitalizedString], 
      [self.previousRental.state capitalizedString], self.previousRental.zip];
  rentLeaseMonthsLabel.text = [NSString stringWithFormat: @"%i mo lease",
    self.previousRental.leaseMonths];
  if (self.previousRental.rent) {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *string = [numberFormatter stringFromNumber: 
      [NSNumber numberWithFloat: self.previousRental.rent]];
    string = [[string componentsSeparatedByString: @"."] objectAtIndex: 0];
    rentLeaseMonthsLabel.text = [NSString stringWithFormat: @"%@ / mo - %@",
      string, rentLeaseMonthsLabel.text];
  }
  float originX = rentLeaseMonthsLabel.frame.origin.y +
    rentLeaseMonthsLabel.frame.size.height + 20;
  float spacing = 0;
  // Reset it so when it is reused, it doesn't have a text from another cell
  landlordNameLabel.text = @"no landlord name";
  landlordNameLabel.textColor = [UIColor grayMedium];
  if ([self.previousRental.landlordName length] > 0) {
    landlordNameLabel.text = 
      [self.previousRental.landlordName capitalizedString];
    landlordNameLabel.textColor = [UIColor textColor];
  }
  landlordNameLabel.frame = CGRectMake(landlordNameLabel.frame.origin.x,
    originX, landlordNameLabel.frame.size.width, 
      landlordNameLabel.frame.size.height);
  spacing += landlordNameLabel.frame.size.height;
  // Reset it so when it is reused, it doesn't have a text from another cell
  landlordEmailLabel.text = @"no landlord email";
  landlordEmailLabel.textColor = [UIColor grayMedium];
  if ([self.previousRental.landlordEmail length] > 0) {
    landlordEmailLabel.text = 
      [self.previousRental.landlordEmail lowercaseString];
    landlordEmailLabel.textColor = [UIColor blue];
  }
  landlordEmailLabel.frame = CGRectMake(landlordEmailLabel.frame.origin.x,
    originX + spacing,
      landlordEmailLabel.frame.size.width, 
        landlordEmailLabel.frame.size.height);
  spacing += landlordEmailLabel.frame.size.height;
  // Reset it so when it is reused, it doesn't have a text from another cell
  landlordPhoneLabel.text = @"no landlord phone";
  landlordPhoneLabel.textColor = [UIColor grayMedium];
  if ([[self.previousRental.landlordPhone phoneNumberString] length] > 0) {
    landlordPhoneLabel.text = 
      [self.previousRental.landlordPhone phoneNumberString];
    landlordPhoneLabel.textColor = [UIColor blue];
  }
  landlordPhoneLabel.frame = CGRectMake(landlordPhoneLabel.frame.origin.x,
    originX + spacing, landlordPhoneLabel.frame.size.width,
      landlordPhoneLabel.frame.size.height);
}


- (void) loadData2: (OMBPreviousRental *) object
{
  self.previousRental = object;
  CGFloat padding = 20.0f;
  CGFloat width = self.frame.size.width - 2 * 20;
  [residenceImageView removeFromSuperview];
  
  CGRect previousFrame = addressLabel.frame;
  previousFrame.origin.x = padding;
  previousFrame.size.width = width;
  addressLabel.font = [UIFont normalTextFontBold];
  addressLabel.frame = previousFrame;
  addressLabel.textAlignment = NSTextAlignmentLeft;
  addressLabel.textColor = [UIColor textColor];
  
  previousFrame.origin.y = addressLabel.frame.origin.y +
    addressLabel.frame.size.height;
  addressLabel2.font = [UIFont normalTextFont];
  addressLabel2.frame = previousFrame;
  addressLabel2.textAlignment = addressLabel.textAlignment;
  
  previousFrame.origin.y = addressLabel2.frame.origin.y +
    addressLabel2.frame.size.height;
  rentLeaseMonthsLabel.font = [UIFont normalTextFont];
  rentLeaseMonthsLabel.frame = previousFrame;
  rentLeaseMonthsLabel.textAlignment = addressLabel.textAlignment;
  rentLeaseMonthsLabel.textColor = [UIColor grayMedium];
  
  if(self.previousRental.school && [self.previousRental.school length]){
    addressLabel.text = self.previousRental.school;
    addressLabel2.text = @"on-campus residence";
  }else{
    addressLabel.text = [self.previousRental.address capitalizedString];
    addressLabel2.text = [NSString stringWithFormat: @"%@, %@ %@",
      self.previousRental.city.length ? [self.previousRental.city capitalizedString] : @"",
        ([self.previousRental.state length] == 2 ? [self.previousRental.state uppercaseString]:
         (self.previousRental.state.length ? self.previousRental.state : @"")),
            self.previousRental.zip.length ? self.previousRental.zip : @""];
  }
  
  // Start date
  if (self.previousRental.moveInDate) {
    NSString *startDate = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM yyyy";
    startDate = [dateFormatter stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: self.previousRental.moveInDate]];
    NSString *endDateString = @"Present";
    if (self.previousRental.moveOutDate) {
      endDateString = [dateFormatter stringFromDate:
        [NSDate dateWithTimeIntervalSince1970: self.previousRental.moveOutDate]];
    }
    rentLeaseMonthsLabel.text = [NSString stringWithFormat: @"%@ - %@",
      startDate, endDateString];
  }
  else {
    rentLeaseMonthsLabel.text = @"";
  }
}

- (void) loadFakeData1
{
  OMBPreviousRental *pr = [[OMBPreviousRental alloc] init];
  pr.address = @"4235 Mordor Drive";
  pr.city = @"San Jose";
  pr.landlordEmail = @"sauron@gmail.com";
  pr.landlordName = @"Sauron";
  pr.landlordPhone = @"6661234567";
  pr.leaseMonths = 12;
  pr.rent = 6235.23;
  pr.state = @"CA";
  pr.zip = @"95123";
  pr.uid = 9999;
  [self loadData: pr];
}

- (void) loadFakeData2
{
  OMBPreviousRental *pr = [[OMBPreviousRental alloc] init];
  pr.address = @"2353 Gondor Way";
  pr.city = @"San Diego";
  pr.leaseMonths = 6;
  pr.rent = 2235.23;
  pr.state = @"CA";
  pr.zip = @"92122";
  pr.uid = 8888;
  [self loadData: pr];
}

@end
