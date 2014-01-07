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
  CGFloat imageSize = screenWidth * 0.3f;

  OMBCenteredImageView *imageView = [[OMBCenteredImageView alloc] init];
  // imageView.clipsToBounds = YES;
  imageView.frame = CGRectMake(padding, padding, imageSize, imageSize);
  imageView.image = [OMBUser currentUser].image;
  imageView.layer.cornerRadius = imageSize * 0.5f;
  [self.contentView addSubview: imageView];

  UILabel *nameLabel = [UILabel new];
  nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  nameLabel.frame = CGRectMake(
    imageView.frame.origin.x + imageView.frame.size.width + padding, 
      imageView.frame.origin.y, screenWidth - (padding + padding + 
        imageView.frame.origin.x + imageView.frame.size.width), 27.0f);
  nameLabel.text = [[OMBUser currentUser] fullName];
  nameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: nameLabel];

  UILabel *schoolLabel = [UILabel new];  
  schoolLabel.numberOfLines = 0;
  NSAttributedString *text = 
    [@"University of California - Berkeley" attributedStringWithFont: 
      [UIFont fontWithName: @"HelveticaNeue-Light" size: 15] lineHeight: 27.0f];
  CGRect textRect = [text boundingRectWithSize: 
    CGSizeMake(nameLabel.frame.size.width, 9999) 
      options: NSStringDrawingUsesLineFragmentOrigin 
        context: nil];
  schoolLabel.frame = CGRectMake(nameLabel.frame.origin.x, 
    nameLabel.frame.origin.y + nameLabel.frame.size.height + (padding * 0.5), 
      nameLabel.frame.size.width, textRect.size.height);
  schoolLabel.attributedText = text;
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
  CGFloat imageSize = screenWidth * 0.3f;

  return padding + imageSize + padding;
}

@end
