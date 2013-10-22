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

@implementation OMBPropertyInfoView

@synthesize imageView = _imageView;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    CGRect screen     = [[UIScreen mainScreen] bounds];
    float imageHeight = screen.size.height * 0.3;
    self.backgroundColor = [UIColor colorWithRed: (210/255.0) green: (210/255.0)
      blue: (210/255.0) alpha: 0.9];
    self.frame = CGRectMake(0, screen.size.height, screen.size.width, 
      (kBorderTopHeight + imageHeight));

    UIColor *color = [UIColor textColor];

    CALayer *borderTop = [CALayer layer];
    borderTop.backgroundColor = [UIColor grayDark].CGColor;
    borderTop.frame = CGRectMake(0, 0, screen.size.width, kBorderTopHeight);
    borderTop.opacity = 1;
    [self.layer addSublayer: borderTop];

    // Image view
    _imageView                 = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.clipsToBounds   = YES;
    _imageView.contentMode     = UIViewContentModeTopLeft;
    _imageView.frame           = CGRectMake(0, kBorderTopHeight, 
      screen.size.width, imageHeight);
    [self addSubview: _imageView];

    arrowImageView = [[UIImageView alloc] init];
    arrowImageView.backgroundColor = [UIColor clearColor];
    arrowImageView.clipsToBounds = YES;
    arrowImageView.contentMode = UIViewContentModeTopLeft;
    arrowImageView.frame = CGRectMake(
      (screen.size.width - ((imageHeight * 0.4) + 10)), 
        (1 + (imageHeight * 0.3)), (imageHeight * 0.4), 
          (imageHeight * 0.4));
    arrowImageView.image = [UIImage image: 
      [UIImage imageNamed: @"arrow_right.png"] 
        size: CGSizeMake((imageHeight * 0.4), (imageHeight * 0.4))];

    // Info view; this is where the rent, bed, bath, and arrow go
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = [UIColor whiteAlpha: 0.7];
    infoView.frame = CGRectMake(0, 
      (kBorderTopHeight + (imageHeight * 0.6)),
        screen.size.width, (imageHeight * 0.4));
    [self addSubview: infoView];

    // Rent
    rentLabel = [[UILabel alloc] init];
    rentLabel.backgroundColor = [UIColor clearColor];
    rentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 27];
    rentLabel.frame = CGRectMake(20, 0, ((screen.size.width / 2.0) - 30), 
      infoView.frame.size.height);
    rentLabel.textColor = color;
    [infoView addSubview: rentLabel];

    // Bedrooms / Bathrooms
    bedBathLabel = [[UILabel alloc] init];
    bedBathLabel.backgroundColor = [UIColor clearColor];
    bedBathLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];;
    bedBathLabel.frame = CGRectMake((20 + rentLabel.frame.size.width + 10),
      0, ((screen.size.width / 2.0) - 30), infoView.frame.size.height);
    bedBathLabel.textColor = color;
    [infoView addSubview: bedBathLabel];
  }
  return self;
}

#pragma mark - Methods

#pragma mark Instance Methods

- (void) loadResidenceData: (OMBResidence *) object
{
  CGRect screen     = [[UIScreen mainScreen] bounds];
  float imageHeight = screen.size.height * 0.35;

  residence = object;

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
      CGSizeMake(screen.size.width, imageHeight)];
  else {
    // Get residence cover photo url
    OMBResidenceCoverPhotoURLConnection *connection = 
      [[OMBResidenceCoverPhotoURLConnection alloc] initWithResidence: 
        residence];
    connection.completionBlock = ^(NSError *error) {
      _imageView.image = [residence coverPhotoWithSize: 
        CGSizeMake(screen.size.width, imageHeight)];
    };
    [connection start];
    // _imageView.image = [UIImage image: 
    //   [UIImage imageNamed: @"placeholder_property.png"]
    //     size: CGSizeMake(100, 100)];
  }

  // Rent
  rentLabel.text = [NSString stringWithFormat: @"%@", 
    [residence rentToCurrencyString]];

  CGRect rentLabelFrame = rentLabel.frame;
  CGRect rentRect = [rentLabel.text boundingRectWithSize:
      CGSizeMake(((screen.size.width / 2.0) - 30), rentLabel.frame.size.height)
        options: NSStringDrawingUsesLineFragmentOrigin 
          attributes: @{NSFontAttributeName: rentLabel.font} 
            context: nil];
  rentLabelFrame.size.width = rentRect.size.width;
  rentLabel.frame = rentLabelFrame;

  CGRect bedBathLabelFrame = bedBathLabel.frame;
  CGRect bedBathRect = [bedBathLabel.text boundingRectWithSize:
      CGSizeMake((screen.size.width - (20 + rentLabel.frame.size.width + 40)), 
        bedBathLabel.frame.size.height)
          options: NSStringDrawingUsesLineFragmentOrigin 
            attributes: @{NSFontAttributeName: bedBathLabel.font} 
              context: nil];
  bedBathLabelFrame.origin.x = 
    rentLabel.frame.origin.x + rentLabel.frame.size.width + 20;
  bedBathLabelFrame.size.width = bedBathRect.size.width;
  bedBathLabel.frame = bedBathLabelFrame;
}

@end
