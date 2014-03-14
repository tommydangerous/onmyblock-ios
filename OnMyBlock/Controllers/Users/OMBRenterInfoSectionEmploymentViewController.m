//
//  OMBRenterInfoEmploymentViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionEmploymentViewController.h"

#import "OMBEmploymentCell.h"
#import "OMBNavigationController.h"
#import "OMBRenterApplication.h"
#import "OMBRenterInfoAddEmploymentViewController.h"

@implementation OMBRenterInfoSectionEmploymentViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super initWithUser: object])) return nil;
  
  self.title = @"Work History";
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  
  [self setEmptyLabelText: @"You have no work history.\nAdding a employment "
   @"will greatly increase your acceptance rate."];
  
  [addButton setTitle: @"Add Employment" forState: UIControlStateNormal];
  [addButtonMiddle setTitle: @"Add Employment" forState: UIControlStateNormal];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  
  /*[[self renterApplication] fetchEmploymentsForUserUID: [OMBUser currentUser].uid
     delegate: self completion: ^(NSError *error) {
       [self hideEmptyLabel: [[self employments] count]];
    }];*/
#warning DELETE THIS LINE AND CREATE METHOD ABOVE
  [self hideEmptyLabel: [[self employments] count]];
  
  [self reloadTable];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
#warning CREATE METHOD
  //[[self renterApplication] readFromEmploymentDictionary: dictionary];
  [self reloadTable];
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSUInteger row     = indexPath.row;
  NSUInteger section = indexPath.section;
  
  static NSString *EmploymentID = @"EmploymentID";
  OMBEmploymentCell *cell = [tableView dequeueReusableCellWithIdentifier:
                           EmploymentID];
  if (!cell)
    cell = [[OMBEmploymentCell alloc] initWithStyle: UITableViewCellStyleDefault
                                  reuseIdentifier: EmploymentID];
  [cell loadData: [[self employments] objectAtIndex: row]];
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
  return [[self employments] count];
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBEmploymentCell heightForCell];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addButtonSelected
{
  [self presentViewController:
   [[OMBNavigationController alloc] initWithRootViewController:
    [[OMBRenterInfoAddEmploymentViewController alloc] init]] animated: YES
      completion: nil];
}

- (NSArray *) employments
{
  return [[self renterApplication] employmentsSortedByStartDate];
}

- (void) deleteModelObjectAtIndexPath: (NSIndexPath *) indexPath
{

  OMBEmployment *employment = [[self employments] objectAtIndex: indexPath.row];
#warning CREATE METHOD
  /*[[self renterApplication] deleteCosignerConnection: employment delegate: nil
    completion: nil];*/
  
  [self.table beginUpdates];
  [[self renterApplication] removeEmployment: employment];
  [self.table deleteRowsAtIndexPaths: @[indexPath]
    withRowAnimation: UITableViewRowAnimationFade];
  [self.table endUpdates];
  
  [self hideEmptyLabel: [[self employments] count]];
}

- (void) reloadTable
{
  [self.table reloadData];
}

@end
