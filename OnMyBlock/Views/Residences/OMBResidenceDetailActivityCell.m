//
//  OMBResidenceDetailActivityCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailActivityCell.h"

@implementation OMBResidenceDetailActivityCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];

  float screeWidth = screen.size.width;

  float padding = 20.0f;

  self.titleLabel.text = @"Activity";

  _mainTextLabel = [[UILabel alloc] init];
  _mainTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  _mainTextLabel.frame = CGRectMake(padding, 
    self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height,
      screeWidth - (padding * 2), 44.0f);
  _mainTextLabel.text = @"Offers";
  _mainTextLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: _mainTextLabel];

  CGFloat numberLabelSize = _mainTextLabel.frame.size.height - (8.0f * 2);
  _numberLabel = [[UILabel alloc] init];
  _numberLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  _numberLabel.frame = CGRectMake(
    screeWidth - (padding + numberLabelSize), 
      self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 
      ((_mainTextLabel.frame.size.height - numberLabelSize) * 0.5), 
        numberLabelSize, numberLabelSize);
  _numberLabel.layer.borderColor = [UIColor blue].CGColor;
  _numberLabel.layer.borderWidth = 1.0f;
  _numberLabel.layer.cornerRadius = _numberLabel.frame.size.width * 0.5;
  _numberLabel.text = @"5";
  _numberLabel.textAlignment = NSTextAlignmentCenter;
  _numberLabel.textColor = [UIColor blue];
  [self.contentView addSubview: _numberLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return 44.0f + 44.0f;
}

@end
