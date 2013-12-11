//
//  OMBPreviousRentalsViewController.m
//  OnMyBlock
//
//  Created by Morgan Schwanke on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPreviousRentalsListViewController.h"

#import "NSString+PhoneNumber.h"
#import "OMBDeleteRenterApplicationSectionModelConnection.h"
#import "OMBNavigationController.h"
#import "OMBPreviousRental.h"
#import "OMBPreviousRentalAddViewController.h"
#import "OMBPreviousRentalCell.h"
#import "OMBPreviousRentalListConnection.h"

@implementation OMBPreviousRentalsListViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super initWithUser: object])) return nil;

  self.screenName = self.title = @"Previous Rentals";

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
      destructiveButtonTitle: @"Remove Previous Rental" 
        otherButtonTitles: nil];
  [self.view addSubview: sheet];


  [self setupForTable];  
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  OMBPreviousRentalListConnection *connection = 
    [[OMBPreviousRentalListConnection alloc] initWithUser: user];
  connection.completionBlock = ^(NSError *error) {
    if ([user.renterApplication.previousRentals count] == 0 &&
      !showedAddModelViewControllerForTheFirstTime) {

      showedAddModelViewControllerForTheFirstTime = YES;
      [self addModel];
    } 
    else
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
    OMBPreviousRental *object = 
      [user.renterApplication.previousRentals objectAtIndex: 
        selectedIndexPath.row];
    // Delete connection
    [[[OMBDeleteRenterApplicationSectionModelConnection alloc] 
      initWithObject: object] start];
    // Remove previous rental from user's previous rental
    [user.renterApplication.previousRentals removeObject: object];
    // Reload the row
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
  OMBPreviousRentalCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = 
      [[OMBPreviousRentalCell alloc] initWithStyle: UITableViewCellStyleDefault
        reuseIdentifier: CellIdentifier];
  [cell loadData: 
    [user.renterApplication.previousRentals objectAtIndex: indexPath.row]];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [user.renterApplication.previousRentals count];
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  float height = 20.0f + (22.0f * 3) + 20.0f;
  OMBPreviousRental *previousRental = 
    [user.renterApplication.previousRentals objectAtIndex: indexPath.row];
  if ([previousRental.landlordEmail length] > 0)
    height += 22;
  if ([previousRental.landlordName length] > 0)
    height += 22;
  if ([[previousRental.landlordPhone phoneNumberString] length] > 0)
    height += 22;
  if (height > 20 + (22 * 3) + 20)
    height += 20;
  return height;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addModel
{
  OMBPreviousRentalAddViewController *viewController =
    [[OMBPreviousRentalAddViewController alloc] init];
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      viewController] animated: YES
        completion: ^{
          [viewController firstTextFieldBecomeFirstResponder];
        }];
}

@end
