//
//  OMBResidenceCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceCell.h"

#import "OMBResidence.h"
#import "OMBResidenceCoverPhotoURLConnection.h"
#import "UIColor+Extensions.h"

@implementation OMBResidenceCell

@synthesize bedBathLabel = _bedBathLabel;
@synthesize imageView    = _imageView;
@synthesize rentLabel    = _rentLabel;

- (id) initWithStyle: (UITableViewCellStyle) style  
reuseIdentifier: (NSString *) reuseIdentifier
{
  self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
  if (self) {
    CGRect screen     = [[UIScreen mainScreen] bounds];
    float imageHeight = screen.size.height * 0.3;

    self.backgroundColor = [UIColor clearColor];
    self.contentView.frame = CGRectMake(0, 0, screen.size.width, 
      (imageHeight + 5));
    self.selectionStyle    = UITableViewCellSelectionStyleNone;

    // Image view
    _imageView                 = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor whiteColor];
    _imageView.clipsToBounds   = YES;
    _imageView.contentMode     = UIViewContentModeTopLeft;
    _imageView.frame           = CGRectMake(0, 0, screen.size.width, 
      imageHeight);
    [self.contentView addSubview: _imageView];

    // Info view; this is where the rent, bed, bath, and arrow go
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = [UIColor whiteAlpha: 0.8];
    infoView.frame = CGRectMake(0, (imageHeight * 0.70),
        screen.size.width, (imageHeight * 0.30));
    [self.contentView addSubview: infoView];

    // Rent
    _rentLabel                 = [[UILabel alloc] init];
    _rentLabel.backgroundColor = [UIColor clearColor];
    _rentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
      size: 27];
    _rentLabel.frame = CGRectMake(20, 0, ((screen.size.width / 2.0) - 30), 
      infoView.frame.size.height);
    _rentLabel.textColor = [UIColor textColor];
    [infoView addSubview: _rentLabel];

    // Bedrooms / Bathrooms
    _bedBathLabel = [[UILabel alloc] init];
    _bedBathLabel.backgroundColor = [UIColor clearColor];
    _bedBathLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
      size: 18];
    _bedBathLabel.frame = CGRectMake(
      (20 + _rentLabel.frame.size.width + 10), 0, 
        ((screen.size.width / 2.0) - 30), infoView.frame.size.height);
    _bedBathLabel.textColor = [UIColor textColor];
    [infoView addSubview: _bedBathLabel];
  }
  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidenceData: (OMBResidence *) residence
{
  // Bedrooms
  NSString *bedsString = @"bd";
  // if (residence.bedrooms == 1)
  //   bedsString = @"bed";
  NSString *bedsNumberString;
  if (residence.bedrooms == (int) residence.bedrooms)
    bedsNumberString = [NSString stringWithFormat: @"%i", 
      (int) residence.bedrooms];
  else
    bedsNumberString = [NSString stringWithFormat: @"%.01f",
      residence.bedrooms];
  NSString *beds = [NSString stringWithFormat: @"%@ %@", 
    bedsNumberString, bedsString];
  // Bathrooms
  NSString *bathsString = @"ba";
  // if (residence.bathrooms == 1)
  //   bathsString = @"bath";
  NSString *bathsNumberString;
  if (residence.bathrooms == (int) residence.bathrooms)
    bathsNumberString = [NSString stringWithFormat: @"%i",
      (int) residence.bathrooms];
  else
    bathsNumberString = [NSString stringWithFormat: @"%.01f",
      residence.bathrooms];
  NSString *baths = [NSString stringWithFormat: @"%@ %@",
    bathsNumberString, bathsString];
  // Bedrooms / Bathrooms
  _bedBathLabel.text = [NSString stringWithFormat: @"%@ / %@", beds, baths];

  // Image
  if (residence.coverPhotoForCell)
    _imageView.image = residence.coverPhotoForCell;
  else {
    // Get residence cover photo url
    OMBResidenceCoverPhotoURLConnection *connection = 
      [[OMBResidenceCoverPhotoURLConnection alloc] initWithResidence: 
        residence];
    connection.completionBlock = ^(NSError *error) {
      residence.coverPhotoForCell = [residence coverPhotoWithSize: 
        CGSizeMake(_imageView.frame.size.width, 
          _imageView.frame.size.height)];
      _imageView.image = residence.coverPhotoForCell;
    };
    [connection start];
    _imageView.image = nil;
  }

  // Rent
  _rentLabel.text = [NSString stringWithFormat: @"%@", 
    [residence rentToCurrencyString]];
  CGRect rentLabelFrame = _rentLabel.frame;
  CGRect rentRect = [_rentLabel.text boundingRectWithSize:
      CGSizeMake(((self.contentView.frame.size.width / 2.0) - 30),
        _rentLabel.frame.size.height)
          options: NSStringDrawingUsesLineFragmentOrigin 
            attributes: @{NSFontAttributeName: _rentLabel.font} 
              context: nil];
  rentLabelFrame.size.width = rentRect.size.width;
  _rentLabel.frame = rentLabelFrame;

  CGRect bedBathLabelFrame = _bedBathLabel.frame;
  CGRect bedBathRect = [_bedBathLabel.text boundingRectWithSize:
      CGSizeMake((self.contentView.frame.size.width - 
        (20 + _rentLabel.frame.size.width + 20 + 10 + 10)),
          _bedBathLabel.frame.size.height)
          options: NSStringDrawingUsesLineFragmentOrigin 
            attributes: @{NSFontAttributeName: _bedBathLabel.font} 
              context: nil];
  bedBathLabelFrame.origin.x = 
    _rentLabel.frame.origin.x + _rentLabel.frame.size.width + 20;
  bedBathLabelFrame.size.width = bedBathRect.size.width;
  _bedBathLabel.frame = bedBathLabelFrame;
}

@end
