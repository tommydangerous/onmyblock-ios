//
//  OMBRenterApplicationSectionViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationSectionViewController.h"

#import "UIColor+Extensions.h"

@implementation OMBRenterApplicationSectionViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user = object;
  
  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addModel
{
  // Subclasses implement this
}

- (void) setAddBarButtonItem
{
  self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Add"
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(addModel)];
}

- (void) setupForTable
{
  self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
  self.table.separatorColor = [UIColor grayLight];
  self.table.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

@end
