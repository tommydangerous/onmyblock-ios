//
//  OMBAccountViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBAccountViewController.h"

#import "OMBAccountProfileViewController.h"
#import "OMBPrivacyPolicyViewController.h"
#import "OMBRenterApplicationViewController.h"
#import "OMBTermsOfServiceViewController.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBAccountViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Account";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setMenuBarButtonItem];

  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;

  self.table.backgroundColor = [UIColor grayUltraLight];
  self.table.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, screenWidth, 44.0f)];
  self.table.tableFooterView.backgroundColor = [UIColor clearColor];
  // Bottom border
  CALayer *borderTop = [CALayer layer];
  borderTop.backgroundColor = [UIColor grayLight].CGColor;
  borderTop.frame = CGRectMake(0.0f, 0.0f, screenWidth, 0.5f);
  [self.table.tableFooterView.layer addSublayer: borderTop];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Profile, renter application, payment info, transactions
  // How it works, terms of service, privacy statement
  // Logout
  return 3;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;
  float borderHeight = 0.5;

  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  }
  if (indexPath.row == 0) {
    // Bottom border
    CALayer *borderBottom = [CALayer layer];
    borderBottom.backgroundColor = [UIColor grayLight].CGColor;
    borderBottom.frame = CGRectMake(0.0f, 
      ([self tableView: self.table 
      heightForRowAtIndexPath: indexPath] - borderHeight), 
        screenWidth, borderHeight);
    [cell.contentView.layer addSublayer: borderBottom];
    if (indexPath.section != 0) {
      // Top border
      CALayer *borderTop = [CALayer layer];
      borderTop.backgroundColor = borderBottom.backgroundColor;
      borderTop.frame = CGRectMake(0.0f, 0.0f, 
        borderBottom.frame.size.width, borderBottom.frame.size.height);
      [cell.contentView.layer addSublayer: borderTop];
    }
    cell.contentView.backgroundColor = self.table.backgroundColor;
    cell.selectedBackgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"";
  }
  else {
    // If not the last row
    if (indexPath.row != [self tableView: self.table 
      numberOfRowsInSection: indexPath.section] - 1) {
      // Bottom border
      CALayer *borderBottom = [CALayer layer];
      borderBottom.backgroundColor = [UIColor grayLight].CGColor;
      borderBottom.frame = CGRectMake(15.0f, 
        ([self tableView: self.table 
        heightForRowAtIndexPath: indexPath] - borderHeight), 
          (screenWidth - 15.0f), borderHeight);
      [cell.contentView.layer addSublayer: borderBottom];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
      [UIImage imageWithColor: [UIColor grayLight]]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
      size: 15];
    cell.textLabel.textColor = [UIColor textColor];
    if (indexPath.section == 0) {
      if (indexPath.row == 1) {
        cell.textLabel.text = @"Profile";
      }
      else if (indexPath.row == 2) {
        cell.textLabel.text = @"Renter Application";
      }
      else if (indexPath.row == 3) {
        cell.textLabel.text = @"Payment Info";
      }
      else if (indexPath.row == 4) {
        cell.textLabel.text = @"Transactions";
      }
    }
    else if (indexPath.section == 1) {
      if (indexPath.row == 1) {
        cell.textLabel.text = @"How it Works";
      }
      else if (indexPath.row == 2) {
        cell.textLabel.text = @"Terms of Service";
      }
      else if (indexPath.row == 3) {
        cell.textLabel.text = @"Privacy Policy";
      }
    }
    else if (indexPath.section == 2) {
      if (indexPath.row == 1) {
        cell.textLabel.text = @"Logout";
      }
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // The 1 is for the spacing
  if (section == 0) {
    return 1 + 4;
  }
  else if (section == 1) {
    return 1 + 3;
  }
  else {
    return 1 + 1;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  if (indexPath.section == 0) {
    // Profile
    if (indexPath.row == 1) {
      [self.navigationController pushViewController: 
        [[OMBAccountProfileViewController alloc] init] animated: YES];
    }
    // Renter Application
    else if (indexPath.row == 2) {
      [self.navigationController pushViewController:
        [[OMBRenterApplicationViewController alloc] init] animated: YES];
    }
  }
  else if (indexPath.section == 1) {
    // How it Works
    if (indexPath.row == 1) {
      [appDelegate.container showIntroAnimatedVertical: YES];
    }
    // Terms of Service
    else if (indexPath.row == 2) {
      [self.navigationController pushViewController: 
        [[OMBTermsOfServiceViewController alloc] init] animated: YES];
    }
    // Privacy Policy
    else if (indexPath.row == 3) {
      [self.navigationController pushViewController:
        [[OMBPrivacyPolicyViewController alloc] init] animated: YES];
    }
  }
  else if (indexPath.section == 2) {
    // Logout
    if (indexPath.row == 1) {
      [appDelegate.container showLogout];
    }
  }
  [self.table deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 44.0f;
}

@end
