//
//  OMBIntroStillImagesViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/12/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroStillImagesViewController.h"

#import "DRNRealTimeBlurView.h"
#import "DDPageControl.h"
#import "OMBActivityView.h"
#import "OMBCloseButtonView.h"
#import "OMBGetStartedView.h"
#import "OMBIntroStillImageSlide.h"
#import "OMBLoginViewController.h"
#import "OMBSignUpView.h"
#import "OMBViewControllerContainer.h"
#import "ILTranslucentView.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+NegativeImage.h"

@implementation OMBIntroStillImagesViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Intro Still Images";
  
  // It needs it's own login view controller
  // because it cannot present the container's login view controller
  _loginViewController = [[OMBLoginViewController alloc] init];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.view = [[UIView alloc] initWithFrame: screen];

  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;

  NSArray *imageNames = @[
    @"intro_still_image_slide_1_background.jpg",
    @"intro_still_image_slide_2_background.jpg",
    @"intro_still_image_slide_3_background.jpg",
    @"intro_still_image_slide_4_background.jpg"
  ];
  backgroundViewArray = [NSMutableArray array];
  for (NSString *string in imageNames) {
    // Background view
    UIView *backgroundView = [[UIView alloc] initWithFrame: screen];
    [self.view insertSubview: backgroundView atIndex: 0];
    [backgroundViewArray addObject: backgroundView];
    // Background image
    UIImageView *backgroundImageView  = [[UIImageView alloc] init];
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.contentMode   = UIViewContentModeScaleAspectFill;
    backgroundImageView.frame         = backgroundView.frame;
    backgroundImageView.image         = [UIImage imageNamed: string];
    [backgroundView addSubview: backgroundImageView];
    // Black tint
    UIView *colorView         = [[UIView alloc] init];
    colorView.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
    colorView.frame           = backgroundView.frame;
    [backgroundView addSubview: colorView];
    // Blur
    DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] init];
    blurView.blurRadius           = 0.2f;
    blurView.frame                = backgroundView.frame;
    blurView.renderStatic         = YES;
    [backgroundView addSubview: blurView];
  }

  // The auction marketplace for student housing
  // Discover
  // Auction
  // Celebrate
  // Get Started
  // Sign up
  int numberOfPages = 6;

  // Scroll
  _scroll               = [[UIScrollView alloc] init];
  _scroll.bounces       = YES;
  _scroll.contentSize   = CGSizeMake(screenWidth * numberOfPages, screenHeight);
  _scroll.delegate      = self;
  _scroll.frame         = screen;
  _scroll.pagingEnabled = YES;
  _scroll.showsHorizontalScrollIndicator = NO;
  [self.view addSubview: _scroll];

  // Blur
  // ILTranslucentView *translucentView = [[ILTranslucentView alloc] init];
  // translucentView.backgroundColor = [UIColor clearColor];
  // translucentView.frame = screen;
  // translucentView.translucentAlpha = 0.9;
  // translucentView.translucentStyle = UIBarStyleDefault;
  // translucentView.translucentTintColor = [UIColor clearColor];
  // [self.view addSubview: translucentView];

  OMBIntroStillImageSlide *slide1 = 
    [[OMBIntroStillImageSlide alloc] initWithBackgroundImage: 
      [UIImage imageNamed: @"intro_still_image_slide_1_background.jpg"]];
  slide1.frame = CGRectMake(screenWidth * 0.0f, 0.0f,
    slide1.frame.size.width, slide1.frame.size.height);
  slide1.imageView.image = [UIImage imageNamed: @"logo_white.png"];
  slide1.titleLabel.text = @"OnMyBlock";
  // [slide1 setDetailLabelText: 
  //   @"The auction marketplace\nfor student housing."];
  [slide1 setDetailLabelText: 
    @"The marketplace\nfor student housing."];
  [_scroll addSubview: slide1];

  OMBIntroStillImageSlide *slide2 = 
    [[OMBIntroStillImageSlide alloc] initWithBackgroundImage: 
      [UIImage imageNamed: @"intro_still_image_slide_2_background.jpg"]];
  slide2.frame = CGRectMake(screenWidth * 1.0f, 0.0f,
    slide2.frame.size.width, slide2.frame.size.height);
  // slide2.imageView.image = [UIImage imageNamed: @"search_icon.png"];
  slide2.imageView.image = 
    [[UIImage imageNamed: @"map_marker_icon.png"] negativeImage];
  slide2.titleLabel.text = @"Discover";
  [slide2 setDetailLabelText: @"Find the best college sublets,\n" 
    @"houses, and apartments."];
  [_scroll addSubview: slide2];

  OMBIntroStillImageSlide *slide3 = 
    [[OMBIntroStillImageSlide alloc] initWithBackgroundImage: 
      [UIImage imageNamed: @"intro_still_image_slide_3_background.jpg"]];
  slide3.frame = CGRectMake(screenWidth * 2.0f, 0.0f,
    slide3.frame.size.width, slide3.frame.size.height);
  // slide3.imageView.image = [UIImage imageNamed: @"book_icon.png"];
  slide3.imageView.image = 
    [[UIImage imageNamed: @"credit_card_icon.png"] negativeImage];
  // slide3.secondDetailLabel.text = @"When your offer is accepted...";
  slide3.titleLabel.text = @"Book";
  // [slide3 setDetailLabelText: @"Bid on your favorite rentals\n" 
  //   @"through a live auction."];
  [slide3 setDetailLabelText: @"Make offers on your\n" 
    @"favorite places."];
  [_scroll addSubview: slide3];

  OMBIntroStillImageSlide *slide4 = 
    [[OMBIntroStillImageSlide alloc] initWithBackgroundImage: 
      [UIImage imageNamed: @"intro_still_image_slide_4_background.jpg"]];
  slide4.frame = CGRectMake(screenWidth * 3.0f, 0.0f,
    slide4.frame.size.width, slide4.frame.size.height);
  // slide4.imageView.image = [UIImage imageNamed: @"celebrate_icon.png"];
  slide4.imageView.image = 
    [[UIImage imageNamed: @"champagne_icon.png"] negativeImage];
  slide4.titleLabel.text = @"Celebrate";
  // [slide4 setDetailLabelText: @"You are ready to move\n" 
  //   @"into your new college pad."];
  [slide4 setDetailLabelText: @"Once you are accepted,\n" 
    @"you'll be ready to move in."];
  [_scroll addSubview: slide4];

  slides = @[
    slide1, slide2, slide3, slide4
  ];

  _getStartedView = [[OMBGetStartedView alloc] init];
  _getStartedView.frame = CGRectMake(screenWidth * 4.0f, 0.0f, 
    screenWidth, screenHeight);
  [_scroll addSubview: _getStartedView];

  // 6. Sign up
  _signUpView = [[OMBSignUpView alloc] init];
  _signUpView.frame = CGRectMake(screenWidth * 5.0f, 0.0f,
    screenWidth, screenHeight);
  [_scroll addSubview: _signUpView];

  CGFloat bottomViewHeight = 58.0f;
  // Bottom view
  bottomView = [UIView new];
  bottomView.frame = CGRectMake(0.0f, screenHeight - bottomViewHeight,
    screenWidth, bottomViewHeight);
  [self.view addSubview: bottomView];
  UIView *bottomViewBorder = [UIView new];
  bottomViewBorder.frame = CGRectMake(0.0f, 0.0f, 
    bottomView.frame.size.width, 1.0f);
  bottomViewBorder.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.5f];
  [bottomView addSubview: bottomViewBorder];

  signUpButton = [UIButton new];
  signUpButton.frame = CGRectMake(0.0f, 0.0f, 
    bottomView.frame.size.width * 0.5f, bottomView.frame.size.height);
  signUpButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
    size: 17];
  [signUpButton addTarget: self action: @selector(scrollToSignUp)
    forControlEvents: UIControlEventTouchUpInside];
  [signUpButton setTitle: @"Sign up" forState: UIControlStateNormal];
  [bottomView addSubview: signUpButton];

  loginButton = [UIButton new];
  loginButton.frame = CGRectMake(
    signUpButton.frame.origin.x + signUpButton.frame.size.width, 
      signUpButton.frame.origin.y, signUpButton.frame.size.width,
        signUpButton.frame.size.height);
  loginButton.titleLabel.font = signUpButton.titleLabel.font;
  [loginButton addTarget: self action: @selector(showLogin)
    forControlEvents: UIControlEventTouchUpInside];
  [loginButton setTitle: @"Login" forState: UIControlStateNormal];
  [bottomView addSubview: loginButton];

  // Page control
  _pageControl                   = [[DDPageControl alloc] init];
  _pageControl.indicatorDiameter = 10.0f;
  _pageControl.indicatorSpace    = 15.0f;
  _pageControl.numberOfPages     = numberOfPages - 1;
  _pageControl.offColor          = [UIColor whiteColor];
  _pageControl.onColor           = [UIColor whiteColor];
  _pageControl.type = DDPageControlTypeOnFullOffEmpty;
  _pageControl.frame = CGRectMake(0.0f, 
    screenHeight - (60.0f + bottomView.frame.size.height), screenWidth, 60.0f);
  [_pageControl addTarget: self action: @selector(scrollToCurrentPage:)
    forControlEvents: UIControlEventValueChanged];
  [self.view addSubview: _pageControl];

  // Close view
  skipButtonView = [[UIView alloc] init];
  float skipButtonViewHeight = 25;
  float skipButtonViewWidth  = skipButtonViewHeight * 2;
  CGRect closeRect = [@"Skip" boundingRectWithSize:
    CGSizeMake(skipButtonViewWidth, skipButtonViewHeight)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: 
        [UIFont fontWithName: @"HelveticaNeue-Light" size: 15] } 
          context: nil];
  skipButtonViewHeight = closeRect.size.height + 10;
  skipButtonViewWidth  = closeRect.size.width + 20 + 10;
  skipButtonView.frame = CGRectMake(
    (screen.size.width - (skipButtonViewWidth + 10)), (20 + 10), 
      skipButtonViewWidth, skipButtonViewHeight);
  skipButtonView.layer.borderColor = [UIColor whiteColor].CGColor;
  skipButtonView.layer.borderWidth = 1.0f;
  skipButtonView.layer.cornerRadius = skipButtonView.frame.size.height * 0.5;
  [self.view addSubview: skipButtonView];
  UIButton *closeButton = [[UIButton alloc] init];
  closeButton.frame = CGRectMake(0, 0, skipButtonView.frame.size.width,
    skipButtonView.frame.size.height);
  closeButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  [closeButton addTarget: self action: @selector(close)
    forControlEvents: UIControlEventTouchUpInside];
  [closeButton setTitle: @"Skip" forState: UIControlStateNormal];
  [closeButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [closeButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateHighlighted];
  [skipButtonView addSubview: closeButton];

  // Close button view
  CGFloat padding = 20.0f;
  CGFloat closeButtonViewHeight = 23.0f;
  CGRect closeButtonRect = CGRectMake(
    (screen.size.width - (closeButtonViewHeight + padding)), (20.0f + padding),
      closeButtonViewHeight, closeButtonViewHeight);
  UIButton *closeButtonStarted = [[UIButton alloc] initWithFrame:closeButtonRect];
  [closeButtonStarted setBackgroundImage:[UIImage imageNamed:@"close_white.png"] forState:UIControlStateNormal];
  [closeButtonStarted addTarget: self action: @selector(close)
               forControlEvents:UIControlEventTouchUpInside];
  [_getStartedView addSubview: closeButtonStarted];
  
  // Activity indicator spinner
  _activityView = [[OMBActivityView alloc] init];
  [self.view addSubview: _activityView];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // [[self appDelegate].container stopSpinning];
  [_activityView stopSpinning];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
  // Change the pages on the page control
  float currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
  _pageControl.currentPage = currentPage;
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  // Resign first responder for all text fields for sign up view
  // [_signUpView endEditing: YES];

  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;
  
  float percent = 0.0;
  float width   = scrollView.frame.size.width;
  float x       = scrollView.contentOffset.x;
  float page    = x / width;

  // Fade the background image views in and out
  for (UIView *bView in backgroundViewArray) {
    percent = (x - (width * [backgroundViewArray indexOfObject: bView])) / 
      width;
    bView.alpha = 1 - percent;
  }
  // Scale the slide views
  for (UIView *slide in slides) {
    percent = (x - (width * [slides indexOfObject: slide])) / width;
    if (percent < 0)
      percent *= -1;
    CGFloat scalePercent = 1 - percent;
    if (scalePercent > 1)
      scalePercent = 1;
    else if (scalePercent < 0.8f)
      scalePercent = 0.8f;
    slide.transform = CGAffineTransformMakeScale(scalePercent, scalePercent);
  }

  // Scroll the close button view and the page control
  if (page <= 4) {
    // _pageControl.frame = CGRectMake(x, 
    //   _pageControl.frame.origin.y, 
    //     _pageControl.frame.size.width, _pageControl.frame.size.height);

    // skipButtonView.frame = CGRectMake(
    //   (screen.size.width - (skipButtonView.frame.size.width + 10)) + x, 
    //     skipButtonView.frame.origin.y, 
    //       skipButtonView.frame.size.width, skipButtonView.frame.size.height);
  }
  // Fade the page control and bottom view and skip button
  if (page < 99) {
    percent = (x - (width * 3)) / width;
    skipButtonView.alpha = bottomView.alpha = 
      _pageControl.alpha = 1 - percent;
  }
  // Get started view
  if (page >= 3 && page <= 4) {
    percent = (x - (width * 3)) / width;

    float stopOriginX = 
      (screenWidth - _getStartedView.getStartedButton.frame.size.width) * 0.5;
    float facebookPercent = percent * 1.3;
    if (facebookPercent >= 1)
      facebookPercent = 1;
    float facebookOriginX =
      screenWidth - ((screenWidth - stopOriginX) * facebookPercent);
    _getStartedView.facebookButton.frame = CGRectMake(
      facebookOriginX,
        _getStartedView.facebookButton.frame.origin.y,
          _getStartedView.facebookButton.frame.size.width,
            _getStartedView.facebookButton.frame.size.height);
    float getStartedOriginX = 
      screenWidth - ((screenWidth - stopOriginX) * percent);
    _getStartedView.getStartedButton.frame = CGRectMake(
      getStartedOriginX,
        _getStartedView.getStartedButton.frame.origin.y,
          _getStartedView.getStartedButton.frame.size.width,
            _getStartedView.getStartedButton.frame.size.height);
  }
  // Sign up view
  if (page >= 4) {
    percent = (x - (width * 4)) / width;

    float stopOriginX = 
      (screenWidth - _getStartedView.getStartedButton.frame.size.width) * 0.5;
    float facebookPercent = percent * 1.3;
    float facebookOriginX =
      stopOriginX - ((screenWidth - stopOriginX) * facebookPercent);
    _getStartedView.facebookButton.frame = CGRectMake(
      facebookOriginX,
        _getStartedView.facebookButton.frame.origin.y,
          _getStartedView.facebookButton.frame.size.width,
            _getStartedView.facebookButton.frame.size.height);
    float getStartedOriginX = 
      stopOriginX - ((screenWidth - stopOriginX) * percent);
    _getStartedView.getStartedButton.frame = CGRectMake(
      getStartedOriginX,
        _getStartedView.getStartedButton.frame.origin.y,
          _getStartedView.getStartedButton.frame.size.width,
            _getStartedView.getStartedButton.frame.size.height);

    // Sign up view
    int padding = 20;
    float signUpViewPercent;
    // Facebook button
    if (percent <= 9) {
      signUpViewPercent = percent * (1 + 0.5);
      if (signUpViewPercent > 1)
        signUpViewPercent = 1;
      CGRect rect = _signUpView.facebookButton.frame;
      _signUpView.facebookButton.frame = CGRectMake(
        ((padding + screenWidth) - (screenWidth * signUpViewPercent)),
          rect.origin.y, rect.size.width,
            rect.size.height);
    }
    // First name text field
    if (percent <= 9) {
      signUpViewPercent = percent * (1 + 0.4);
      if (signUpViewPercent > 1)
        signUpViewPercent = 1;
      CGRect rect = _signUpView.firstNameTextField.frame;
      _signUpView.firstNameTextField.frame = CGRectMake(
        ((padding + screenWidth) - (screenWidth * signUpViewPercent)),
          rect.origin.y, rect.size.width,
            rect.size.height);
    }
    // Last name text field
    if (percent <= 9) {
      signUpViewPercent = percent * (1 + 0.3);
      if (signUpViewPercent > 1)
        signUpViewPercent = 1;
      CGRect rect = _signUpView.lastNameTextField.frame;
      _signUpView.lastNameTextField.frame = CGRectMake(
        ((padding + screenWidth) - (screenWidth * signUpViewPercent)),
          rect.origin.y, rect.size.width,
            rect.size.height);
    }
    // Email name text field
    if (percent <= 9) {
      signUpViewPercent = percent * (1 + 0.2);
      if (signUpViewPercent > 1)
        signUpViewPercent = 1;
      CGRect rect = _signUpView.emailTextField.frame;
      _signUpView.emailTextField.frame = CGRectMake(
        ((padding + screenWidth) - (screenWidth * signUpViewPercent)),
          rect.origin.y, rect.size.width,
            rect.size.height);
    }
    // Password name text field
    if (percent <= 9) {
      signUpViewPercent = percent * (1 + 0.1);
      if (signUpViewPercent > 1)
        signUpViewPercent = 1;
      CGRect rect = _signUpView.passwordTextField.frame;
      _signUpView.passwordTextField.frame = CGRectMake(
        ((padding + screenWidth) - (screenWidth * signUpViewPercent)),
          rect.origin.y, rect.size.width,
            rect.size.height);
    }
    // Login button
    if (percent <= 9) {
      signUpViewPercent = percent * (1 + 0.0);
      if (signUpViewPercent > 1)
        signUpViewPercent = 1;
      CGRect rect = _signUpView.loginButton.frame;
      _signUpView.loginButton.frame = CGRectMake(
        ((padding + screenWidth) - (screenWidth * signUpViewPercent)),
          rect.origin.y, rect.size.width,
            rect.size.height);
    }
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) close
{
  [self dismissViewControllerAnimated: YES
    completion: nil];
}

- (void) resetViews
{
  for (UIView *v in backgroundViewArray) {
    v.alpha = 1.0f;
  }
  _pageControl.currentPage = 0;
  [_scroll setContentOffset: CGPointZero animated: NO];
}

- (void) scrollToCurrentPage: (UIPageControl *) control
{
  [self scrollToPage: control.currentPage];
}

- (void) scrollToPage: (int) page
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  [_scroll setContentOffset: 
    CGPointMake((page * screen.size.width), 0) animated: YES];
}

