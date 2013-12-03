//
//  OMBIntroWelcomeView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroWelcomeView.h"

#import "UIColor+Extensions.h"

@implementation OMBIntroWelcomeView

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen      = [[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;

  UIImageView *imageView = [[UIImageView alloc] init];
  float imageSize = screenHeight * 0.4;
  imageView.frame = CGRectMake((screenWidth - imageSize) * 0.5, 
    (screenHeight - imageSize) * 0.5, imageSize, imageSize);
  imageView.image = [UIImage imageNamed: @"logo_shadow.png"];
  [self addSubview: imageView];


  UILabel *welcomeLabel = [[UILabel alloc] init];
  welcomeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 36];
  welcomeLabel.frame = CGRectMake(0, imageView.frame.origin.y - 54,
    screenWidth, 54);
  welcomeLabel.text = @"Welcome to";
  welcomeLabel.textAlignment = NSTextAlignmentCenter;
  welcomeLabel.textColor = [UIColor textColor];
  [self addSubview: welcomeLabel];

  UILabel *onmyblock = [[UILabel alloc] init];
  onmyblock.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 36];
  onmyblock.frame = CGRectMake(0, 
    imageView.frame.origin.y + imageView.frame.size.height, screenWidth, 54);
  NSMutableAttributedString *onmyString = 
    [[NSMutableAttributedString alloc] initWithString: @"OnMy" attributes: @{
      NSForegroundColorAttributeName: [UIColor textColor]
    }];
  NSAttributedString *blockString = [[NSAttributedString alloc] initWithString: 
    @"Block" attributes: @{
      NSForegroundColorAttributeName: [UIColor blue]
    }];
  [onmyString appendAttributedString: blockString];
  onmyblock.attributedText = onmyString;
  onmyblock.textAlignment = NSTextAlignmentCenter;
  [self addSubview: onmyblock];

  return self;
}

@end
