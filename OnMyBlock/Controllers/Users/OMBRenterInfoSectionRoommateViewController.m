//
//  OMBRenterInfoSectionRoommatesViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionRoommateViewController.h"

#import "OMBNavigationController.h"
#import "OMBRenterApplication.h"
#import "OMBRenterInfoAddRoommateViewController.h"
#import "OMBRoommateCell.h"

@interface OMBRenterInfoSectionRoommateViewController ()

@end

@implementation OMBRenterInfoSectionRoommateViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super initWithUser: object])) return nil;
  
  self.title = @"Co-applicants";
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  
  [self setEmptyLabelText: @"You have no co-applicants.\nAdding a co-applicant "
   @"will greatly increase your acceptance rate."];
  
  [addButton setTitle: @"Add Roommate" forState: UIControlStateNormal];
  [addButtonMiddle setTitle: @"Add Roommate" forState: UIControlStateNormal];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  
  /*[[self renterApplication] fetchEmploymentsForUserUID: [OMBUser currentUser].uid
   delegate: self completion: ^(NSError *error) {
   [self hideEmptyLabel: [[self employments] count]];
   }];*/
  #warning DELETE THIS LINE AND CREATE METHOD ABOVE
  [self hideEmptyLabel: [[self roommates] count]];
  
  [self reloadTable];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  #warning CREATE METHOD
  //[[self renterApplication] readFromRoommateDictionary: dictionary];
  [self reloadTable];
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSUInteger row     = indexPath.row;
  NSUInteger section = indexPath.section;
  
  static NSString *RoommateID = @"RoommateID";
  OMBRoommateCell *cell = [tableView dequeueReusableCellWithIdentifier:
    RoommateID];
  if (!cell)
    cell = [[OMBRoommateCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: RoommateID];
  [cell loadData: [[self roommates] objectAtIndex: row]];
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
  return [[self roommates] count];
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBRoommateCell heightForCell];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addButtonSelected
{
  [self presentViewController:
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBRenterInfoAddRoommateViewController alloc] init]] animated: YES
        completion: nil];
}

- (void) deleteModelObjectAtIndexPath: (NSIndexPath *) indexPath
{
  OMBRoommate *roommate = [[self roommates] objectAtIndex: indexPath.row];
  #warning CREATE METHOD
  /*[[self renterApplication] deleteRoommateConnection: roommate delegate: nil
    completion: nil];*/
  
  [self.table beginUpdates];
  [[self renterApplication] removeRoommate: roommate];
  [self.table deleteRowsAtIndexPaths: @[indexPath]
    withRowAnimation: UITableViewRowAnimationFade];
  [self.table endUpdates];
  
  [self hideEmptyLabel: [[self roommates] count]];
}

- (void) reloadTable
{
  [self.table reloadData];
}

- (NSArray *) roommates
{
  // Change method in renter info
  return [[self renterApplication] roommatesSort];
}

@end
