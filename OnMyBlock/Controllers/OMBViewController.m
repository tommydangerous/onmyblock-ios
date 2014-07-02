//
//  OMBViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

// Categories
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"
#import "UIColor+Extensions.h"

#import "OMBViewControllerContainer.h"

CGFloat const OMBCornerRadius         = 5.0f;
CGFloat const OMBKeyboardHeight       = 216.0f;
CGFloat const OMBPadding              = 20.0f;
CGFloat const OMBStandardButtonHeight = 58.0f;
CGFloat const OMBStandardDuration     = 0.25f;
CGFloat const OMBStandardHeight       = 44.0f;

@implementation OMBViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = NSStringFromClass([self class]);
  self.view.backgroundColor = [UIColor backgroundColor];

  return self;
}

#pragma mark - Override

#pragma mark - NSObject

- (void) dealloc
{
  // Must dealloc or notifications get sent to zombies
  [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  // Back
  backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Back"
    style: UIBarButtonItemStylePlain target: self action: @selector(back)];
  // Cancel
  cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
    style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];
  // Done
  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
    style: UIBarButtonItemStylePlain target: self action: @selector(done)];
  [doneBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  // Save
  saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Save"
    style: UIBarButtonItemStylePlain target: self action: @selector(save)];
  [saveBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  // Share
  shareBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
    UIBarButtonSystemItemAction target: self
      action: @selector(shareButtonSelected)];

  // Menu
  menuBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:
      [UIImage image:  [UIImage imageNamed: @"menu_icon_staggered.png"]
        size: CGSizeMake(26.0f, 26.0f)] style: UIBarButtonItemStylePlain
          target: self action: @selector(showContainer)];

  self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @""
      style: UIBarButtonItemStylePlain target: nil action: nil];
}

- (void) setTitle: (NSString *) string
{
  [super setTitle: string];
  navigationTitleLabel = [[UILabel alloc] init];
  navigationTitleLabel.backgroundColor = [UIColor clearColor];
  navigationTitleLabel.font            = [UIFont mediumTextFont];
  navigationTitleLabel.frame           = CGRectMake(0, 0, 0, 44);
  navigationTitleLabel.shadowColor     = [UIColor clearColor];
  navigationTitleLabel.shadowOffset    = CGSizeMake(0, 0);
  navigationTitleLabel.text            = string;
  navigationTitleLabel.textAlignment   = NSTextAlignmentCenter;
  navigationTitleLabel.textColor       = [UIColor textColor];
  [navigationTitleLabel sizeToFit];
  self.navigationItem.titleView = navigationTitleLabel;
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];

  [[self appDelegate].container stopSpinning];
}

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Private

- (void) animateStatusBarDefault
{
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    [[UIApplication sharedApplication] setStatusBarStyle:
      UIStatusBarStyleDefault];
  }];
}

- (void) animateStatusBarLight
{
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    [[UIApplication sharedApplication] setStatusBarStyle:
      UIStatusBarStyleLightContent];
  }];
}

- (void) setNavigationControllerNavigationBarDefault
{
  self.navigationController.navigationBar.tintColor = [UIColor blue];
  [self.navigationController.navigationBar setBackgroundImage: nil
    forBarMetrics: UIBarMetricsDefault];
}

- (void) setNavigationControllerNavigationBarTransparent
{
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  [self.navigationController.navigationBar setBackgroundImage: [UIImage new] 
    forBarMetrics: UIBarMetricsDefault];
}

- (OMBAppDelegate *) appDelegate
{
  return (OMBAppDelegate *) [UIApplication sharedApplication].delegate;
}

- (void) back
{
  // Subclasses implement this
}

- (void) cancel
{
  // Subclasses implement this
}

- (void) containerStartSpinning
{
  [[self appDelegate].container startSpinning];
}

- (void) containerStartSpinningFullScreen
{
  [[self appDelegate].container startSpinningFullScreen];
}

- (void) containerStopSpinning
{
  [[self appDelegate].container stopSpinning];
}

- (void) containerStopSpinningFullScreen
{
  [[self appDelegate].container stopSpinningFullScreen];
}

- (void) done
{
  // Subclasses implement this
}

- (void) mixpanelTrack: (NSString *) eventName 
properties: (NSDictionary *) dictionary
{
  [[Mixpanel sharedInstance] track: eventName properties: dictionary];
}

- (void) save
{
  // Subclasses implement this
}

- (CGRect) screen
{
  return [[UIScreen mainScreen] bounds];
}

- (void) setMenuBarButtonItem
{
  self.navigationItem.leftBarButtonItem = menuBarButtonItem;
}

- (void) shareButtonSelected
{
  // Subclasses implement this
}

- (void) showAlertViewWithError: (NSError *) error
{
  NSString *message = error.localizedFailureReason != (id) [NSNull null] ?
    error.localizedFailureReason : @"Please try again.";
  NSString *title =  error.localizedDescription != (id) [NSNull null] ?
    error.localizedDescription : @"Unsuccessful";

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
    message: message delegate: nil cancelButtonTitle: @"Okay"
      otherButtonTitles: nil];
  [alertView show];
}

- (void) showContainer
{
  [[self appDelegate].container showMenuWithFactor: 1];
}

- (NSUserDefaults *) userDefaults
{
  return [NSUserDefaults standardUserDefaults];
}

@end
