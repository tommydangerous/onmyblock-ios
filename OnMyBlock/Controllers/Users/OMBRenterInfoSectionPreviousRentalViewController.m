//
//  OMBRenterInfoSectionPreviousRentalViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionPreviousRentalViewController.h"

#import "OMBPreviousRentalCell.h"
#import "OMBNavigationController.h"
#import "OMBRenterApplication.h"
#import "OMBRenterInfoAddPreviousRentalViewController.h"

@implementation OMBRenterInfoSectionPreviousRentalViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super initWithUser: object])) return nil;
  
  self.title = @"Rental History";
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  
  [self setEmptyLabelText: @"You have no rental history.\nAdding a previous rental "
   @"will greatly increase your acceptance rate."];
  
  [addButton setTitle: @"Add Previous Rental" forState: UIControlStateNormal];
  [addButtonMiddle setTitle: @"Add Previous Rental" forState: UIControlStateNormal];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  
  /*[[self renterApplication] fetchPreviousRentalsForUserUID: [OMBUser currentUser].uid
    delegate: self completion: ^(NSError *error) {
      [self hideEmptyLabel: [[self cosigners] count]];
  }];*/
  
  // Remove this line
  [self hideEmptyLabel: [[self previousRentals] count]];
  
  [self reloadTable];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  #warning CHANGE
  /*[[self renterApplication] readFromPreviousRentalDictionary: dictionary];
  [self reloadTable];*/
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSUInteger row     = indexPath.row;
  NSUInteger section = indexPath.section;
  
  static NSString *PreviousRentalID = @"PreviousRentalID";
  OMBPreviousRentalCell *cell = [tableView dequeueReusableCellWithIdentifier:
    PreviousRentalID];
  if (!cell)
    cell = [[OMBPreviousRentalCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: PreviousRentalID];
  [cell loadData: [[self previousRentals] objectAtIndex: row]];
  // Last row
  if (row == [self tableView: tableView numberOfRowsInSection: section] - 1) {
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
      0.0f, 0.0f);
  }
  else {
    cell.separatorInset = tableView.separatorInset;
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
  return [[self previousRentals] count];
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBPreviousRentalCell heightForCell];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addButtonSelected
{
  [self presentViewController:
   [[OMBNavigationController alloc] initWithRootViewController:
    [[OMBRenterInfoAddPreviousRentalViewController alloc] init]] animated: YES
      completion: nil];
}

- (NSArray *) previousRentals
{
  #warning CHANGE
  return [[self renterApplication] employmentsSortedByStartDate];
}

- (void) deleteModelObjectAtIndexPath: (NSIndexPath *) indexPath
{
  OMBPreviousRental *previousRental = [[self previousRentals] objectAtIndex: indexPath.row];
  #warning CREATE METHOD
  /*[[self renterApplication] deletePreviousRentalConnection: cosigner delegate: nil
    completion: nil];*/
  
  [self.table beginUpdates];
  //[[self renterApplication] removePreviousRental:(OMBPreviousRental *): previousRental];
  [self.table deleteRowsAtIndexPaths: @[indexPath]
    withRowAnimation: UITableViewRowAnimationFade];
  [self.table endUpdates];
  
  [self hideEmptyLabel: [[self previousRentals] count]];
}

- (void) reloadTable
{
  [self.table reloadData];
}

@end
