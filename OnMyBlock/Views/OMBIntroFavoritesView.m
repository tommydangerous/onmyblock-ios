//
//  OMBIntroFavoritesView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/8/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroFavoritesView.h"

#import "DRNRealTimeBlurView.h"
#import "UIColor+Extensions.h"

@implementation OMBIntroFavoritesView

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
  float marginTop = screen.size.height * 0.09;

  UIImageView *imageView1 = [[UIImageView alloc] init];
  imageView1.frame = CGRectMake(20, marginTop * 2, 60, 60);
  imageView1.image = [UIImage imageNamed: @"favorite_pink.png"];
  [self addSubview: imageView1];

  UILabel *label1 = [[UILabel alloc] init];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  label1.frame = CGRectMake(
    (imageView1.frame.origin.x + imageView1.frame.size.width + 20), 
      imageView1.frame.origin.y, 
        (screen.size.width - ((imageView1.frame.origin.x * 2) + 
          imageView1.frame.size.width + 20)), 
            (imageView1.frame.size.height + 10));
  label1.numberOfLines = 0;
  label1.text = 
    @"Build a personal list of your favorite houses and apartments.";
  label1.textColor = [UIColor grayDark];
  [self addSubview: label1];

  UIImageView *imageView2 = [[UIImageView alloc] init];
  imageView2.frame = CGRectMake(imageView1.frame.origin.x,
    (imageView1.frame.origin.y + imageView1.frame.size.height + marginTop),
      imageView1.frame.size.width, imageView1.frame.size.height);
  imageView2.image = [UIImage imageNamed: @"share_icon_pink.png"];
  [self addSubview: imageView2];

  UILabel *label2 = [[UILabel alloc] init];
  label2.font = label1.font;
  label2.frame = CGRectMake(label1.frame.origin.x, imageView2.frame.origin.y,
    label1.frame.size.width, label1.frame.size.height);
  label2.numberOfLines = label1.numberOfLines;
  label2.text = @"Share cool places with your friends and classmates.";
  label2.textColor = label1.textColor;
  [self addSubview: label2];

  UIImageView *imageView3 = [[UIImageView alloc] init];
  imageView3.frame = CGRectMake(imageView2.frame.origin.x,
    (imageView2.frame.origin.y + imageView2.frame.size.height + marginTop),
      imageView2.frame.size.width, imageView2.frame.size.height);
  imageView3.image = [UIImage imageNamed: @"review_pink.png"];
  [self addSubview: imageView3];

  UILabel *label3 = [[UILabel alloc] init];
  label3.font = label2.font;
  label3.frame = CGRectMake(label2.frame.origin.x, imageView3.frame.origin.y,
    label2.frame.size.width, label2.frame.size.height);
  label3.numberOfLines = label2.numberOfLines;
  label3.text = 
    @"See reviews about the neighborhood and nearby college hangouts.";
  label3.textColor = label2.textColor;
  [self addSubview: label3];

  return self;
}

@end
