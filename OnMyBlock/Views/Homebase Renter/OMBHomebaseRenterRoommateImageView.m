//
//  OMBHomebaseRenterRoommateImageView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterRoommateImageView.h"

#import "OMBCenteredImageView.h"
#import "UIColor+Extensions.h"

@implementation OMBHomebaseRenterRoommateImageView

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;


  CGFloat imageSize = self.frame.size.width;
  CGFloat nameLabelHeight = 22.0f;
  CGFloat totalHeight = imageSize + nameLabelHeight;

  _imageView = [[OMBCenteredImageView alloc] init]; 
  _imageView.frame = CGRectMake(0.0f, 
    (self.frame.size.height - totalHeight) * 0.5f, imageSize, imageSize);
  _imageView.layer.cornerRadius = _imageView.frame.size.width * 0.5f;
  [self addSubview: _imageView];

  _nameLabel = [UILabel new];
  _nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  _nameLabel.frame = CGRectMake(0.0f, 
    _imageView.frame.origin.y + _imageView.frame.size.height, 
      self.frame.size.width, nameLabelHeight);
  _nameLabel.textColor = [UIColor textColor];
  _nameLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview: _nameLabel];

  return self;
}

@end
