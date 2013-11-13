//
//  OMBIntroContactView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/8/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroContactView.h"

#import "DRNRealTimeBlurView.h"
#import "UIColor+Extensions.h"

@implementation OMBIntroContactView

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.frame = screen;

  // About 80 on 3.5 inch
  float marginTop = screen.size.height * 0.1667;
  // About 30 on 3.5 inch
  float paddingtop = screen.size.height * 0.0625;

  // Faded map
  UIImageView *fadedMap = [[UIImageView alloc] init];
  fadedMap.frame = CGRectMake(0, (screen.size.height - (50 + 175)), 
    screen.size.width, 175);
  fadedMap.image = [UIImage imageNamed: @"intro_map_faded.png"];
  [self addSubview: fadedMap];
  
  UILabel *label1 = [[UILabel alloc] init];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 23];
  label1.frame = CGRectMake(0, marginTop, screen.size.width, 36);
  label1.text = @"Easily contact a realtor";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor grayDark];
  [self addSubview: label1];

  UILabel *label2 = [[UILabel alloc] init];
  label2.font = label1.font;
  label2.frame = CGRectMake(label1.frame.origin.x, 
    (label1.frame.origin.y + label1.frame.size.height), 
      label1.frame.size.width, label1.frame.size.height);
  label2.text = @"to schedule a tour.";
  label2.textAlignment = label1.textAlignment;
  label2.textColor = label1.textColor;
  [self addSubview: label2];

  // Email
  UIView *emailBox = [[UIView alloc] init];
  emailBox.backgroundColor = [UIColor backgroundColor];
  emailBox.frame = CGRectMake(20, 
    (label2.frame.origin.y + label2.frame.size.height + paddingtop), 
      (screen.size.width - 40), 70);
  emailBox.layer.borderColor = [UIColor grayLight].CGColor;
  emailBox.layer.borderWidth = 2.0;
  emailBox.layer.cornerRadius = 2.0;
  [self addSubview: emailBox];
  // Email button view
  UIView *emailView = [[UIView alloc] init];
  emailView.backgroundColor = [UIColor green];
  emailView.frame = CGRectMake(10, 10, (emailBox.frame.size.width - 20),
    (emailBox.frame.size.height - 20));
  emailView.layer.cornerRadius = emailBox.layer.cornerRadius;
  [emailBox addSubview: emailView];
  // Email button view image
  UIImageView *emailImageView = [[UIImageView alloc] init];
  emailImageView.frame = CGRectMake(((emailView.frame.size.width - 30) / 2.0),
    ((emailView.frame.size.height - 30) / 2.0), 30, 30);
  emailImageView.image = [UIImage imageNamed: @"email_icon_white.png"];
  [emailView addSubview: emailImageView];

  // Phone
  UIView *phoneBox = [[UIView alloc] init];
  phoneBox.backgroundColor = [UIColor backgroundColor];
  phoneBox.frame = CGRectMake(emailBox.frame.origin.x,
    (emailBox.frame.origin.y + emailBox.frame.size.height + paddingtop),
      emailBox.frame.size.width, emailBox.frame.size.height);
  phoneBox.layer.borderColor = emailBox.layer.borderColor;
  phoneBox.layer.borderWidth = emailBox.layer.borderWidth;
  phoneBox.layer.cornerRadius = emailBox.layer.cornerRadius;
  [self addSubview: phoneBox];
  // Phone button view
  UIView *phoneView = [[UIView alloc] init];
  phoneView.backgroundColor = [UIColor blue];
  phoneView.frame = emailView.frame;
  phoneView.layer.cornerRadius = emailView.layer.cornerRadius;
  [phoneBox addSubview: phoneView];
  UIImageView *phoneImageView = [[UIImageView alloc] init];
  phoneImageView.frame = emailImageView.frame;
  phoneImageView.image = [UIImage imageNamed: @"phone.png"];
  [phoneView addSubview: phoneImageView];

  return self;
}

@end
