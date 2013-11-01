//
//  OMBFavoritesListViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/31/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFavoritesListViewController.h"

#import "OMBFavoritesListConnection.h"
#import "OMBResidence.h"
#import "OMBResidenceCell.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"

@implementation OMBFavoritesListViewController

@synthesize table = _table;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.title = @"Favorites";
  // [[NSNotificationCenter defaultCenter] addObserver: self
  //   selector: @selector(reloadTable)
  //     name: OMBCurrentUserChangedFavorite object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(currentUserChangedFavorite:)
      name: OMBCurrentUserChangedFavorite object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(fetchFavorites)
      name: OMBUserLoggedInNotification object: nil];

  return self;
}

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
  _table.backgroundColor              = [UIColor backgroundColor];
  _table.canCancelContentTouches      = YES;
  _table.contentInset                 = UIEdgeInsetsMake(0, 0, -49, 0);
  _table.dataSource                   = self;
  _table.delegate                     = self;
  _table.separatorColor               = [UIColor clearColor];
  _table.separatorStyle               = UITableViewCellSeparatorStyleNone;
  _table.showsVerticalScrollIndicator = NO;
  [self.view addSubview: _table];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  [self fetchFavorites];
  [self reloadTable];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  OMBResidenceCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell) {
    cell = [[OMBResidenceCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  }
  [cell loadResidenceData: 
    [[[OMBUser currentUser] favoritesArray] objectAtIndex: indexPath.row]];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [[[OMBUser currentUser] favoritesArray] count];
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  OMBResidence *residence = 
    [[[OMBUser currentUser] favoritesArray] objectAtIndex: indexPath.row];
  [self.navigationController pushViewController:
    [[OMBResidenceDetailViewController alloc] initWithResidence: 
      residence] animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  return (screen.size.height * 0.3) + 5;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) currentUserChangedFavorite: (NSNotification *) notification
{
  // If the user removed a favorite
  if ([notification userInfo]) {
    int index = [[[notification userInfo] objectForKey: @"index"] intValue];
    [_table beginUpdates];
    [_table deleteRowsAtIndexPaths: 
      @[[NSIndexPath indexPathForRow: index inSection: 0]] withRowAnimation: 
        UITableViewRowAnimationFade];
    [_table endUpdates];
  }
  // If the user added a favorite
  else {
    [self reloadTable];
  }
}

- (void) fetchFavorites
{
  OMBFavoritesListConnection *connection = 
    [[OMBFavoritesListConnection alloc] init];
  connection.completionBlock = ^(NSError *error) {
    [self reloadTable];
  };
  connection.delegate = self;
  [connection start];
}

- (void) reloadTable
{
  [_table reloadData];
}

@end
