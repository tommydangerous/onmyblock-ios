//
//  OMBResidenceCollectionViewself.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceCollectionViewCell.h"

#import "OMBResidence.h"
#import "OMBResidenceCoverPhotoURLConnection.h"
#import "UIColor+Extensions.h"

@interface OMBResidenceCollectionViewCell ()

@property (nonatomic, strong, readwrite) UILabel *bedBathLabel;
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *rentLabel;

@end

@implementation OMBResidenceCollectionViewCell

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) frame
{
  self = [super initWithFrame:frame];
  if (self) {
    CGRect screen     = [[UIScreen mainScreen] bounds];
    float imageHeight = screen.size.height * 0.3;

    self.backgroundColor           = [UIColor whiteColor];
    self.imageView                 = [[UIImageView alloc] init];
    self.imageView.clipsToBounds   = YES;
    self.imageView.contentMode     = UIViewContentModeTopLeft;
    self.imageView.frame           = self.bounds;
    [self.contentView addSubview: self.imageView];

    // Info view; this is where the rent, bed, bath, and arrow go
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = [UIColor whiteAlpha: 0.8];
    infoView.frame = CGRectMake(0, (imageHeight * 0.70),
        screen.size.width, (imageHeight * 0.30));
    [self.contentView addSubview: infoView];

    // Rent
    self.rentLabel                 = [[UILabel alloc] init];
    self.rentLabel.backgroundColor = [UIColor clearColor];
    self.rentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
      size: 27];
    self.rentLabel.frame = CGRectMake(20, 0, ((screen.size.width / 2.0) - 30), 
      infoView.frame.size.height);
    self.rentLabel.textColor = [UIColor textColor];
    [infoView addSubview: self.rentLabel];

    // Bedrooms / Bathrooms
    self.bedBathLabel = [[UILabel alloc] init];
    self.bedBathLabel.backgroundColor = [UIColor clearColor];
    self.bedBathLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
      size: 18];
    self.bedBathLabel.frame = CGRectMake(
      (20 + self.rentLabel.frame.size.width + 10), 0, 
        ((screen.size.width / 2.0) - 30), infoView.frame.size.height);
    self.bedBathLabel.textColor = [UIColor textColor];
    [infoView addSubview: self.bedBathLabel];
  }
  return self;
}

#pragma mark - Override

#pragma mark - Override UICollectionReusableView

- (void) prepareForReuse
{
  [super prepareForReuse];
  self.bedBathLabel.text = @"";
  self.imageView.image   = nil;
  self.rentLabel.text    = @"";
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
  self.bedBathLabel.text = [NSString stringWithFormat: @"%@ / %@", beds, baths];

  // Image
  if (residence.coverPhotoForCell)
    self.imageView.image = residence.coverPhotoForCell;
  else {
    // Get residence cover photo url
    OMBResidenceCoverPhotoURLConnection *connection = 
      [[OMBResidenceCoverPhotoURLConnection alloc] initWithResidence: 
        residence];
    connection.completionBlock = ^(NSError *error) {
      residence.coverPhotoForCell = [residence coverPhotoWithSize: 
        CGSizeMake(self.imageView.frame.size.width, 
          self.imageView.frame.size.height)];
      self.imageView.image = residence.coverPhotoForCell;
    };
    [connection start];
  }

  // Rent
  self.rentLabel.text = [NSString stringWithFormat: @"%@", 
    [residence rentToCurrencyString]];
  CGRect rentLabelFrame = self.rentLabel.frame;
  CGRect rentRect = [self.rentLabel.text boundingRectWithSize:
      CGSizeMake(((self.contentView.frame.size.width / 2.0) - 30),
        self.rentLabel.frame.size.height)
          options: NSStringDrawingUsesLineFragmentOrigin 
            attributes: @{NSFontAttributeName: self.rentLabel.font} 
              context: nil];
  rentLabelFrame.size.width = rentRect.size.width;
  self.rentLabel.frame = rentLabelFrame;

  CGRect bedBathLabelFrame = self.bedBathLabel.frame;
  CGRect bedBathRect = [self.bedBathLabel.text boundingRectWithSize:
      CGSizeMake((self.contentView.frame.size.width - 
        (20 + self.rentLabel.frame.size.width + 20 + 10 + 10)),
          self.bedBathLabel.frame.size.height)
          options: NSStringDrawingUsesLineFragmentOrigin 
            attributes: @{NSFontAttributeName: self.bedBathLabel.font} 
              context: nil];
  bedBathLabelFrame.origin.x = 
    self.rentLabel.frame.origin.x + self.rentLabel.frame.size.width + 20;
  bedBathLabelFrame.size.width = bedBathRect.size.width;
  self.bedBathLabel.frame = bedBathLabelFrame;
}

@end
