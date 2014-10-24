//
//  OMBHomebaseLandlordConfirmedTenantsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseLandlordConfirmedTenantsViewController.h"

#import "OMBHomebaseLandlordConfirmedTenantCell.h"
#import "OMBOffer.h"
#import "OMBUser.h"

@implementation OMBHomebaseLandlordConfirmedTenantsViewController

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object
{
  if (!(self = [super init])) return nil;

  offer = object;

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
  // Will eventually need an accessory type
  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  [cell loadUser: offer.user];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return 1;
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
