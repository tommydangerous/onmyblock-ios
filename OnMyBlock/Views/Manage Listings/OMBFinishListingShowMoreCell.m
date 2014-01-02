//
//  OMBFinishListingShowMoreCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingShowMoreCell.h"

#import "UIColor+Extensions.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@implementation OMBFinishListingShowMoreCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;

  _label = [UILabel new];
  _label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  _label.frame = CGRectMake(padding, 0.0f, 
    screenWidth - (padding * 2), [OMBFinishListingShowMoreCell heightForCell]);
  _label.text = @"Show More";
  _label.textColor = [UIColor textColor];
  [self.contentView addSubview: _label];

  CGFloat arrowSize = [OMBFinishListingShowMoreCell heightForCell] * 0.3;
  _arrowImageView = [UIImageView new];
  _arrowImageView.frame = CGRectMake(screenWidth - (arrowSize + padding),
    ([OMBFinishListingShowMoreCell heightForCell] - arrowSize) * 0.5,
      arrowSize, arrowSize);
  _arrowImageView.image = [UIImage imageNamed: @"arrow_right.png"];
  _arrowImageView.transform = CGAffineTransformMakeRotation(
    DEGREES_TO_RADIANS(90));
  [self.contentView addSubview: _arrowImageView];

  UIView *bottomBorder = [UIView new];
  bottomBorder.backgroundColor = [UIColor grayLight];
  bottomBorder.frame = CGRectMake(0.0f, 
    [OMBFinishListingShowMoreCell heightForCell] - 0.5f, screenWidth, 0.5f);
  [self.contentView addSubview: bottomBorder];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return 44.0f;
}

@end
