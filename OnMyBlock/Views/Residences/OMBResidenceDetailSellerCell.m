//
//  OMBResidenceDetailSellerCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailSellerCell.h"

#import "OMBCenteredImageView.h"
#import "OMBResidence.h"
#import "OMBUser.h"

@implementation OMBResidenceDetailSellerCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];

  float screeWidth = screen.size.width;

  float padding = 20.0f;

  CGFloat imageSize = screeWidth * 0.3f;

  _sellerImageView = [[OMBCenteredImageView alloc] init];
  _sellerImageView.clipsToBounds = YES;
  _sellerImageView.frame = CGRectMake(padding,
    self.titleLabel.frame.origin.y + 
    self.titleLabel.frame.size.height + padding,
      imageSize, imageSize);
  _sellerImageView.layer.cornerRadius = 
    _sellerImageView.frame.size.width * 0.5f;
  [self.contentView addSubview: _sellerImageView];

  CGFloat aboutLabelOriginX = _sellerImageView.frame.origin.x + 
    _sellerImageView.frame.size.width + padding;
  _aboutLabel = [[UILabel alloc] init];
  _aboutLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  _aboutLabel.frame = CGRectMake(aboutLabelOriginX,
    _sellerImageView.frame.origin.y, 
      screeWidth - (aboutLabelOriginX + padding), 0.0f);
  _aboutLabel.numberOfLines = 0;
  _aboutLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: _aboutLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGRect screen = [[UIScreen mainScreen] bounds];

  return 44.0f + 20.0f + (screen.size.width * 0.3f) + 20.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidenceData: (OMBResidence *) residence
{
  // Name
  self.titleLabel.text = [residence.user fullName];

  // Image
  if (residence.user.image) {
    [self setImageFromUserOrResidence: residence];
  }
  else {
    [residence.user downloadImageFromImageURLWithCompletion: 
      ^(NSError *error) {
        [self setImageFromUserOrResidence: residence];
      }
    ];
  }

  // About
  NSString *string = residence.user.about;
  if (![string length]) {
    string = @"Contact me for more details on this place! Thank you.";
  }
  _aboutLabel.attributedText = [string attributedStringWithFont:
    _aboutLabel.font lineHeight: 23.0f];
  CGRect rect = [_aboutLabel.attributedText boundingRectWithSize:
    CGSizeMake(_aboutLabel.frame.size.width, _sellerImageView.frame.size.height)
      options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  _aboutLabel.frame = CGRectMake(_aboutLabel.frame.origin.x,
    _aboutLabel.frame.origin.y, _aboutLabel.frame.size.width,
      rect.size.height);
}

- (void) setImageFromUserOrResidence: (OMBResidence *) residence
{
  if (residence.user.hasDefaultImage) {
    [self.sellerImageView setImage: [OMBUser defaultUserImage]];
    // [residence setImageForCenteredImageView: _sellerImageView
    //   withURL: residence.coverPhotoURL completion: nil];
  }
  else {
    _sellerImageView.image = residence.user.image;
  }
}

@end
