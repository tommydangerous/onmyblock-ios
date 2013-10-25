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

const float kBorderTopHeight = 0.0;

@implementation OMBPropertyInfoView

@synthesize imageView = _imageView;
@synthesize residence = _residence;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    CGRect screen     = [[UIScreen mainScreen] bounds];
    float imageHeight = screen.size.height * 0.3;
    self.backgroundColor = [UIColor colorWithRed: (245/255.0) green: (245/255.0)
      blue: (245/255.0) alpha: 0.8];
    self.frame = CGRectMake(0, screen.size.height, screen.size.width, 
      (kBorderTopHeight + imageHeight));

    // Image view
    _imageView                 = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.clipsToBounds   = YES;
    _imageView.contentMode     = UIViewContentModeTopLeft;
    _imageView.frame           = CGRectMake(0, kBorderTopHeight, 
      screen.size.width, imageHeight);
    [self addSubview: _imageView];

    // Info view; this is where the rent, bed, bath, and arrow go
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = [UIColor whiteAlpha: 0.8];
    infoView.frame = CGRectMake(0, 
      (kBorderTopHeight + (imageHeight * 0.70)),
        screen.size.width, (imageHeight * 0.30));
    [self addSubview: infoView];

    // Rent
    rentLabel = [[UILabel alloc] init];
    rentLabel.backgroundColor = [UIColor clearColor];
    rentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 27];
    rentLabel.frame = CGRectMake(20, 0, ((screen.size.width / 2.0) - 30), 
      infoView.frame.size.height);
    rentLabel.textColor = [UIColor textColor];
    [infoView addSubview: rentLabel];

    // Bedrooms / Bathrooms
    bedBathLabel = [[UILabel alloc] init];
    bedBathLabel.backgroundColor = [UIColor clearColor];
    bedBathLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
    bedBathLabel.frame = CGRectMake((20 + rentLabel.frame.size.width + 10),
      0, ((screen.size.width / 2.0) - 30), infoView.frame.size.height);
    bedBathLabel.textColor = [UIColor textColor];
    [infoView addSubview: bedBathLabel];

    // arrowImageView = [[UIImageView alloc] init];
    // arrowImageView.backgroundColor = [UIColor clearColor];
    // arrowImageView.clipsToBounds = YES;
    // arrowImageView.contentMode = UIViewContentModeTopLeft;
    // arrowImageView.frame = CGRectMake(
    //   (screen.size.width - ((infoView.frame.size.height / 2.0) + 10)), 
    //     (infoView.frame.size.height / 4.0), 
    //        (infoView.frame.size.height / 2.0), 
    //       (infoView.frame.size.height / 2.0));
    // arrowImageView.image = [UIImage image: 
    //   [UIImage imageNamed: @"arrow_right.png"] 
    //     size: CGSizeMake((arrowImageView.frame.size.width), 
    //       (arrowImageView.frame.size.height))];
    // [infoView addSubview: arrowImageView];
  }
  return self;
}

#pragma mark - Methods

#pragma mark Instance Methods

- (void) loadResidenceData: (OMBResidence *) object
{
  CGRect screen     = [[UIScreen mainScreen] bounds];
  float imageHeight = screen.size.height * 0.3;

  _residence = object;

  // Bedrooms
  NSString *bedsString = @"bd";
  // if (_residence.bedrooms == 1)
  //   bedsString = @"bed";
  NSString *bedsNumberString;
  if (_residence.bedrooms == (int) _residence.bedrooms)
    bedsNumberString = [NSString stringWithFormat: @"%i", 
      (int) _residence.bedrooms];
  else
    bedsNumberString = [NSString stringWithFormat: @"%.01f",
      _residence.bedrooms];
  NSString *beds = [NSString stringWithFormat: @"%@ %@", 
    bedsNumberString, bedsString];
  // Bathrooms
  NSString *bathsString = @"ba";
  // if (_residence.bathrooms == 1)
  //   bathsString = @"bath";
  NSString *bathsNumberString;
  if (_residence.bathrooms == (int) _residence.bathrooms)
    bathsNumberString = [NSString stringWithFormat: @"%i",
      (int) _residence.bathrooms];
  else
    bathsNumberString = [NSString stringWithFormat: @"%.01f",
      _residence.bathrooms];
  NSString *baths = [NSString stringWithFormat: @"%@ %@",
    bathsNumberString, bathsString];
  // Bedrooms / Bathrooms
  bedBathLabel.text = [NSString stringWithFormat: @"%@ / %@", beds, baths];

  // Image
  if (_residence.coverPhotoForCell)
    _imageView.image = _residence.coverPhotoForCell;
  else {
    // Get _residence cover photo url
    OMBResidenceCoverPhotoURLConnection *connection = 
      [[OMBResidenceCoverPhotoURLConnection alloc] initWithResidence: 
        _residence];
    connection.completionBlock = ^(NSError *error) {
      _residence.coverPhotoForCell = [_residence coverPhotoWithSize: 
        CGSizeMake(screen.size.width, imageHeight)];
      _imageView.image = _residence.coverPhotoForCell;
    };
    [connection start];
  }

  // Rent
  rentLabel.text = [NSString stringWithFormat: @"%@", 
    [_residence rentToCurrencyString]];

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
      CGSizeMake((screen.size.width - 
        (20 + rentLabel.frame.size.width + 20 + 10 + 
          arrowImageView.frame.size.width + 10)), 
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
