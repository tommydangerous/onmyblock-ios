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
#import "OMBIntroStillImagesViewController.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

@implementation OMBGetStartedView

@synthesize getStartedButton = _getStartedButton;
@synthesize ombIcon = _ombIcon;
@synthesize landlordButton = _landlordButton;

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;

  CGFloat padding = 20.0f;

  self.frame = screen;
    
  // background
  UIImageView *backgroundView = [[UIImageView alloc] init];
  backgroundView.frame        = screen;
  UIImage *image = [UIImage imageNamed: @"intro_still_image_slide_5_background.png"];
  backgroundView.image = [UIImage image:image size:CGSizeMake(screen.size.width, screen.size.height)];
    
    [self addSubview: backgroundView];
    
  UILabel *label1 = [[UILabel alloc] init];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 16];
  // 33 + 40 = height of label1 plus the height of the page control
  label1.frame = CGRectMake(0, ((screenHeight - (33 + 40)) * 0.5) - padding,
    screenWidth, 65);
  label1.text = @"Find and rent the best college houses, apartments, and sublets.";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor whiteColor];
  label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.numberOfLines = 2;
  [self addSubview: label1];

  UILabel *onmyblock = [[UILabel alloc] init];
  onmyblock.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 36];
  onmyblock.frame = CGRectMake(label1.frame.origin.x, 
    (label1.frame.origin.y - (44)), screenWidth, 54);
  NSMutableAttributedString *onmyString = 
    [[NSMutableAttributedString alloc] initWithString: @"ONMYBLOCK" attributes: @{
      NSForegroundColorAttributeName: [UIColor whiteColor]
    }];
  
  onmyblock.attributedText = onmyString;
  onmyblock.textAlignment = NSTextAlignmentCenter;
  [self addSubview: onmyblock];

  float getStartedButtonWidth = screenWidth - (padding * 2);
  // Facebook button
  _facebookButton = [[UIButton alloc] init];
  _facebookButton.backgroundColor = [UIColor facebookBlue];
  _facebookButton.clipsToBounds = YES;
  _facebookButton.frame = CGRectMake(screenWidth, 
      label1.frame.origin.y + label1.frame.size.height + 10,
        getStartedButtonWidth, padding + 18 + padding);
  _facebookButton.layer.cornerRadius = 5.0f;
  _facebookButton.titleLabel.font = 
    [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  [_facebookButton addTarget: self action: @selector(showFacebookLogin)
    forControlEvents: UIControlEventTouchUpInside];
  [_facebookButton setTitle: @"Sign up using Facebook" 
    forState: UIControlStateNormal];
  [_facebookButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor facebookBlueDark]] 
      forState: UIControlStateHighlighted];
  [self addSubview: _facebookButton];
  CGFloat facebookImageSize = _facebookButton.frame.size.height - padding;
  _facebookButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
    facebookImageSize, 0.0f, 0.0f);
  UIImageView *facebookImageView = [[UIImageView alloc] init];
  facebookImageView.frame = CGRectMake(padding * 0.5, 
    (_facebookButton.frame.size.height - facebookImageSize) * 0.5, 
      facebookImageSize, facebookImageSize);
  facebookImageView.image = [UIImage image: 
    [UIImage imageNamed: @"facebook_icon.png"] 
      size: CGSizeMake(facebookImageSize, facebookImageSize)];
  [_facebookButton addSubview: facebookImageView];

  _getStartedButton = [[UIButton alloc] init];
  
  _getStartedButton.clipsToBounds = YES;
  _getStartedButton.frame = CGRectMake(_facebookButton.frame.origin.x, 
    (_facebookButton.frame.origin.y + 
    _facebookButton.frame.size.height + padding), 
      _facebookButton.frame.size.width, _facebookButton.frame.size.height);
  _getStartedButton.layer.borderColor = [UIColor whiteColor].CGColor;
  _getStartedButton.layer.borderWidth = 1.0f;
  _getStartedButton.layer.cornerRadius = _facebookButton.layer.cornerRadius;
  _getStartedButton.titleLabel.font = _facebookButton.titleLabel.font;
  // [_getStartedButton setBackgroundImage: 
  //   [UIImage imageWithColor: [UIColor grayMedium]] 
  //     forState: UIControlStateNormal];
  // [_getStartedButton setBackgroundImage: 
  //   [UIImage imageWithColor: [UIColor colorWithWhite: 140/255.0 alpha: 0.8]] 
  //     forState: UIControlStateHighlighted];
  [_getStartedButton addTarget: self action: @selector(getStartedButtonTapped)
    forControlEvents: UIControlEventTouchUpInside];
  [_getStartedButton setTitle: @"Sign up with email" 
    forState: UIControlStateNormal];
    [_getStartedButton setTitleColor: [UIColor darkGrayColor]
    forState: UIControlStateNormal];
  [self addSubview: _getStartedButton];
  CGFloat emailImageSize = 
    _getStartedButton.frame.size.height - (padding * 1.5);
  _getStartedButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
    emailImageSize, 0.0f, 0.0f);
    _getStartedButton.backgroundColor = [UIColor colorWithRed:238 green:238 blue:238 alpha:1.0];
  UIImageView *emailImageView = [[UIImageView alloc] init];
  emailImageView.frame = CGRectMake(padding, 
    (_getStartedButton.frame.size.height - emailImageSize) * 0.5, 
      emailImageSize, emailImageSize);
  emailImageView.image = [UIImage image: 
    [UIImage imageNamed: @"messages_icon_dark.png"] 
      size: CGSizeMake(emailImageSize, emailImageSize)];
  [_getStartedButton addSubview: emailImageView];

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
  // [self addSubview: login];
    
  //OMB Icon Image View
  _ombIcon = [[UIImageView alloc] init];
  _ombIcon.frame = CGRectMake(label1.frame.origin.x,
                                           (label1.frame.origin.y - (170)), screenWidth, 131);
    _ombIcon.contentMode = UIViewContentModeCenter;
    _ombIcon.image = [UIImage imageNamed:@"LogoIntro.png"];
  [self addSubview:_ombIcon];
    
    
  //Landlord Button
    _landlordButton = [[UIButton alloc] init];
    _landlordButton.frame = CGRectMake((self.frame.size.width-180)/2,
                                       (self.frame.size.height - (50)), 180, 40);
    _landlordButton.backgroundColor = [UIColor clearColor];
    _landlordButton.titleLabel.font =
    [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
    _landlordButton.clipsToBounds = YES;
    _landlordButton.layer.cornerRadius = 15.0f;
    _landlordButton.layer.masksToBounds = YES;
    _landlordButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _landlordButton.layer.borderWidth = 1.0f;
    [_landlordButton setTitle:@"Landlord Sign-up" forState:UIControlStateNormal];
 
    [self addSubview:_landlordButton];

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

- (void) showFacebookLogin
{
  [[NSNotificationCenter defaultCenter] postNotificationName:
    OMBActivityIndicatorViewStartAnimatingNotification object: nil];
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate openSession];
}

- (void) showLogin
{
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.container.introViewController showLogin];
}

@end
