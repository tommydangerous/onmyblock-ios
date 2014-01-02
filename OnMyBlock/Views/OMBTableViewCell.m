//
//  OMBTableViewCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@implementation OMBTableViewCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier leftPadding: (float) padding
{
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;
  
  leftPadding = padding;

  return self;
}

#pragma mark - Override

#pragma mark - Override UITableViewCell

- (void) layoutSubviews 
{
  [super layoutSubviews];

  CGRect tmpFrame      = self.imageView.frame;
  tmpFrame.origin.x    = leftPadding;
  self.imageView.frame = tmpFrame;

  tmpFrame             = self.textLabel.frame;
  tmpFrame.origin.x    = leftPadding;
  self.textLabel.frame = tmpFrame;

  tmpFrame                   = self.detailTextLabel.frame;
  tmpFrame.origin.x          = leftPadding;
  self.detailTextLabel.frame = tmpFrame;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  // Subclasses implement this
  return 0.0f;
}

@end
