//
//  OMBHouseGraphicView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/22/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBHouseGraphicView.h"

#import "OMBTriangleView.h"
#import "UIColor+Extensions.h"

@implementation OMBHouseGraphicView

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  self.backgroundColor = [UIColor clearColor];

  UIView *chimney = [[UIView alloc] init];
  chimney.backgroundColor = [UIColor whiteColor];
  float chimneyHeight = self.frame.size.height * 0.4;
  float chimneyWidth  = self.frame.size.width * 0.1;
  chimney.frame = CGRectMake(((self.frame.size.width * 0.3) - chimneyWidth), 
    (self.frame.size.height - 
    ((self.frame.size.height * 0.5) + chimneyHeight)), 
      chimneyWidth, chimneyHeight);
  chimney.layer.borderColor = [UIColor blackColor].CGColor;
  chimney.layer.borderWidth = 1.0;
  [self addSubview: chimney];

  OMBTriangleView *roof = [[OMBTriangleView alloc] initWithFrame: rect];
  roof.frame = CGRectMake(roof.frame.origin.x, 
    (-1 * (roof.frame.size.height * 0.5)), roof.frame.size.width,
      roof.frame.size.height);
  roof.backgroundColor = [UIColor clearColor];
  [self addSubview: roof];

  UIView *base = [[UIView alloc] init];
  base.backgroundColor = [UIColor whiteColor];
  float baseHeight = self.frame.size.height * 0.5;
  float baseWidth =  self.frame.size.height * 0.7;
  base.frame = CGRectMake(
    ((self.frame.size.width - baseWidth) / 2.0),
      (self.frame.size.height - baseHeight), baseWidth, baseHeight);
  base.layer.borderColor = [UIColor blackColor].CGColor;
  base.layer.borderWidth = 1.0;
  [self addSubview: base];

  UIView *door = [[UIView alloc] init];
  door.backgroundColor = [UIColor whiteColor];
  float doorHeight = baseHeight * 0.5;
  float doorWidth  = baseWidth * 0.3;
  door.frame = CGRectMake(
    ((base.frame.size.width - doorWidth) / 2.0),
      (base.frame.size.height - doorHeight), doorWidth, doorHeight);
  door.layer.borderColor = [UIColor blackColor].CGColor;
  door.layer.borderWidth = 1.0;
  [base addSubview: door];

  UIView *doorKnob = [[UIView alloc] init];
  doorKnob.backgroundColor = [UIColor clearColor];
  float doorKnobHeight = doorWidth * 0.2;
  float doorKnobWidth  = doorKnobHeight;
  doorKnob.frame = CGRectMake(
    (door.frame.size.width - (doorKnobWidth * 1.5)),
      ((door.frame.size.height - doorKnobHeight) / 2.0),
        doorKnobWidth, doorKnobHeight);
  doorKnob.layer.borderColor = [UIColor blackColor].CGColor;
  doorKnob.layer.borderWidth = 1.0;
  doorKnob.layer.cornerRadius = doorKnobHeight * 0.5;
  [door addSubview: doorKnob];

  UIView *windowPane = [[UIView alloc] init];
  windowPane.backgroundColor = [UIColor whiteColor];
  float windowPaneHeight = baseHeight * 0.3;
  float windowPaneWidth  = windowPaneHeight;
  windowPane.frame = CGRectMake(
    ((baseWidth - windowPaneWidth) * 0.8),
      ((baseHeight - (doorHeight + windowPaneHeight)) * 0.5),
        windowPaneWidth, windowPaneHeight);
  windowPane.layer.borderColor = [UIColor grayDark].CGColor;
  windowPane.layer.borderWidth = windowPaneWidth * 0.05;
  windowPane.layer.cornerRadius = windowPaneWidth * 0.5;
  [base addSubview: windowPane];

  return self;
}

@end
