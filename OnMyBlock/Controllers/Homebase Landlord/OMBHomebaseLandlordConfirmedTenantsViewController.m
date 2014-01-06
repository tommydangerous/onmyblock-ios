//
//  OMBHomebaseLandlordConfirmedTenantsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseLandlordConfirmedTenantsViewController.h"

#import "OMBHomebaseLandlordConfirmedTenantCell.h"

@implementation OMBHomebaseLandlordConfirmedTenantsViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Confirmed Tenants";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setupForTable];
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  OMBHomebaseLandlordConfirmedTenantCell *cell =
    [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
  if (!cell)
    cell = [[OMBHomebaseLandlordConfirmedTenantCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  [cell loadUserData];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return 4;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBHomebaseLandlordConfirmedTenantCell heightForCell];
}

@end
