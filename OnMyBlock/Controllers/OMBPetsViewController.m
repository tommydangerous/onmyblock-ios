//
//  OMBPetsViewController.m
//  OnMyBlock
//
//  Created by Morgan Schwanke on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPetsViewController.h"

#import "OMBRenterApplication.h"
#import "OMBRenterApplicationPetCell.h"
#import "OMBRenterApplicationUpdateConnection.h"
#import "UIColor+Extensions.h"

@implementation OMBPetsViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
	if (!(self = [super initWithUser: object])) return nil;

	self.screenName = @"Pets";
  self.title      = @"Do You Have Pets?";

	return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Save"
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(save)];

  self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
  self.table.separatorColor = [UIColor grayLight];
  self.table.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";

  OMBRenterApplicationPetCell *cell = 
    [[OMBRenterApplicationPetCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  cell.selectedBackgroundView = nil;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  // Dogs
  if (indexPath.row == 0) {
    cell.iconImageView.image = [UIImage imageNamed: @"dogs_icon.png"];
    cell.nameLabel.text = @"Dogs";
    if (user.renterApplication.dogs)
      [cell fillInCheckmarkBox];
  }
  // Cats
  else if (indexPath.row == 1) {
    cell.iconImageView.image = [UIImage imageNamed: @"cats_icon.png"];
    cell.nameLabel.text = @"Cats";
    if (user.renterApplication.cats)
      [cell fillInCheckmarkBox];
  }
  // None
  else if (indexPath.row == 2) {
    cell.iconImageView.image = [UIImage imageNamed: @"slash_icon.png"];
    cell.nameLabel.text = @"None";
    if (!user.renterApplication.cats && !user.renterApplication.dogs)
      [cell fillInCheckmarkBox];
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return 3;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  OMBRenterApplicationPetCell *cell = (OMBRenterApplicationPetCell *)
    [self tableView: self.table cellForRowAtIndexPath: indexPath];
  // Dogs
  if (indexPath.row == 0) {
    // If selected
    if (user.renterApplication.dogs) {
      // Unselect it
      user.renterApplication.dogs = NO;
      [cell emptyCheckmarkBox];
    }
    else {
      // Select it
      user.renterApplication.dogs = YES;
      [cell fillInCheckmarkBox];
    }
  }
  // Cats
  else if (indexPath.row == 1) {
    // If selected
    if (user.renterApplication.cats) {
      // Unselect it
      user.renterApplication.cats = NO;
      [cell emptyCheckmarkBox];
    }
    else {
      // Select it
      user.renterApplication.cats = YES;
      [cell fillInCheckmarkBox];
    }
  }
  // None
  else if (indexPath.row == 2) {
    user.renterApplication.cats = NO;
    user.renterApplication.dogs = NO;

  }
  [self.table reloadData];
  [[[OMBRenterApplicationUpdateConnection alloc] init] start];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 100.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) save
{
  [self.navigationController popViewControllerAnimated: YES];
}

@end
