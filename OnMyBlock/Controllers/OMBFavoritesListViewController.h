//
//  OMBFavoritesListViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/31/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@interface OMBFavoritesListViewController : OMBViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) fetchFavorites;
- (void) reloadTable;

@end
