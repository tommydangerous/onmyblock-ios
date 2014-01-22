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

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  doneEditingBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Done" 
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(doneEditing)];
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

- (void) doneEditing
{
  [self.view endEditing: YES];
  [self showMenuBarButtonItem];
}

- (void) setMenuBarButtonItem
{
  self.navigationItem.leftBarButtonItem = menuBarButtonItem;
}

- (void) showAlertViewWithError: (NSError *) error
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Error"
    message: error.localizedDescription delegate: nil
      cancelButtonTitle: @"Try again" otherButtonTitles: nil];
  [alertView show]; 
}

- (void) showContainer
{
  [[self appDelegate].container showMenuWithFactor: 1];
}

- (void) showDoneEditingBarButtonItem
{
  [self.navigationItem setRightBarButtonItem: doneEditingBarButtonItem 
    animated: YES];
}

- (void) showMenuBarButtonItem
{
  [self.navigationItem setRightBarButtonItem: menuBarButtonItem animated: YES];
}

@end
