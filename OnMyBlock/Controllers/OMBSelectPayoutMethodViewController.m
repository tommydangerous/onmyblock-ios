//
//  OMBPayoutMethodsAddViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBSelectPayoutMethodViewController.h"

#import "OMBPayoutMethodCell.h"
#import "OMBPayoutMethodPayPalViewController.h"
#import "OMBPayoutMethodVenmoViewController.h"
#import "UIColor+Extensions.h"

@implementation OMBSelectPayoutMethodViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Select Payout Method";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setupForTable];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  OMBPayoutMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[OMBPayoutMethodCell alloc] initWithStyle: 0
      reuseIdentifier: CellIdentifier];
  if (indexPath.section == 0) {
    // Venmo
    if (indexPath.row == 0) {
      cell.detailLabel.text = @"Arrives in 3-4 hours.\n"
        @"Venmo is completely free.";
        cell.iconImageView.image = [UIImage imageNamed: @"venmo_icon.png"];
      cell.iconView.backgroundColor = 
        cell.iconViewBackgroundColor = [UIColor venmoBlue];
      cell.nameLabel.text = @"Venmo";
    }
    // Paypal
    else if (indexPath.row == 1) {
      cell.detailLabel.text = @"Arrives in 3-4 hours.\n"
        @"Paypal charges a small fee.";
      cell.iconImageView.image = [UIImage imageNamed: @"paypal_icon.png"];
      cell.iconView.backgroundColor = 
        cell.iconViewBackgroundColor = [UIColor paypalBlue];
      cell.nameLabel.text = @"PayPal";
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Venmo
  // Paypal
  return 2;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.section == 0) {
    // Venmo
    if (indexPath.row == 0) {
      [self.navigationController pushViewController:
        [[OMBPayoutMethodVenmoViewController alloc] init] animated: YES];
    }
    // PayPal
    else if (indexPath.row == 1) {
      [self.navigationController pushViewController:
        [[OMBPayoutMethodPayPalViewController alloc] init] animated: YES];
    }
  }
  [self.table deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 20.0f + 27.0f + 22.0f + 22.0f + 20.0f;
}

@end
