//
//  OMBRenterInfoSectionCosignersViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionCosignersViewController.h"

#import "NSString+OnMyBlock.h"
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
  tagSection = OMBUserDefaultsRenterApplicationCheckedCosigners;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  
  [self setEmptyLabelText: @"Some landlords require a co-signer \n"
    @"If you have one, add them here."];

  [addButton setTitle: @"Add Co-signer" forState: UIControlStateNormal];
  [addButtonMiddle setTitle: @"Add Co-signer" forState: UIControlStateNormal];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  
  key = OMBUserDefaultsRenterApplicationCheckedCosigners;
  
  [[self renterApplication] fetchCosignersForUserUID: [OMBUser currentUser].uid 
    delegate: self completion: ^(NSError *error) {
      [self stopSpinning];
      [self hideEmptyLabel: [[self objects] count]];
    }];
  [self startSpinning];

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
  [cell loadData: [[self objects] objectAtIndex: row]];
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
  return [[self objects] count];
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

- (NSArray *) objects
{
  return [[self renterApplication] cosignersSortedByFirstName];
}

- (void) deleteModelObjectAtIndexPath: (NSIndexPath *) indexPath
{
  OMBCosigner *cosigner = [[self objects] objectAtIndex: indexPath.row];
  [[self renterApplication] deleteCosignerConnection: cosigner delegate: nil
    completion: nil];

  [self.table beginUpdates];
  [[self renterApplication] removeCosigner: cosigner];
  [self.table deleteRowsAtIndexPaths: @[indexPath]
    withRowAnimation: UITableViewRowAnimationFade];
  [self.table endUpdates];
  
  [self hideEmptyLabel: [[self objects] count]];
}

- (void) reloadTable
{
  [self.table reloadData];
}

@end
