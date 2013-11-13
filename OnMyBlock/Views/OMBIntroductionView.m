//
//  OMBIntroductionView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/12/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroductionView.h"

#import "UIColor+Extensions.h"

@implementation OMBIntroductionView

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.frame = screen;

  // Faded map
  UIImageView *fadedMap = [[UIImageView alloc] init];
  fadedMap.frame = CGRectMake(0, (screen.size.height - (50 + 175)), 
    screen.size.width, 175);
  fadedMap.image = [UIImage imageNamed: @"intro_map_faded.png"];
  [self addSubview: fadedMap];

  // About 43.2 on 3.5 inch
  float marginTop = screen.size.height * 0.1667;
  // About 100 on 3.5 inch
  float imageDimension = screen.size.height * 0.2083;

  UILabel *label1 = [[UILabel alloc] init];
  label1.frame = CGRectMake(40, marginTop, (screen.size.width - 80), 36);
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 23];
  label1.text = @"Search the best";
  label1.textColor = [UIColor grayDark];
  [self addSubview: label1];

  UILabel *label2 = [[UILabel alloc] init];
  label2.frame = CGRectMake(label1.frame.origin.x,
    (label1.frame.origin.y + label1.frame.size.height), label1.frame.size.width,
      label1.frame.size.height);
  label2.font = label1.font;
  label2.text = @"San Diego listings";
  label2.textColor = label1.textColor;
  [self addSubview: label2];

  UILabel *label3 = [[UILabel alloc] init];
  label3.frame = CGRectMake(label2.frame.origin.x,
    (label2.frame.origin.y + label2.frame.size.height), label2.frame.size.width,
      label2.frame.size.height);
  label3.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 23];
  label3.text = @"in the most popular";
  label3.textColor = label2.textColor;
  [self addSubview: label3];

  UILabel *label4 = [[UILabel alloc] init];
  label4.frame = CGRectMake(label3.frame.origin.x,
    (label3.frame.origin.y + label3.frame.size.height), label3.frame.size.width,
      label3.frame.size.height);
  label4.font = label3.font;
  label4.text = @"college neighborhoods.";
  label4.textColor = label3.textColor;
  [self addSubview: label4];

  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.frame = CGRectMake(
    (screen.size.width - (imageDimension + (marginTop / 2.0))), 
      (screen.size.height - (imageDimension + marginTop + 50)), 
        imageDimension, imageDimension);
  imageView.image = [UIImage imageNamed: @"logo_marker.png"];
  [self addSubview: imageView];

  return self;
}

@end
