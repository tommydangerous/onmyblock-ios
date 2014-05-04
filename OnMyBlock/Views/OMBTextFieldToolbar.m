//
//  OMBTextFieldToolbar.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 5/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTextFieldToolbar.h"

#import "UIColor+Extensions.h"

@implementation OMBTextFieldToolbar

- (id) init
{
  return [self initWithFrame: CGRectZero];
}

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  // Left padding
  // Cancel
  // Spacing
  // Done
  // Right padding

  // Left padding
  UIBarButtonItem *leftPadding =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
   UIBarButtonSystemItemFixedSpace target: nil action: nil];
  // iOS 7 toolbar spacing is 16px; 20px on iPad
  leftPadding.width = 4.0f;

  // Cancel
  _cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
    style: UIBarButtonItemStylePlain target: nil action: nil];

  // Spacing
  UIBarButtonItem *flexibleSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemFlexibleSpace target: nil action: nil];

  // Done
  _doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
    style: UIBarButtonItemStylePlain target: nil action: nil];

  // Right padding
  UIBarButtonItem *rightPadding =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemFixedSpace target: nil action: nil];
  // iOS 7 toolbar spacing is 16px; 20px on iPad
  rightPadding.width = 4.0f;

  self.clipsToBounds = YES;
  self.items = @[
    leftPadding, _cancelBarButtonItem,
    flexibleSpace, _doneBarButtonItem, rightPadding
  ];
  self.tintColor = [UIColor blueDark];

  return self;
}

@end
