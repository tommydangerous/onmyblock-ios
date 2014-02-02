//
//  OMBViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

#import "OMBViewControllerContainer.h"
#import "UIImage+Resize.h"
#import "UIColor+Extensions.h"

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
  self = [super init];
  if (self) {
    self.view.backgroundColor = [UIColor backgroundColor];
  }
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

  // Menu
  menuBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage: 
      [UIImage image:  [UIImage imageNamed: @"menu_icon_staggered.png"] 
        size: CGSizeMake(26, 26)] style: UIBarButtonItemStylePlain 
          target: self action: @selector(showContainer)];

  self.navigationItem.backBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"" 
      style: UIBarButtonItemStylePlain target: nil action: nil];
}

- (void) setTitle: (NSString *) string
{
  [super setTitle: string];
  UILabel *label = [[UILabel alloc] init];
  label.backgroundColor = [UIColor clearColor];
  label.font            = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 18];
  label.frame           = CGRectMake(0, 0, 0, 44);
  label.shadowColor     = [UIColor clearColor];
  label.shadowOffset    = CGSizeMake(0, 0);
  label.text            = string;
  label.textAlignment   = NSTextAlignmentCenter;
  label.textColor       = [UIColor textColor];
  [label sizeToFit];
  self.navigationItem.titleView = label;
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];

  [[self appDelegate].container stopSpinning];
}

#pragma mark - Methods

#pragma mark - Instance Methods

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

- (void) done
{
  // Subclasses implement this
}

- (void) save
{
  // Subclasses implement this
}

- (void) setMenuBarButtonItem
{
  self.navigationItem.leftBarButtonItem = menuBarButtonItem;
}

- (void) showAlertViewWithError: (NSError *) error
{
  NSString *message = @"Please try again.";
  NSString *title   = @"Unsuccessful";
  if (error) {
    message = error.localizedDescription;
    title   = @"Error";
    if (error.userInfo) {
      if ([error.userInfo objectForKey: @"message"] &&
        [[error.userInfo objectForKey: @"message"] length]) {
        
        message = [error.userInfo objectForKey: @"message"];
      }
      if ([error.userInfo objectForKey: @"title"] &&
        [[error.userInfo objectForKey: @"title"] length]) {

        title = [error.userInfo objectForKey: @"title"];
      }
    }
  }
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
    message: message delegate: nil cancelButtonTitle: @"Try again" 
      otherButtonTitles: nil];
  [alertView show];
}

- (void) showContainer
{
  [[self appDelegate].container showMenuWithFactor: 1];
}

@end
