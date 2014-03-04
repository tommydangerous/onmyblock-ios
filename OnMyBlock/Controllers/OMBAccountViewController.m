//
//  OMBAccountViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBAccountViewController.h"

#import "OMBMyRenterProfileViewController.h"
#import "OMBPayoutMethodsViewController.h"
#import "OMBPrivacyPolicyViewController.h"
#import "OMBRateFeedbackViewController.h"
#import "OMBRenterApplicationViewController.h"
#import "OMBRenterProfileViewController.h"
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
    
  self.table.backgroundColor = [UIColor grayUltraLight];
  self.table.separatorColor  = [UIColor grayLight];
  self.table.separatorInset  = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  self.table.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
  self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
}

- (void) viewWillAppear:(BOOL)animated
{
  [self.table reloadData];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Profile, renter application, payment info, transactions
  // How it works, terms of service, privacy statement, rate us
  // Logout
  return 4;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  float borderHeight = 0.5f;

  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: 
    UITableViewCellStyleValue1 reuseIdentifier: CellIdentifier];
  // If first row, it is the blank row used for spacing
  if (indexPath.row == 0) {
    cell.contentView.backgroundColor = self.table.backgroundColor;
    cell.selectedBackgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"";
    cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
  }
  // Cells with text
  else {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
      [UIImage imageWithColor: [UIColor grayLight]]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
      size: 15];
    cell.textLabel.textColor = [UIColor textColor];
    if (indexPath.section == 0) {
      if (indexPath.row == 1) {
        if([[OMBUser currentUser] isLandlord])
          cell.textLabel.text = @"My Profile";
        else{
          cell.detailTextLabel.font = cell.textLabel.font;
          NSInteger percentage = [[OMBUser currentUser] profilePercentage];
          cell.detailTextLabel.text = [NSString stringWithFormat:
                                       @"%i%% complete", percentage];
          UIColor *color = [UIColor red];
          if (percentage >= 90)
            color = [UIColor green];
          else if (percentage >= 50)
            color = [UIColor yellow];
          cell.detailTextLabel.textColor = color;
          cell.textLabel.text = @"My Renter Profile";
        }
      }
      else if (indexPath.row == 2) {
        cell.textLabel.text = @"My Renter Application";
      }
      else if (indexPath.row == 3) {
        cell.textLabel.text = @"Payout Methods";
      }
    }
    else if (indexPath.section == 1) {
      if (indexPath.row == 1) {
        cell.textLabel.text = @"How it Works";
      }
      else if (indexPath.row == 2) {
        cell.textLabel.text = @"Rate Us";
      }
      else if (indexPath.row == 3) {
        cell.textLabel.text = @"Terms of Service";
      }
      else if (indexPath.row == 4) {
        cell.textLabel.text = @"Privacy Policy";
      }
    }
    else if (indexPath.section == 2) {
      if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"Logout";
      }
    }
  }
  // If it is the first or last row in the section
  if (indexPath.row == 0 || indexPath.row == 
    [self.table numberOfRowsInSection: indexPath.section] - 1) {
    if (indexPath.section != 
      [self numberOfSectionsInTableView: self.table] - 1) {
      // Bottom border
      CALayer *border = [CALayer layer];
      border.backgroundColor = [UIColor grayLight].CGColor;
      border.frame = CGRectMake(0.0f, 
        cell.contentView.frame.size.height - borderHeight,
          cell.contentView.frame.size.width, borderHeight);
      [cell.layer addSublayer: border];
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // The 1 is for the spacing
  if (section == 0) {
    return 1 + 3;
  }
  else if (section == 1) {
    return 1 + 4;
  }
  else if (section == 2) {
    return 1 + 1;
  }
  else if (section == 3) {
    return 1;
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
      OMBMyRenterProfileViewController *vc = 
        [[OMBMyRenterProfileViewController alloc] init];
      [vc loadUser: [OMBUser currentUser]];
      [self.navigationController pushViewController: vc animated: YES];
    }
    // Renter Application
    else if (indexPath.row == 2) {
      [self.navigationController pushViewController:
        [[OMBRenterApplicationViewController alloc] initWithUser: 
          [OMBUser currentUser]] animated: YES];
    }
    // Payment Methods
    else if (indexPath.row == 3) {
      [self.navigationController pushViewController:
        [[OMBPayoutMethodsViewController alloc] init] animated: YES];
    }
  }
  else if (indexPath.section == 1) {
    // How it Works
    if (indexPath.row == 1) {
      [appDelegate.container showIntroAnimatedVertical: YES];
    }
    // Rate us
    else if (indexPath.row == 2) {
      [self.navigationController pushViewController:
       [[OMBRateFeedbackViewController alloc] init] animated: YES];
    }
    // Terms of Service
    else if (indexPath.row == 3) {
      [self.navigationController pushViewController: 
        [[OMBTermsOfServiceViewController alloc] init] animated: YES];
    }
    // Privacy Policy
    else if (indexPath.row == 4) {
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
  if (indexPath.section == 0) {
    // Don't show the renter application
    if (indexPath.row == 2) {
      return 0.0f;
    }
  }
  return 44.0f;
}

@end
