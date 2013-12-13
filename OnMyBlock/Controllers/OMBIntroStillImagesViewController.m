//
//  OMBIntroStillImagesViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/12/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroStillImagesViewController.h"

#import "DDPageControl.h"
#import "OMBIntroStillImageSlide.h"
#import "OMBLoginViewController.h"
#import "UIColor+Extensions.h"

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

  OMBIntroStillImageSlide *slide1 = 
    [[OMBIntroStillImageSlide alloc] initWithBackgroundImage: 
      [UIImage imageNamed: @"intro_still_image_slide_1_background.jpg"]];
  slide1.frame = CGRectMake(screenWidth * 0.0f, 0.0f,
    slide1.frame.size.width, slide1.frame.size.height);
  slide1.imageView.image = [UIImage imageNamed: @"logo_white.png"];
  slide1.titleLabel.text = @"OnMyBlock";
  [slide1 setDetailLabelText: @"The auction marketplace\nfor student housing"];
  [_scroll addSubview: slide1];

  OMBIntroStillImageSlide *slide2 = 
    [[OMBIntroStillImageSlide alloc] initWithBackgroundImage: 
      [UIImage imageNamed: @"intro_still_image_slide_2_background.jpg"]];
  slide2.frame = CGRectMake(screenWidth * 1.0f, 0.0f,
    slide2.frame.size.width, slide2.frame.size.height);
  slide2.imageView.image = [UIImage imageNamed: @"search_icon.png"];
  slide2.titleLabel.text = @"Discover";
  [slide2 setDetailLabelText: @"Find the best college sublets,\n" 
    @"houses, and apartments."];
  [_scroll addSubview: slide2];

  OMBIntroStillImageSlide *slide3 = 
    [[OMBIntroStillImageSlide alloc] initWithBackgroundImage: 
      [UIImage imageNamed: @"intro_still_image_slide_3_background.jpg"]];
  slide3.frame = CGRectMake(screenWidth * 2.0f, 0.0f,
    slide3.frame.size.width, slide3.frame.size.height);
  slide3.imageView.image = [UIImage imageNamed: @"book_icon.png"];
  slide3.titleLabel.text = @"Book";
  [slide3 setDetailLabelText: @"Bid on your favorite rentals\n" 
    @"through a live auction."];
  [_scroll addSubview: slide3];

  OMBIntroStillImageSlide *slide4 = 
    [[OMBIntroStillImageSlide alloc] initWithBackgroundImage: 
      [UIImage imageNamed: @"intro_still_image_slide_4_background.jpg"]];
  slide4.frame = CGRectMake(screenWidth * 3.0f, 0.0f,
    slide4.frame.size.width, slide4.frame.size.height);
  slide4.imageView.image = [UIImage imageNamed: @"celebrate_icon.png"];
  slide4.titleLabel.text = @"Celebrate";
  [slide4 setDetailLabelText: @"You are ready to move\n" 
    @"into your new college pad"];
  [_scroll addSubview: slide4];

  // Page control
  _pageControl                   = [[DDPageControl alloc] init];
  _pageControl.indicatorDiameter = 10.0f;
  _pageControl.indicatorSpace    = 15.0f;
  _pageControl.numberOfPages     = numberOfPages - 1;
  _pageControl.offColor          = [UIColor whiteColor];
  _pageControl.onColor           = [UIColor whiteColor];
  _pageControl.type = DDPageControlTypeOnFullOffEmpty;
  _pageControl.frame = CGRectMake(0.0f, screenHeight - 60.0f, 
    screenWidth, 60.0f);
  [_pageControl addTarget: self action: @selector(scrollToCurrentPage:)
    forControlEvents: UIControlEventValueChanged];
  [_scroll addSubview: _pageControl];

  // Close view
  closeButtonView = [[UIView alloc] init];
  float closeButtonViewHeight = 25;
  float closeButtonViewWidth  = closeButtonViewHeight * 2;
  CGRect closeRect = [@"Skip" boundingRectWithSize:
    CGSizeMake(closeButtonViewWidth, closeButtonViewHeight)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: 
        [UIFont fontWithName: @"HelveticaNeue-Light" size: 15] } 
          context: nil];
  closeButtonViewHeight = closeRect.size.height + 10;
  closeButtonViewWidth  = closeRect.size.width + 20;
  closeButtonView.frame = CGRectMake(
    (screen.size.width - (closeButtonViewWidth + 10)), (20 + 10), 
      closeButtonViewWidth, closeButtonViewHeight);
  closeButtonView.layer.borderColor = [UIColor whiteColor].CGColor;
  closeButtonView.layer.borderWidth = 1.0f;
  closeButtonView.layer.cornerRadius = 5.0f;
  [_scroll addSubview: closeButtonView];
  UIButton *closeButton = [[UIButton alloc] init];
  closeButton.frame = CGRectMake(0, 0, closeButtonView.frame.size.width,
    closeButtonView.frame.size.height);
  closeButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  [closeButton addTarget: self action: @selector(close)
    forControlEvents: UIControlEventTouchUpInside];
  [closeButton setTitle: @"Skip" forState: UIControlStateNormal];
  [closeButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [closeButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateHighlighted];
  [closeButtonView addSubview: closeButton];

  // Activity indicator spinner
  _activityIndicatorView = 
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: 
      UIActivityIndicatorViewStyleWhiteLarge];
  _activityIndicatorView.color = [UIColor grayDark];
  CGRect activityFrame = _activityIndicatorView.frame;
  activityFrame.origin.x = (self.view.frame.size.width - 
    activityFrame.size.width) * 0.5;
  activityFrame.origin.y = (self.view.frame.size.height - 
    activityFrame.size.height) * 0.5;
  _activityIndicatorView.frame = activityFrame;
  [self.view addSubview: _activityIndicatorView];
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
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;
  
  float percent = 0.0;
  float width   = scrollView.frame.size.width;
  float x       = scrollView.contentOffset.x;
  float page    = x / width;

  // Scroll the close button view and the page control
  if (page <= 5) {
    _pageControl.frame = CGRectMake(x, 
      _pageControl.frame.origin.y, 
        _pageControl.frame.size.width, _pageControl.frame.size.height);

    closeButtonView.frame = CGRectMake(
      (screen.size.width - (closeButtonView.frame.size.width + 10)) + x, 
        closeButtonView.frame.origin.y, 
          closeButtonView.frame.size.width, closeButtonView.frame.size.height);
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) close
{
  [self dismissViewControllerAnimated: YES
    completion: nil];
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

- (void) setupForLoggedInUser
{

}

- (void) setupForLoggedOutUser
{

}

- (void) showLogin
{
  [_loginViewController showLogin];
  [self presentViewController: _loginViewController 
    animated: YES completion: nil];
}

@end
