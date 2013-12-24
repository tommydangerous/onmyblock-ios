//
//  OMBResidenceDetailSellerCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailSellerCell.h"

#import "OMBCenteredImageView.h"

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

  self.titleLabel.text = @"Subletter: Gene Starwind";

  CGFloat imageSize = screeWidth * 0.3f;

  _sellerImageView = [[OMBCenteredImageView alloc] init];
  _sellerImageView.clipsToBounds = YES;
  _sellerImageView.frame = CGRectMake(padding,
    self.titleLabel.frame.origin.y + 
    self.titleLabel.frame.size.height + padding,
      imageSize, imageSize);
  _sellerImageView.image = [UIImage imageNamed: @"tommy_d.png"];
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

  NSString *string = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";

  NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
  pStyle.maximumLineHeight = 23.0f;
  pStyle.minimumLineHeight = 23.0f;
  NSMutableAttributedString *aString = 
    [[NSMutableAttributedString alloc] initWithString: string attributes: @{
      NSParagraphStyleAttributeName: pStyle
    }
  ];
  _aboutLabel.attributedText = aString;
  CGRect rect = [_aboutLabel.attributedText boundingRectWithSize:
    CGSizeMake(_aboutLabel.frame.size.width, _sellerImageView.frame.size.height)
      options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  _aboutLabel.frame = CGRectMake(_aboutLabel.frame.origin.x,
    _aboutLabel.frame.origin.y, _aboutLabel.frame.size.width,
      rect.size.height);
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

@end
