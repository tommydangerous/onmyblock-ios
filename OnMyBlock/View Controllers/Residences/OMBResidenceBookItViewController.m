//
//  OMBResidenceBookItViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceBookItViewController.h"

#import "OMBResidence.h"
#import "OMBResidenceBookItCell.h"
#import "OMBResidenceBookItConfirmDetailsViewController.h"
#import "UIColor+Extensions.h"

@implementation OMBResidenceBookItViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;

  self.screenName = self.title = @"Book It";

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
  OMBResidenceBookItCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[OMBResidenceBookItCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  if (indexPath.row == 0) {
    CALayer *topBorder = [CALayer layer];
    topBorder.backgroundColor = [UIColor grayLight].CGColor;
    topBorder.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 0.5f);
    [cell.contentView.layer addSublayer: topBorder];
  }
  else if (indexPath.row == [tableView numberOfRowsInSection: 
    indexPath.section] - 1) {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.backgroundColor = [UIColor grayLight].CGColor;
    bottomBorder.frame = CGRectMake(0.0f, 
      [OMBResidenceBookItCell heightForCell] - 0.5f, 
        tableView.frame.size.width, 0.5f);
    [cell.contentView.layer addSublayer: bottomBorder];
  }
  if (indexPath.row == 0) {
    cell.offerLabel.text = @"Current Offer: $4,500";
    [cell setPlaceOfferText];
  }
  else if (indexPath.row == 1) {
    cell.offerLabel.text = @"$6,500";
    [cell setRentItNowText];
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Place Offer
  // Rent it Now
  return 2;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.row == 0) {
    [self.navigationController pushViewController:
      [[OMBResidenceBookItConfirmDetailsViewController alloc] initWithResidence:
        residence] animated: YES];
  }
  [self.table deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBResidenceBookItCell heightForCell];
}

@end
