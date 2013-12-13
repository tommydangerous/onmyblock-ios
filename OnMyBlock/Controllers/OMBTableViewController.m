//
//  OMBTableViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

#import "UIColor+Extensions.h"

@implementation OMBTableViewController

@synthesize table = _table;

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];

  _table = [[UITableView alloc] initWithFrame: screen
    style: UITableViewStylePlain];
  _table.alwaysBounceVertical         = YES;
  _table.canCancelContentTouches      = YES;
  // _table.contentInset                 = UIEdgeInsetsMake(0, 0, -49, 0);
  _table.dataSource                   = self;
  _table.delegate                     = self;
  _table.separatorColor               = [UIColor clearColor];
  _table.separatorStyle               = UITableViewCellSeparatorStyleNone;
  _table.showsVerticalScrollIndicator = NO;
  [self.view addSubview: _table];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Subclasses implement this
  static NSString *CellIdentifier = @"CellIdentifier";
  return [[UITableViewCell alloc] initWithStyle: 
    UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Subclasses implement this
  return 0;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) fetchFavorites;
{
  // Subclasses implement this
}

- (void) reloadTable
{
  // Subclasses implement this
}

- (void) setupForTable
{
  self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
  self.table.separatorColor = [UIColor grayLight];
  self.table.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

@end
