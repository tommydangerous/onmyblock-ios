//
//  OMBResidenceConfirmDetailsBuyerCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceConfirmDetailsBuyerCell.h"

#import "OMBCenteredImageView.h"
#import "OMBUser.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBResidenceConfirmDetailsBuyerCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;

  CGFloat padding   = 20.0f;
  CGFloat imageSize = screenWidth * 0.25f;

  imageView = [[OMBCenteredImageView alloc] init];
  // imageView.clipsToBounds = YES;
  imageView.frame = CGRectMake(padding, padding, imageSize, imageSize);
  imageView.layer.cornerRadius = imageSize * 0.5f;
  [self.contentView addSubview: imageView];

  nameLabel = [UILabel new];
  // nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  nameLabel.font = [UIFont normalTextFontBold];
  nameLabel.frame = CGRectMake(
    imageView.frame.origin.x + imageView.frame.size.width + padding, 
      imageView.frame.origin.y, screenWidth - (padding + padding + 
        imageView.frame.origin.x + imageView.frame.size.width), 22.0f);
  nameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: nameLabel];

  schoolLabel = [UILabel new];
  schoolLabel.font = [UIFont normalTextFont];
  schoolLabel.frame = CGRectMake(nameLabel.frame.origin.x,
    nameLabel.frame.origin.y + nameLabel.frame.size.height,
      nameLabel.frame.size.width,
        imageView.frame.size.height - nameLabel.frame.size.height);
  schoolLabel.numberOfLines = 0;
  schoolLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: schoolLabel];
    
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;

  CGFloat padding   = 20.0f;
  CGFloat imageSize = screenWidth * 0.25f;

  return padding + imageSize + padding;
}

#pragma mark - Instance Methods

- (void) loadUser: (OMBUser *) object
{
  imageView.image = [OMBUser currentUser].image;

  nameLabel.text = [[OMBUser currentUser] fullName];

  // schoolLabel.text = [OMBUser currentUser].school;

  NSString *string = @"Your school goes here or a little bit about yourself...";
  if ([[OMBUser currentUser].about length]) {
    string = [OMBUser currentUser].about;
  }
  else if ([[OMBUser currentUser].school length]) {
    string = [OMBUser currentUser].school;
  }
  NSAttributedString *text = [string attributedStringWithFont: 
    [UIFont normalTextFont] lineHeight: 22.0f];
  // CGRect textRect = [text boundingRectWithSize: 
  //   CGSizeMake(nameLabel.frame.size.width, 9999) 
  //     options: NSStringDrawingUsesLineFragmentOrigin 
  //       context: nil];
  // schoolLabel.frame = CGRectMake(nameLabel.frame.origin.x, 
  //   nameLabel.frame.origin.y + nameLabel.frame.size.height + 
  //   (padding * 0.5), 
  //     nameLabel.http://onmyblock.com/frame.size.width, textRect.size.height);
  schoolLabel.attributedText = text;
}

@end
