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


#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.currentPage = self.maxPages = 1;
  self.fetching = NO;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];

  self.table = [[UITableView alloc] initWithFrame: screen
    style: UITableViewStylePlain];
  self.table.alwaysBounceVertical         = YES;
  self.table.canCancelContentTouches      = YES;
  // self.table.contentInset                 = UIEdgeInsetsMake(0, 0, -49, 0);
  self.table.dataSource                   = self;
  self.table.delegate                     = self;
  self.table.separatorColor               = [UIColor clearColor];
  self.table.separatorStyle               = UITableViewCellSeparatorStyleNone;
  self.table.showsVerticalScrollIndicator = NO;
  [self.view addSubview: self.table];
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

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Subclasses implement this
  return 0.0f;
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
  self.table.backgroundColor = [UIColor grayUltraLight];
  self.table.separatorColor  = [UIColor grayLight];
  self.table.separatorInset  = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  self.table.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
  self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
}



@end
