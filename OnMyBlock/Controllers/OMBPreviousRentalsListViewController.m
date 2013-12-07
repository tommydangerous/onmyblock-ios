//
//  OMBPreviousRentalsViewController.m
//  OnMyBlock
//
//  Created by Morgan Schwanke on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPreviousRentalsListViewController.h"

#import "NSString+PhoneNumber.h"
#import "OMBNavigationController.h"
#import "OMBPreviousRental.h"
#import "OMBPreviousRentalAddViewController.h"
#import "OMBPreviousRentalCell.h"
#import "OMBRenterApplication.h"

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

  [self setupForTable];  
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [self.table reloadData];

  NSLog(@"FETCH PREVIOUS RENTALS");
}

#pragma mark - Protocol

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

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSLog(@"SELECTED PREVIOUS RENTAL");
  [self.table deselectRowAtIndexPath: indexPath animated: YES];
}

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
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      [[OMBPreviousRentalAddViewController alloc] init]] animated: YES
        completion: nil];
}

@end
