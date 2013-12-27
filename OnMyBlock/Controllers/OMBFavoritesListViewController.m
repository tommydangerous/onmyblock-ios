//
//  OMBFavoritesListViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/31/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFavoritesListViewController.h"

#import "OMBFavoriteResidence.h"
#import "OMBFavoriteResidenceCell.h"
#import "OMBFavoritesListConnection.h"
#import "OMBMapViewController.h"
#import "OMBResidence.h"
#import "OMBResidenceCell.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"

@implementation OMBFavoritesListViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Favorites";

  // [[NSNotificationCenter defaultCenter] addObserver: self
  //   selector: @selector(reloadTable)
  //     name: OMBCurrentUserChangedFavorite object: nil];

  // Whenever a user adds or removes a favorite residence
  // OMBUser - addFavoriteResidence and - remove post this notification
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(currentUserChangedFavorite:)
      name: OMBCurrentUserChangedFavorite object: nil];

  // [[NSNotificationCenter defaultCenter] addObserver: self
  //   selector: @selector(fetchFavorites)
  //     name: OMBUserLoggedInNotification object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setMenuBarButtonItem];

  self.table.backgroundColor = [UIColor blackColor];
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
  OMBFavoriteResidenceCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell) {
    cell = [[OMBFavoriteResidenceCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [[[OMBUser currentUser] favoritesArray] count];
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView 
didEndDisplayingCell: (UITableViewCell *) cell 
forRowAtIndexPath: (NSIndexPath *) indexPath
{
  OMBFavoriteResidenceCell *c = (OMBFavoriteResidenceCell *) cell;
  c.imageView.image = nil;
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  OMBFavoriteResidence *favorite = 
    [[[OMBUser currentUser] favoritesArray] objectAtIndex: indexPath.row];
  [self.navigationController pushViewController:
    [[OMBResidenceDetailViewController alloc] initWithResidence: 
      favorite.residence] animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  return screen.size.height * PropertyInfoViewImageHeightPercentage;
}

- (void) tableView: (UITableView *) tableView 
willDisplayCell: (UITableViewCell *) cell 
forRowAtIndexPath: (NSIndexPath *) indexPath
{
  OMBFavoriteResidence *favorite = 
    [[[OMBUser currentUser] favoritesArray] objectAtIndex: indexPath.row];
  [(OMBFavoriteResidenceCell *) cell loadFavoriteResidenceData: favorite];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) currentUserChangedFavorite: (NSNotification *) notification
{
  // If the user removed a favorite
  if ([notification userInfo]) {
    int index = [[[notification userInfo] objectForKey: @"index"] intValue];
    [self.table beginUpdates];
    [self.table deleteRowsAtIndexPaths: 
      @[[NSIndexPath indexPathForRow: index inSection: 0]] withRowAnimation: 
        UITableViewRowAnimationFade];
    [self.table endUpdates];
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
  [self.table reloadData];
}

@end
