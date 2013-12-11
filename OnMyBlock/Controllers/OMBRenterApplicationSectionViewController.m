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

  showedAddModelViewControllerForTheFirstTime = NO;
  user = object;
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  addBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Add"
    style: UIBarButtonItemStylePlain target: self 
      action: @selector(addModel)];
  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
    style: UIBarButtonItemStylePlain target: self 
      action: @selector(done)];
  saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Save"
    style: UIBarButtonItemStylePlain target: self 
      action: @selector(save)];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  selectedIndexPath = indexPath;
  [sheet showInView: self.view];
  [self.table deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addModel
{
  // Subclasses implement this
}

- (void) done
{
  // Subclasses implement this
}

- (void) save
{
  // Subclasses implement this
}

- (void) setAddBarButtonItem
{
  self.navigationItem.rightBarButtonItem = addBarButtonItem;
}

- (void) setupForTable
{
  self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
  self.table.separatorColor = [UIColor grayLight];
  self.table.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

@end
