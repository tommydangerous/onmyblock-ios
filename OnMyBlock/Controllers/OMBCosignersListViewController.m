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
#import "OMBCosignerListConnection.h"
#import "OMBDeleteRenterApplicationSectionModelConnection.h"
#import "OMBNavigationController.h"
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

  // OMBCosignerListConnection *connection = 
  //   [[OMBCosignerListConnection alloc] initWithUser: user];
  // connection.completionBlock = ^(NSError *error) {
  //   if ([[user.renterApplication cosignersSortedByFirstName] count] == 0 &&
  //     !showedAddModelViewControllerForTheFirstTime) {
      
  //     showedAddModelViewControllerForTheFirstTime = YES;
  //     [self addModel];
  //   }
  //   else
  //     [self.table reloadData];
  // };
  // [connection start];
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
    // OMBCosigner *object = 
    //   [[user.renterApplication cosignersSortedByFirstName]
    //     objectAtIndex: selectedIndexPath.row];
    // // Delete connection
    // [[[OMBDeleteRenterApplicationSectionModelConnection alloc] 
    //   initWithObject: object] start];
    // [user.renterApplication.cosigners removeObject: object];
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
  // return [user.renterApplication.cosigners count];
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{  
  return [OMBCosignerCell heightForCell];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addModel
{
  OMBCosignerAddViewController *viewController =
    [[OMBCosignerAddViewController alloc] init];
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      viewController] animated: YES
        completion: ^{
          [viewController firstTextFieldBecomeFirstResponder];
        }];
}

@end
