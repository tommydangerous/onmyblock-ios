//
//  OMBMenuBarButtonItem.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/9/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMenuBarButtonItem.h"

// Categories
#import "UIColor+Extensions.h"

@interface OMBMenuBarButtonItem ()
{
  UIButton *button;
}

@end

@implementation OMBMenuBarButtonItem

#pragma mark - Initializer

- (id)initWithFrame:(CGRect)rect
{
  if (!(self = [super init])) return nil;

  self.customView = [[UIView alloc] initWithFrame:rect];

  NSInteger rows              = 4;
  NSInteger spaces            = rows - 1;
  CGFloat rowHeightPercentage = 0.7;
  
  CGFloat heightOfRow = 1.5;
  CGFloat heightOfSpace = 
    (CGRectGetHeight(rect) - (rows * heightOfRow)) / spaces;
  CGFloat width  = CGRectGetWidth(rect);

  NSArray *heightArray = @[
    @(width),
    @(width / (1.618 * 1)),
    @(width / (1.618 * rowHeightPercentage)),
    @(width / (1.618 * 2))
  ];

  for (int i = 0; i < rows; i++) {
    UIView *row         = [[UIView alloc] init];
    row.backgroundColor = [UIColor blue];
    row.frame           = CGRectMake(0, (heightOfRow + heightOfSpace) * i, 
      [heightArray[i] floatValue], heightOfRow);
    row.userInteractionEnabled = NO;
    [self.customView addSubview:row];
  }

  button = [[UIButton alloc] initWithFrame:rect];
  [self.customView addSubview:button];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)addTarget:(id)target action:(SEL)action
{
  [button addTarget:target action:action 
    forControlEvents:UIControlEventTouchUpInside];
}

@end