- (void) scrollToSignUp
{
  [self scrollToPage: 5];
}

- (void) setupForLoggedInUser
{
  // Hide the bottom view
  bottomView.hidden = YES;
  _getStartedView.hidden     = YES;
  _signUpView.hidden         = YES;
  _pageControl.numberOfPages = 4;
  // 60.0f = height of page control
  _pageControl.frame = CGRectMake(0.0f, 
    _scroll.frame.size.height - (60.0f + bottomView.frame.size.height), 
      _scroll.frame.size.width, 60.0f);
  _scroll.contentSize = CGSizeMake(
    (_scroll.frame.size.width * _pageControl.numberOfPages), 
      _scroll.frame.size.height);
}

- (void) setupForLoggedOutUser
{
  // Hide the bottom view
  bottomView.hidden = NO;
  _getStartedView.hidden     = NO;
  _signUpView.hidden         = NO;
  _pageControl.numberOfPages = 5;
  // 60.0f = height of page control
  _pageControl.frame = CGRectMake(0.0f, 
    _scroll.frame.size.height - (60.0f + bottomView.frame.size.height), 
      _scroll.frame.size.width, 60.0f);
  // Number of pages + 1 for the sign up view at the end of the intro
  _scroll.contentSize = CGSizeMake(
    (_scroll.frame.size.width * (_pageControl.numberOfPages + 1)), 
      _scroll.frame.size.height);
}

- (void) showLogin
{
  [_loginViewController showLogin];
  [self presentViewController: _loginViewController 
    animated: YES completion: nil];
}

@end
