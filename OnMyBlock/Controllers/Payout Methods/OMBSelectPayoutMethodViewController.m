//
//  OMBPayoutMethodsAddViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBSelectPayoutMethodViewController.h"

#import "OMBNavigationController.h"
#import "OMBPayoutMethodCell.h"
#import "OMBPayoutMethodCreditCardViewController.h"
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

  self.table.tableHeaderView = [[UIView alloc] initWithFrame: 
    CGRectMake(0.0f, 0.0f, self.table.frame.size.width, 44.0f)];
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
        @"Paypal is completely free.";
      cell.iconImageView.image = [UIImage imageNamed: @"paypal_icon.png"];
      cell.iconView.backgroundColor = 
        cell.iconViewBackgroundColor = [UIColor paypalBlue];
      cell.nameLabel.text = @"PayPal";
    }
    // Credit Card
    else if (indexPath.row == 2) {
      cell.detailLabel.text = @"Arrives within 5-7 business\n"
      @"days except holidays.";
      cell.iconImageView.image = [UIImage imageNamed: @"credit_card_icon.png"];
      cell.iconView.backgroundColor = UIColor.whiteColor;
      cell.nameLabel.text = @"Credit Card";
    }
    if (indexPath.row == 0) {
      CALayer *topBorder = [CALayer layer];
      topBorder.backgroundColor = tableView.separatorColor.CGColor;
      topBorder.frame = CGRectMake(0.0f, 0.0f,
        tableView.frame.size.width, 0.5f);
      [cell.layer addSublayer: topBorder];
    }
    else if (indexPath.row == 
      [tableView numberOfRowsInSection: indexPath.section] - 1) {
      CALayer *bottomBorder = [CALayer layer];
      bottomBorder.backgroundColor = tableView.separatorColor.CGColor;
      bottomBorder.frame = CGRectMake(0.0f, 
        [self tableView: tableView heightForRowAtIndexPath: indexPath] - 0.5f, 
          tableView.frame.size.width, 0.5f);
      [cell.layer addSublayer: bottomBorder];
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Venmo
  // Paypal
  // Credit Card
  return 3;
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
    // Credit Card
    else if (indexPath.row == 2) {
      [self presentViewController:
        [[OMBNavigationController alloc] initWithRootViewController:
          [[OMBPayoutMethodCreditCardViewController alloc] init]] animated: YES
            completion: nil];
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
