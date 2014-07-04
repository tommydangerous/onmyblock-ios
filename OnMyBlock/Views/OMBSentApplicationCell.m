//
//  OMBSentApplicationCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 5/21/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSentApplicationCell.h"

#import "NSString+Extensions.h"
#import "OMBCenteredImageView.h"
#import "OMBResidence.h"
#import "OMBSentApplication.h"
#import "OMBUser.h"
#import "OMBViewController.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBSentApplicationCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
    return nil;
  
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = OMBPadding;
  
  // Image
  CGFloat imageSize = 22.0f + 22.0f + 22.0f;
  userImageView = [[OMBCenteredImageView alloc] init];
  userImageView.frame = CGRectMake(padding, padding, imageSize, imageSize);
  userImageView.layer.cornerRadius = imageSize * 0.5f;
  [self.contentView addSubview: userImageView];
  
  CGFloat width = screenWidth - (userImageView.frame.origin.x +
    userImageView.frame.size.width + padding + padding);
  
  // Name; James J.
  rentLabel = [UILabel new];
  rentLabel.font = [UIFont normalTextFontBold];
  rentLabel.frame = CGRectMake(userImageView.frame.origin.x +
    userImageView.frame.size.width + padding,
      padding, width, 22.0f);
  rentLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: rentLabel];
  
  // Address; $400 - 8230 Costa Verde Blvd
  addressLabel = [UILabel new];
  addressLabel.font = [UIFont normalTextFont];
  // Minus another padding to not run into the disclosure indicator
  addressLabel.frame = CGRectMake(rentLabel.frame.origin.x,
    rentLabel.frame.origin.y + rentLabel.frame.size.height,
      rentLabel.frame.size.width, rentLabel.frame.size.height);
  addressLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: addressLabel];
  
  // Rent
  bedbadlabel = [UILabel new];
  bedbadlabel.font = [UIFont normalTextFont];
  bedbadlabel.frame = CGRectMake(addressLabel.frame.origin.x,
    addressLabel.frame.origin.y + addressLabel.frame.size.height,
      addressLabel.frame.size.width, addressLabel.frame.size.height);
  bedbadlabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: bedbadlabel];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = OMBPadding;
  return padding + 22.0f + 22.0f + 22.0f + padding;
}

+ (CGFloat) heightForCellWithNotes
{
  // 17 = line height of font size 13
  CGFloat padding = OMBPadding;
  return [OMBSentApplicationCell heightForCell] + padding * 0.5f + (17.0f * 3);
}

#pragma mark - Instance Methods

#pragma mark - Public

- (void) adjustFrames
{
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;
  
  // Name
  CGFloat nameLabelOriginX = userImageView.frame.origin.x +
    userImageView.frame.size.width + padding;
  rentLabel.frame = CGRectMake(nameLabelOriginX, padding,
    screenWidth - (nameLabelOriginX + padding + rentLabel.frame.size.width + padding),
      22.0f);
  
  // Rent
  CGRect bedbadlabelRect = [bedbadlabel.text boundingRectWithSize:
    CGSizeMake(screenWidth, bedbadlabel.frame.size.height)
      font: bedbadlabel.font];
  bedbadlabel.frame = CGRectMake(rentLabel.frame.origin.x,
    bedbadlabel.frame.origin.y + bedbadlabel.frame.size.height,
      bedbadlabelRect.size.width, rentLabel.frame.size.height);
  
  // Address
  CGFloat addressMaxWidth = screenWidth -
    (bedbadlabel.frame.origin.x + bedbadlabel.frame.size.width +
      (padding * 0.5) + padding);
  addressLabel.frame = CGRectMake(
    bedbadlabel.frame.origin.x + bedbadlabel.frame.size.width + (padding * 0.5f),
      bedbadlabel.frame.origin.y, addressMaxWidth, bedbadlabel.frame.size.height);
}

- (void) adjustFramesWithoutImage
{
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;
  
  // Name
  CGFloat addressOriginX = padding;
  addressLabel.frame = CGRectMake(addressOriginX, padding,
    screenWidth - padding, 22.0f);
  
  // Address
  CGRect rentLabelRect = addressLabel.frame;
  rentLabel.frame = CGRectMake(rentLabelRect.origin.x,
    rentLabelRect.origin.y + rentLabelRect.size.height,
      rentLabelRect.size.width, rentLabelRect.size.height);
  
  // Type Label
  CGRect bedbadlabelRect = rentLabel.frame;
  bedbadlabel.frame = CGRectMake(bedbadlabelRect.origin.x,
    bedbadlabelRect.origin.y + bedbadlabelRect.size.height,
      bedbadlabelRect.size.width, bedbadlabelRect.size.height);
}

- (void) loadInfo: (OMBSentApplication *) sentApplication
{ 
  if (sentApplication.residence) {
    [self reloadData: sentApplication.residence];
  }
  else {
    sentApplication.residence     = [[OMBResidence alloc] init];
    sentApplication.residence.uid = sentApplication.residenceID;
    [sentApplication.residence fetchDetailsWithCompletion: ^(NSError *error) {
      [self reloadData: sentApplication.residence];
    }];
  }
}

#pragma mark - Private

- (void) reloadData: (OMBResidence *) residence
{
  if (!residence) return;
  
  // Name
  rentLabel.text = [NSString numberToCurrencyString: residence.minRent];
  // Address
  addressLabel.text = [residence.address capitalizedString];
  // Bedrooms / Bathrooms
  bedbadlabel.text =  [NSString stringWithFormat:
    @"%.0f bd / %.0f ba", residence.bedrooms, residence.bathrooms];

  // Image
  if (residence.hasNoImage) {
    userImageView.image = [OMBResidence placeholderImage];
  }
  else {
    NSString *sizeKey = [NSString stringWithFormat: @"%f,%f",
      userImageView.bounds.size.width, userImageView.bounds.size.height];
    UIImage *image = [residence coverPhotoForSizeKey: sizeKey];
    if (image) {
      userImageView.image = image;
    }
    else {
      __weak typeof(userImageView) weakUserImageView = userImageView;
      [residence downloadCoverPhotoWithCompletion: 
        ^(NSError *error) {
          [weakUserImageView.imageView setImageWithURL:
            residence.coverPhotoURL placeholderImage: nil
              options: SDWebImageRetryFailed completed:
                ^(UIImage *img, NSError *error, SDImageCacheType cacheType) {
                  if (!error && img) {
                    weakUserImageView.image = img;
                    [residence.coverPhotoSizeDictionary setObject:
                      weakUserImageView.image forKey: sizeKey];
                  }
                  else {
                    weakUserImageView.image = [OMBResidence placeholderImage];
                  }
                }  
          ];
      }];
    }
  }
}

@end
