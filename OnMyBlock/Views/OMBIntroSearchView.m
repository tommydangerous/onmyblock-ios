//
//  OMBIntroSearchView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/8/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroSearchView.h"

#import "DRNRealTimeBlurView.h"
#import "UIColor+Extensions.h"

@implementation OMBIntroSearchView

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

  // About 60 on 3.5 inch
  float marginTop = screen.size.height * 0.125;
  // About 20 on 3.5 inch
  float paddingTop = screen.size.height * 0.04167;

  // Find houses and
  UILabel *label1 = [[UILabel alloc] init];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 23];
  label1.frame = CGRectMake(0, marginTop, screen.size.width, 36);
  label1.text = @"Find houses and";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor grayDark];
  [self addSubview: label1];
  // apartments on our map
  UILabel *label2 = [[UILabel alloc] init];
  label2.font = label1.font;
  label2.frame = CGRectMake(label1.frame.origin.x, 
    (label1.frame.origin.y + label1.frame.size.height), 
      label1.frame.size.width, label1.frame.size.height);
  label2.text = @"apartments on our map.";
  label2.textAlignment = label1.textAlignment;
  label2.textColor = label1.textColor;
  [self addSubview: label2];

  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.frame = CGRectMake(0, 
    (label2.frame.origin.y + label2.frame.size.height + paddingTop), 
      screen.size.width, 155);
  imageView.image = [UIImage imageNamed: @"intro_search_image.png"];
  [self addSubview: imageView];

  // Or browse through
  UILabel *label3 = [[UILabel alloc] init];
  label3.font = label1.font;
  label3.frame = CGRectMake(label2.frame.origin.x, 
    (imageView.frame.origin.y + imageView.frame.size.height + paddingTop), 
      label2.frame.size.width, label2.frame.size.height);
  label3.text = @"Or browse through";
  label3.textAlignment = label2.textAlignment;
  label3.textColor = label1.textColor;
  [self addSubview: label3];
  // our list view
  UILabel *label4 = [[UILabel alloc] init];
  label4.font = label1.font;
  label4.frame = CGRectMake(label3.frame.origin.x, 
    (label3.frame.origin.y + label3.frame.size.height), 
      label3.frame.size.width, label3.frame.size.height);
  label4.text = @"our list view.";
  label4.textAlignment = label3.textAlignment;
  label4.textColor = label3.textColor;
  [self addSubview: label4];

  return self;
}

@end
