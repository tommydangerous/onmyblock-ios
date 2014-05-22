//
//  OMBRenterInfoSectionPreviousRentalViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionPreviousRentalViewController.h"

#import "NSString+OnMyBlock.h"
#import "OMBPreviousRental.h"
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
  
  [self setEmptyLabelText: @"Most landlords prefer to see a \n"
    @"rental history of at least 3 \n"
    @"previous places."];
  
  [addButton setTitle: @"Add Previous Rental" forState: UIControlStateNormal];
  [addButtonMiddle setTitle: @"Add Previous Rental" forState: UIControlStateNormal];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  key = OMBUserDefaultsRenterApplicationCheckedRentalHistory;
  
  [self fetchObjects];
  
  [self reloadTable];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  [[self renterApplication] readFromDictionary: dictionary 
    forModelName: [OMBPreviousRental modelName]];
  [self reloadTable];
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
    cell = [[OMBPreviousRentalCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: PreviousRentalID];
  [cell loadData2: [[self objects] objectAtIndex: row]];
  
  // Last row
  if (row == [self tableView: tableView numberOfRowsInSection: section] - 1) {
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
      0.0f, 0.0f);
  }
  else {
    cell.separatorInset = tableView.separatorInset;
  }
  cell.clipsToBounds = YES;
  return cell;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBPreviousRentalCell heightForCell2];
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

- (void) fetchObjects
{
  [self fetchObjectsForResourceName: [OMBPreviousRental resourceName]];
}

- (NSArray *) objects
{
  return [[self renterApplication] objectsWithModelName: 
    [OMBPreviousRental modelName] sortedWithKey: @"moveInDate" ascending: NO];
}

- (void) reloadTable
{
  [self.table reloadData];
}

@end
