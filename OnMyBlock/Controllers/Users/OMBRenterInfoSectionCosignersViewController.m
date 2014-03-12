//
//  OMBRenterInfoSectionCosignersViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionCosignersViewController.h"

#import "OMBCosignerCell.h"
#import "OMBNavigationController.h"
#import "OMBRenterApplication.h"
#import "OMBRenterInfoAddCosignerViewController.h"

@interface OMBRenterInfoSectionCosignersViewController ()

@end

@implementation OMBRenterInfoSectionCosignersViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super initWithUser: object])) return nil;

  self.title = @"Co-signers";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  
  [self setEmptyLabelText: @"You have no co-signers.\nAdding a co-signer "
    @"will greatly increase your acceptance rate."];

  [addButton setTitle: @"Add Co-signer" forState: UIControlStateNormal];
  [addButtonMiddle setTitle: @"Add Co-signer" forState: UIControlStateNormal];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [[self renterApplication] fetchCosignersForUserUID: [OMBUser currentUser].uid 
    delegate: self completion: nil];

  [self reloadTable];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  [[self renterApplication] readFromCosignerDictionary: dictionary];
  [self reloadTable];
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSUInteger row     = indexPath.row;
  NSUInteger section = indexPath.section;

  static NSString *CosignerID = @"CosignerID";
  OMBCosignerCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CosignerID];
  if (!cell)
    cell = [[OMBCosignerCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CosignerID];
  [cell loadData: [[self cosigners] objectAtIndex: indexPath.row]];
  // Last row
  if (row == [self tableView: tableView numberOfRowsInSection: section] - 1) {
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
      0.0f, 0.0f);
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [[self cosigners] count];
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBCosignerCell heightForCell];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addButtonSelected
{
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      [[OMBRenterInfoAddCosignerViewController alloc] init]] animated: YES 
        completion: nil];
}

- (NSArray *) cosigners
{
  return [[self renterApplication] cosignersSortedByFirstName];
}

- (void) deleteModelObjectAtIndexPath: (NSIndexPath *) indexPath
{
  OMBCosigner *cosigner = [[self cosigners] objectAtIndex: indexPath.row];
  [[self renterApplication] deleteCosignerConnection: cosigner delegate: nil
    completion: ^(NSError *error) {
      [self.table beginUpdates];
      [[self renterApplication] removeCosigner: cosigner];
      [self.table deleteRowsAtIndexPaths: @[indexPath]
        withRowAnimation: UITableViewRowAnimationFade];
      [self.table endUpdates];
      [self hideEmptyLabel: [[self cosigners] count]];
    }
  ];
}

- (void) reloadTable
{
  [self hideEmptyLabel: [[self cosigners] count]];
  [self.table reloadData];
}

@end
