//
//  OMBIntroWelcomeView.m
//  _onmyblockLabel
//
//  Created by Tommy DANGerous on 12/2/13.
//  Copyright (c) 2013 _onmyblockLabel. All rights reserved.
//

#import "OMBIntroWelcomeView.h"

#import "UIColor+Extensions.h"

@implementation OMBIntroWelcomeView

@synthesize logoImageView  = _logoImageView;
@synthesize welcomeLabel   = _welcomeLabel;
@synthesize onmyblockLabel = _onmyblockLabel;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen      = [[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;

  _logoImageView = [[UIImageView alloc] init];
  float imageSize = screenHeight * 0.4;
  _logoImageView.frame = CGRectMake((screenWidth - imageSize) * 0.5, 
    (screenHeight - imageSize) * 0.5, imageSize, imageSize);
  _logoImageView.image = [UIImage imageNamed: @"logo_shadow.png"];
  [self addSubview: _logoImageView];


  _welcomeLabel = [[UILabel alloc] init];
  _welcomeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 36];
  _welcomeLabel.frame = CGRectMake(0, _logoImageView.frame.origin.y - 54,
    screenWidth, 54);
  _welcomeLabel.text = @"Welcome to";
  _welcomeLabel.textAlignment = NSTextAlignmentCenter;
  _welcomeLabel.textColor = [UIColor textColor];
  [self addSubview: _welcomeLabel];

  _onmyblockLabel = [[UILabel alloc] init];
  _onmyblockLabel.font = _welcomeLabel.font;
  _onmyblockLabel.frame = CGRectMake(0, 
    _logoImageView.frame.origin.y + _logoImageView.frame.size.height, 
      screenWidth, 54);
  NSMutableAttributedString *onmyString = 
    [[NSMutableAttributedString alloc] initWithString: @"OnMy" attributes: @{
      NSForegroundColorAttributeName: [UIColor textColor]
    }];
  NSAttributedString *blockString = [[NSAttributedString alloc] initWithString: 
    @"Block" attributes: @{
      NSForegroundColorAttributeName: [UIColor blue]
    }];
  [onmyString appendAttributedString: blockString];
  _onmyblockLabel.attributedText = onmyString;
  _onmyblockLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview: _onmyblockLabel];

  return self;
}

@end
