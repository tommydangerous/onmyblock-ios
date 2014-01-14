//
//  OMBResidenceDetailAmenitiesCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailAmenitiesCell.h"

@implementation OMBResidenceDetailAmenitiesCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

    self.titleLabel.text = @"Amenities";

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadAmenitiesData: (NSArray *) array
{
  if (amenities) {
    return;
  }
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screeWidth = screen.size.width;
  CGFloat padding = 20.0f;

  amenities = array;

  for (NSString *string in amenities) {
    CGFloat viewHeight = 23.0f;
    CGFloat viewWidth  = (screeWidth - (padding * 2)) * 0.5;

    NSInteger index = [array indexOfObject: string];
    CGFloat originX = padding;
    // Left
    if (index % 2) {
      originX = screeWidth - (viewWidth + padding);
    }
    // Right
    else {
      originX = padding;
    }
    CGFloat originY = self.titleLabel.frame.origin.y + 
      self.titleLabel.frame.size.height + 
        padding + (viewHeight * (index / 2));

    UIView *v = [[UIView alloc] init];
    v.frame = CGRectMake(originX, originY, viewWidth, viewHeight);
    [self.contentView addSubview: v];

    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
    label.frame = CGRectMake(padding, 0.0f, v.frame.size.width - padding,
      v.frame.size.height);
    label.text = [string capitalizedString];
    label.textColor = [UIColor textColor];
    [v addSubview: label];

    CGFloat bulletSize = 8.0f;
    UIView *bullet = [[UIView alloc] init];
    bullet.frame = CGRectMake(0.0f, (v.frame.size.height - bulletSize) * 0.5,
      bulletSize, bulletSize);
    bullet.layer.borderColor  = [UIColor blue].CGColor;
    bullet.layer.borderWidth  = 1.0f;
    bullet.layer.cornerRadius = bulletSize * 0.5f;
    [v addSubview: bullet];
  } 
}

@end
