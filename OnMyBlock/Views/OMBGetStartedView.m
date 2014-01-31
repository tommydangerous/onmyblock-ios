//
//  OMBGetStartedView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBGetStartedView.h"

#import "AMBlurView.h"
#import "DDPageControl.h"
#import "OMBAppDelegate.h"
#import "OMBIntroStillImagesViewController.h"
#import "OMBOrView.h"
#import "OMBViewController.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

@implementation OMBGetStartedView

@synthesize getStartedButton = _getStartedButton;

- (id) init
{
  if (!(self = [super init])) return nil;

  // This is the order of views
  // OnMyBlock
  // Sign up using Facebook
  // We will never post on your behalf without permission
  // ----- or -----
  // Sign up using Email
  // Already a user? Login

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat standardHeight = OMBStandardHeight;
  CGFloat padding       = OMBPadding;
  CGFloat middleOriginY = screenHeight * 0.5f;
  CGFloat buttonHeight  = OMBStandardButtonHeight;
  CGFloat buttonWidth   = screenWidth - (padding * 2);

  self.frame = screen;

  // CGRect orViewRect = CGRectMake(padding, 
  //   middleOriginY + (screenHeight * 0.05f), 
  //     screenWidth - (padding * 2), standardHeight);
  // OMBOrView *orView = [[OMBOrView alloc] initWithFrame: orViewRect 
  //   color: [UIColor whiteColor]];
  // [self addSubview: orView];

  // We will never post on your behalf
  // UILabel *neverLabel = [UILabel new];
  // neverLabel.font = [UIFont normalTextFont];
  // neverLabel.frame = CGRectMake(orView.frame.origin.x, 
  //   orView.frame.origin.y - (standardHeight + (padding * 0.5f)), buttonWidth,
  //     standardHeight);
  // neverLabel.text = @"We will never post on your behalf";
  // neverLabel.textColor = [UIColor whiteColor];
  // neverLabel.textAlignment = NSTextAlignmentCenter;
  // [self addSubview: neverLabel];

  // Facebook button
  _facebookButtonView = [[AMBlurView alloc] init];
  _facebookButtonView.blurTintColor = [UIColor facebookBlue];
  _facebookButtonView.clipsToBounds = YES;
  _facebookButtonView.frame = CGRectMake(padding, 
    middleOriginY - (buttonHeight * 0.5f), buttonWidth, buttonHeight);
  _facebookButtonView.layer.cornerRadius = 5.0f;
  [self addSubview: _facebookButtonView];
  _facebookButton = [[UIButton alloc] init];
  _facebookButton.clipsToBounds = _facebookButtonView.clipsToBounds;
  _facebookButton.frame = _facebookButtonView.bounds;
  _facebookButton.layer.cornerRadius = _facebookButtonView.layer.cornerRadius;
  _facebookButton.titleLabel.font = [UIFont mediumTextFont];
  [_facebookButton setTitle: @"Sign up using Facebook" 
    forState: UIControlStateNormal];
  [_facebookButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor facebookBlueDark]] 
      forState: UIControlStateHighlighted];
  [_facebookButtonView addSubview: _facebookButton];
  CGFloat facebookImageSize = _facebookButton.frame.size.height - padding;
  _facebookButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
    facebookImageSize, 0.0f, 0.0f);
  UIImageView *facebookImageView = [[UIImageView alloc] init];
  facebookImageView.frame = CGRectMake(padding * 0.5, 
    (_facebookButton.frame.size.height - facebookImageSize) * 0.5, 
      facebookImageSize, facebookImageSize);
  facebookImageView.image = [UIImage image: 
    [UIImage imageNamed: @"facebook_icon_white.png"] 
      size: CGSizeMake(facebookImageSize, facebookImageSize)];
  [_facebookButton addSubview: facebookImageView];

  CGFloat middleOriginYTop = _facebookButtonView.frame.origin.y * 0.5f;

  // OnMyBlock
  UILabel *onmyblock = [[UILabel alloc] init];
  onmyblock.frame = CGRectMake(padding, middleOriginYTop - (54.0f * 0.5f),
    screenWidth - (padding * 2), 54.0f);
  onmyblock.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 36];
  NSMutableAttributedString *onmyString = 
    [[NSMutableAttributedString alloc] initWithString: @"OnMy" attributes: @{
      NSForegroundColorAttributeName: [UIColor whiteColor] //[UIColor textColor]
    }];
  NSAttributedString *blockString = [[NSAttributedString alloc] initWithString: 
    @"Block" attributes: @{
      NSForegroundColorAttributeName: [UIColor blue]
    }];
  [onmyString appendAttributedString: blockString];
  onmyblock.attributedText = onmyString;
  onmyblock.textAlignment = NSTextAlignmentCenter;
  [self addSubview: onmyblock];

  // Built for college students
  UILabel *label1 = [[UILabel alloc] init];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 22];
  // 33 + 40 = height of label1 plus the height of the page control
  // label1.frame = CGRectMake(0, ((screenHeight - (33 + 40)) * 0.5) - padding,
  //   screenWidth, 33);
  label1.frame = CGRectMake(padding, 
    onmyblock.frame.origin.y + onmyblock.frame.size.height, 
      screenWidth - (padding * 2), 33.0f);
  label1.text = @"Built for college students";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor whiteColor];
  [self addSubview: label1];

  // Sign up using Email
  _getStartedButtonView = [[AMBlurView alloc] init];
  _getStartedButtonView.blurTintColor = [UIColor whiteColor];
  _getStartedButtonView.clipsToBounds = YES;
  _getStartedButtonView.frame = CGRectMake(_facebookButtonView.frame.origin.x,
    _facebookButtonView.frame.origin.y + 
    _facebookButtonView.frame.size.height + padding, 
      _facebookButtonView.frame.size.width, 
        _facebookButtonView.frame.size.height);
  _getStartedButtonView.layer.cornerRadius = 
    _facebookButtonView.layer.cornerRadius;
  [self addSubview: _getStartedButtonView];
  // Button
  _getStartedButton = [[UIButton alloc] init];
  _getStartedButton.clipsToBounds = YES;
  _getStartedButton.frame = _getStartedButtonView.bounds;
  _getStartedButton.layer.cornerRadius = _facebookButton.layer.cornerRadius;
  _getStartedButton.titleLabel.font = _facebookButton.titleLabel.font;
  [_getStartedButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor grayVeryLight]] 
      forState: UIControlStateHighlighted];
  [_getStartedButton setTitle: @"Sign up with email" 
    forState: UIControlStateNormal];
  [_getStartedButton setTitleColor: [UIColor textColor]
    forState: UIControlStateNormal];
  [_getStartedButtonView addSubview: _getStartedButton];
  CGFloat emailImageSize = 
    _getStartedButton.frame.size.height - (padding * 1.5);
  _getStartedButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
    emailImageSize, 0.0f, 0.0f);
  UIImageView *emailImageView = [[UIImageView alloc] init];
  emailImageView.frame = CGRectMake(padding, 
    (_getStartedButton.frame.size.height - emailImageSize) * 0.5, 
      emailImageSize, emailImageSize);
  emailImageView.image = [UIImage image: 
    [UIImage imageNamed: @"messages_icon_dark.png"] 
      size: CGSizeMake(emailImageSize, emailImageSize)];
  [_getStartedButton addSubview: emailImageView];

  // Already a user? Login
  _loginButton = [UIButton new];
  _loginButton.contentHorizontalAlignment =
    UIControlContentHorizontalAlignmentRight;
  _loginButton.frame = CGRectMake(_getStartedButtonView.frame.origin.x,
    _getStartedButtonView.frame.origin.y + 
    _getStartedButtonView.frame.size.height, 
      _getStartedButtonView.frame.size.width, standardHeight);
  _loginButton.titleLabel.font = [UIFont normalTextFont];
  NSMutableAttributedString *alreadyString = 
    [[NSMutableAttributedString alloc] initWithString: @"Already a user? "
      attributes: @{ 
        NSForegroundColorAttributeName: [UIColor whiteColor] 
      }
    ];
  NSAttributedString *loginString = [[NSAttributedString alloc] initWithString:
    @"Login" attributes: @{
      NSForegroundColorAttributeName: [UIColor whiteColor]
    }
  ];
  [alreadyString appendAttributedString: loginString];
  [_loginButton setAttributedTitle: alreadyString 
    forState: UIControlStateNormal];
  [self addSubview: _loginButton];

  // Landlords
  _landlordButton = [UIButton new];
  _landlordButton.frame = CGRectMake((screenWidth * 0.5f) * 0.5f, 
    screenHeight - (standardHeight + padding), screenWidth * 0.5f,
      standardHeight);
  _landlordButton.layer.borderColor = [UIColor whiteColor].CGColor;
  _landlordButton.layer.borderWidth = 1.0f;
  _landlordButton.layer.cornerRadius = _landlordButton.frame.size.height * 0.5f;
  _landlordButton.titleLabel.font = [UIFont normalTextFont];
  [_landlordButton setTitle: @"Landlords Here" 
    forState: UIControlStateNormal];
  [_landlordButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [self addSubview: _landlordButton];

  return self;
}

@end
