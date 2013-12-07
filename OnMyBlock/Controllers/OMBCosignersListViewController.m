//
//  OMBCosignersListViewController.m
//  OnMyBlock
//
//  Created by Morgan Schwanke on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCosignersListViewController.h"

#import "OMBCosignerAddViewController.h"
#import "OMBCosignerCell.h"
#import "OMBCosignerDeleteConnection.h"
#import "OMBCosignerListConnection.h"
#import "OMBNavigationController.h"
#import "OMBRenterApplication.h"
#import "UIColor+Extensions.h"

@implementation OMBCosignersListViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super initWithUser: object])) return nil;

  self.screenName = self.title = @"Co-signers";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setAddBarButtonItem];
  
  sheet = [[UIActionSheet alloc] initWithTitle: nil 
    delegate: self cancelButtonTitle: @"Cancel" 
      destructiveButtonTitle: @"Remove Cosigner" otherButtonTitles: nil];
  [self.view addSubview: sheet];

  [self setupForTable];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  OMBCosignerListConnection *connection = 
    [[OMBCosignerListConnection alloc] initWithUser: user];
  connection.completionBlock = ^(NSError *error) {
    [self.table reloadData];
  };
  [connection start];
  [self.table reloadData];
}

#pragma mark - Protocol

#pragma mark - Protocol UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  // Remove cosigner
  if (buttonIndex == 0) {
    [self.table beginUpdates];
    OMBCosigner *cosigner = 
      [[user.renterApplication cosignersSortedByFirstName]
        objectAtIndex: selectedIndexPath.row];
    // Delete connection
    [[[OMBCosignerDeleteConnection alloc] initWithCosigner: cosigner] start];
    [user.renterApplication.cosigners removeObject: cosigner];
    [self.table deleteRowsAtIndexPaths: @[selectedIndexPath]
      withRowAnimation: UITableViewRowAnimationFade];
    [self.table endUpdates];
    selectedIndexPath = nil;
  }
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  OMBCosignerCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[OMBCosignerCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CellIdentifier];
  [cell loadData: 
    [[user.renterApplication cosignersSortedByFirstName] 
      objectAtIndex: indexPath.row]];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [user.renterApplication.cosigners count];
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  selectedIndexPath = indexPath;
  [sheet showInView: self.view];
  [self.table deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{  
  return 20.0f + (22.0f * 3.0f) + 20.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addModel
{
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      [[OMBCosignerAddViewController alloc] init]] animated: YES
        completion: nil];
}

@end
