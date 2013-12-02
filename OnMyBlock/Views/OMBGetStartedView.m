//
//  OMBGetStartedView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBGetStartedView.h"

#import "DDPageControl.h"
#import "OMBAppDelegate.h"
#import "OMBIntroViewController.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBGetStartedView

@synthesize getStartedButton = _getStartedButton;

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;

  self.frame = screen;

  UILabel *label1 = [[UILabel alloc] init];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 22];
  // 33 + 40 = height of label1 plus the height of the page control
  label1.frame = CGRectMake(0, ((screenHeight - (33 + 40)) * 0.5),
    screenWidth, 33);
  label1.text = @"Built for college students";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor textColor];
  [self addSubview: label1];

  UILabel *onmyblock = [[UILabel alloc] init];
  onmyblock.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 36];
  onmyblock.frame = CGRectMake(label1.frame.origin.x, 
    (label1.frame.origin.y - (54 + 20)), screenWidth, 54);
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

  _getStartedButton = [[UIButton alloc] init];
  float getStartedButtonWidth = screenWidth * 0.8;
  _getStartedButton.clipsToBounds = YES;
  _getStartedButton.frame = CGRectMake(screenWidth, 
    (label1.frame.origin.y + label1.frame.size.height + 20), 
      getStartedButtonWidth, 50);
  _getStartedButton.layer.cornerRadius = 2.0;
  _getStartedButton.titleLabel.font = 
    [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  [_getStartedButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blue]] forState: UIControlStateNormal];
  [_getStartedButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueDark]] 
      forState: UIControlStateHighlighted];
  [_getStartedButton addTarget: self action: @selector(getStartedButtonTapped)
    forControlEvents: UIControlEventTouchUpInside];
  [_getStartedButton setTitle: @"Get started" forState: UIControlStateNormal];
  [_getStartedButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
   [self addSubview: _getStartedButton];

   // Already signed up? Login
   UIButton *login = [[UIButton alloc] init];
   login.frame = CGRectMake(
    ((screenWidth - _getStartedButton.frame.size.width) * 0.5),
      (_getStartedButton.frame.origin.y + _getStartedButton.frame.size.height
      + 20),
        _getStartedButton.frame.size.width, 
          _getStartedButton.frame.size.height);
  login.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  NSMutableAttributedString *alreadyString = 
    [[NSMutableAttributedString alloc] initWithString: @"Already signed up? "
      attributes: @{ NSForegroundColorAttributeName: [UIColor grayMedium] }];
  NSAttributedString *loginString = [[NSAttributedString alloc] initWithString:
    @"Login" attributes: @{
      NSForegroundColorAttributeName: [UIColor blue]
    }];
  [alreadyString appendAttributedString: loginString];
  [login addTarget: self action: @selector(showLogin)
    forControlEvents: UIControlEventTouchUpInside];
  [login setAttributedTitle: alreadyString forState: UIControlStateNormal];
  [self addSubview: login];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) getStartedButtonTapped
{
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.container.introViewController scrollToPage: 
    appDelegate.container.introViewController.pageControl.numberOfPages];
}

- (void) showLogin
{
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.container.introViewController showLogin];
}

@end
