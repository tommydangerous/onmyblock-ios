//
//  OMBTableViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@interface OMBTableViewController : OMBViewController
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) fetchFavorites;
- (void) reloadTable;
- (void) setupForTable;

@end
