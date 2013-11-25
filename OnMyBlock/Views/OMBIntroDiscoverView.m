//
//  OMBIntroDiscoverView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroDiscoverView.h"

#import "OMBGradientView.h"
#import "UIColor+Extensions.h"

@implementation OMBIntroDiscoverView

@synthesize marker1 = _marker1;
@synthesize marker2 = _marker2;
@synthesize marker3 = _marker3;

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;

  self.frame = screen;

  UIImageView *map = [[UIImageView alloc] init];
  map.clipsToBounds = YES;
  map.contentMode = UIViewContentModeScaleAspectFill;
  map.frame = screen;
  map.image = [UIImage imageNamed: @"map_background_image.png"];
  [self addSubview: map];

  OMBGradientView *gradientView = [[OMBGradientView alloc] init];
  gradientView.colors = @[
    [UIColor colorWithWhite: 1 alpha: 0],
    [UIColor whiteColor]
  ];
  gradientView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
  // [self addSubview: gradientView];

  _marker1 = [[UIImageView alloc] init];
  _marker1.frame = CGRectMake(0, (-1 * (screenWidth * 0.3)),
    (screenWidth * 0.3), (screenWidth * 0.3));
  _marker1.image = [UIImage imageNamed: @"logo_marker_filled.png"];
  [self addSubview: _marker1];

  _marker2 = [[UIImageView alloc] init];
  _marker2.frame = CGRectMake((screenWidth * 0.75), (-1 * (screenWidth * 0.2)),
    (screenWidth * 0.2), (screenWidth * 0.2));
  _marker2.image = _marker1.image;
  [self addSubview: _marker2];

  _marker3 = [[UIImageView alloc] init];
  _marker3.frame = CGRectMake((screenWidth * 0.2), (-1 * (screenWidth * 0.15)),
    (screenWidth * 0.15), (screenWidth * 0.15));
  _marker3.image = _marker1.image;
  [self addSubview: _marker3];

  UILabel *label1 = [[UILabel alloc] init];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 22];
  label1.frame = CGRectMake(0, (screen.size.height - (33 * 4)),
    screen.size.width, 33);
  label1.text = @"Discover the best";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor textColor];
  [self addSubview: label1];

  UILabel *label2 = [[UILabel alloc] init];
  label2.font = label1.font;
  label2.frame = CGRectMake(label1.frame.origin.x,
    (label1.frame.origin.y + label1.frame.size.height),
      label1.frame.size.width, label1.frame.size.height);
  label2.text = @"college sublets and houses";
  label2.textAlignment = label1.textAlignment;
  label2.textColor = label1.textColor;
  [self addSubview: label2];

  return self;
}

@end
