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
  NSMutableArray *menuBars;
}

@end

@implementation OMBMenuBarButtonItem

#pragma mark - Initializer

- (id)initWithFrame:(CGRect)frame
{
  if (!(self = [super init])) return nil;

  CGRect rect = CGRectMake(0, 0, 24, 22);

  menuBars = [NSMutableArray array];

  self.customView = [[UIView alloc] initWithFrame:frame];

  NSInteger rows              = 4;
  NSInteger spaces            = rows - 1;
  CGFloat rowHeightPercentage = 0.7;
  
  CGFloat heightOfRow = 1.5;
  CGFloat heightOfSpace = 
    (CGRectGetHeight(rect) - (rows * heightOfRow)) / spaces;
  CGFloat width  = CGRectGetWidth(rect);

  NSArray *widthArray = @[
    @(width),
    @(width / (1.618 * 1)),
    @(width / (1.618 * rowHeightPercentage)),
    @(width / (1.618 * 2))
  ];

  CGFloat originY = (CGRectGetHeight(frame) - CGRectGetHeight(rect)) * 0.5;
  for (int i = 0; i < rows; i++) {
    UIView *row         = [[UIView alloc] init];
    row.backgroundColor = [UIColor blue];
    row.frame           = CGRectMake(
      0,
      originY + (heightOfRow + heightOfSpace) * i, 
      [widthArray[i] floatValue], 
      heightOfRow
    );
    row.userInteractionEnabled = NO;
    [self.customView addSubview:row];
    [menuBars addObject:row];
  }

  button = [[UIButton alloc] initWithFrame:CGRectMake(
    0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
  [button addTarget:self action:@selector(buttonTouchDown:)
    forControlEvents:UIControlEventTouchDown];
  [button addTarget:self action:@selector(buttonTouchUpInside:)
    forControlEvents:UIControlEventTouchDragExit];
  [button addTarget:self action:@selector(buttonTouchUpInside:)
    forControlEvents:UIControlEventTouchUpInside];
  [button addTarget:self action:@selector(buttonTouchUpInside:)
    forControlEvents:UIControlEventTouchUpOutside];
  [button addTarget:self action:@selector(buttonTouchUpInside:)
    forControlEvents:UIControlEventTouchCancel];
  [self.customView addSubview:button];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Private

- (void)animateMenuBarsOpacity:(CGFloat)opacity
{
  [UIView animateWithDuration:0.1 animations:^{
    for (UIView *view in menuBars) {
      view.alpha = opacity;
    }   
  }];
}

- (void)buttonTouchDown:(UIButton *)button
{
  [self animateMenuBarsOpacity:0.3];
}

- (void)buttonTouchUpInside:(UIButton *)button
{
  [self animateMenuBarsOpacity:1];  
}

#pragma mark - Public

- (void)addTarget:(id)target action:(SEL)action
{
  [button addTarget:target action:action 
    forControlEvents:UIControlEventTouchUpInside];
}

@end
