//
//  OMBPropertyInfoView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPropertyInfoView.h"

#import "OMBResidence.h"
#import "OMBResidenceCoverPhotoURLConnection.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

const float kBorderTopHeight = 0.5;
const int kImageDimension    = 80;

@implementation OMBPropertyInfoView

@synthesize imageView = _imageView;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed: (245/255.0) green: (245/255.0)
      blue: (245/255.0) alpha: 0.9];
    self.frame = CGRectMake(0, screen.size.height, screen.size.width, 
      (kBorderTopHeight + kImageDimension));

    UIFont *font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];

    CALayer *borderTop = [CALayer layer];
    borderTop.backgroundColor = [UIColor grayMedium].CGColor;
    borderTop.frame = CGRectMake(0, 0, screen.size.width, kBorderTopHeight);
    borderTop.opacity = 0.5;
    [self.layer addSublayer: borderTop];

    // Address
    addressLabel = [[UILabel alloc] init];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.font = font;
    addressLabel.frame = CGRectMake((kImageDimension + 20), 
      (kImageDimension * 0.75), (screen.size.width - kImageDimension),
        (kImageDimension / 4.0));
    addressLabel.textColor = [UIColor textColor];
    // [self addSubview: addressLabel];

    arrowImageView = [[UIImageView alloc] init];
    arrowImageView.backgroundColor = [UIColor clearColor];
    arrowImageView.clipsToBounds = YES;
    arrowImageView.contentMode = UIViewContentModeTopLeft;
    arrowImageView.frame = CGRectMake(
      (screen.size.width - ((kImageDimension * 0.4) + 10)), 
        (1 + (kImageDimension * 0.3)), (kImageDimension * 0.4), 
          (kImageDimension * 0.4));
    arrowImageView.image = [UIImage image: 
      [UIImage imageNamed: @"arrow_right.png"] 
        size: CGSizeMake((kImageDimension * 0.4), (kImageDimension * 0.4))];
    [self addSubview: arrowImageView];

    // Bedrooms / Bathrooms
    bedBathLabel = [[UILabel alloc] init];
    bedBathLabel.backgroundColor = [UIColor clearColor];
    bedBathLabel.font = font;
    bedBathLabel.frame = CGRectMake((kImageDimension + 20), 
      (kBorderTopHeight + 5 + (kImageDimension * 0.5)), 
        (screen.size.width - kImageDimension), (kImageDimension / 4.0));
    bedBathLabel.textColor = [UIColor textColor];
    [self addSubview: bedBathLabel];

    // Image view
    _imageView                 = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.clipsToBounds   = YES;
    _imageView.contentMode     = UIViewContentModeTopLeft;
    _imageView.frame           = CGRectMake(0, kBorderTopHeight, 
      kImageDimension, kImageDimension);
    [self addSubview: _imageView];

    // Rent
    rentLabel = [[UILabel alloc] init];
    rentLabel.backgroundColor = [UIColor clearColor];
    rentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 22];
    rentLabel.frame = CGRectMake((kImageDimension + 20), 
      (kBorderTopHeight + 5), (screen.size.width - kImageDimension), 
        (kImageDimension / 2.0));
    rentLabel.textColor = [UIColor textColor];
    [self addSubview: rentLabel];
  }
  return self;
}

#pragma mark - Methods

#pragma mark Instance Methods

- (void) loadResidenceData: (OMBResidence *) object
{
  residence = object;

  // Address
  addressLabel.text = residence.address;

  // Bedrooms
  NSString *bedsString = @"beds";
  if (residence.bedrooms == 1)
    bedsString = @"bed";
  NSString *bedsNumberString;
  if (residence.bedrooms == (int) residence.bedrooms)
    bedsNumberString = [NSString stringWithFormat: @"%i", 
      (int) residence.bedrooms];
  else
    bedsNumberString = [NSString stringWithFormat: @"%.02f",
      residence.bedrooms];
  NSString *beds = [NSString stringWithFormat: @"%@ %@", 
    bedsNumberString, bedsString];
  // Bathrooms
  NSString *bathsString = @"baths";
  if (residence.bathrooms == 1)
    bathsString = @"bath";
  NSString *bathsNumberString;
  if (residence.bathrooms == (int) residence.bathrooms)
    bathsNumberString = [NSString stringWithFormat: @"%i",
      (int) residence.bathrooms];
  else
    bathsNumberString = [NSString stringWithFormat: @"%.02f",
      residence.bathrooms];
  NSString *baths = [NSString stringWithFormat: @"%@ %@",
    bathsNumberString, bathsString];
  // Bedrooms / Bathrooms
  bedBathLabel.text = [NSString stringWithFormat: @"%@ / %@", beds, baths];

  // Image
  if ([residence coverPhoto])
    _imageView.image = [residence coverPhotoWithSize: 
      CGSizeMake(kImageDimension, kImageDimension)];
  else {
    // Get residence cover photo url
    OMBResidenceCoverPhotoURLConnection *connection = 
      [[OMBResidenceCoverPhotoURLConnection alloc] initWithResidence: 
        residence];
    connection.completionBlock = ^(NSError *error) {
      _imageView.image = [residence coverPhotoWithSize: 
        CGSizeMake(kImageDimension, kImageDimension)];
    };
    [connection start];
    // _imageView.image = [UIImage image: 
    //   [UIImage imageNamed: @"placeholder_property.png"]
    //     size: CGSizeMake(100, 100)];
  }

  // Rent
  rentLabel.text = [NSString stringWithFormat: @"%@", 
    [residence rentToCurrencyString]];
}

@end
