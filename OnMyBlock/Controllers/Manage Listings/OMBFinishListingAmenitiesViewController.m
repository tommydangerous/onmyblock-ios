//
//  OMBFinishListingAmenitiesViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingAmenitiesViewController.h"

#import "OMBAmenityStore.h"
#import "OMBFinishListingAmenityCell.h"
#import "OMBResidence.h"
#import "OMBResidenceUpdateConnection.h"
#import "OMBHeaderTitleCell.h"
#import "UIColor+Extensions.h"

@implementation OMBFinishListingAmenitiesViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  self.title = @"Amenities";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  saveBarButtonItem.enabled = YES;
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;
  
  [self setupForTable];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];

  OMBResidenceUpdateConnection *conn = 
    [[OMBResidenceUpdateConnection alloc] initWithResidence: 
      residence attributes: @[@"amenities", @"cats", @"dogs"]];
  [conn start];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return [[[OMBAmenityStore sharedStore] categories] count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Header
  if (indexPath.row == 0) {
    static NSString *HeaderID = @"HeaderID";  
    UITableViewCell *headerCell = 
      [tableView dequeueReusableCellWithIdentifier: HeaderID];
    if (!headerCell) {
      headerCell = [[UITableViewCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: HeaderID];
      headerCell.backgroundColor = tableView.backgroundColor;
      headerCell.selectionStyle  = UITableViewCellSelectionStyleNone;
      headerCell.textLabel.font  = [UIFont mediumTextFontBold];
      headerCell.textLabel.textAlignment = NSTextAlignmentCenter;
      headerCell.textLabel.textColor     = [UIColor grayMedium];
    }
    headerCell.textLabel.text = 
      [[self categoryForSection: indexPath.section] capitalizedString];
    return headerCell;
  }
  static NSString *AmenityCellID = @"AmenityCellID";
  OMBFinishListingAmenityCell *cell = 
    [tableView dequeueReusableCellWithIdentifier: AmenityCellID];
  if (!cell)
    cell = [[OMBFinishListingAmenityCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: AmenityCellID];
  NSString *amenity = [self amenityAtIndexPath: indexPath];
  [cell setAmenityName: amenity checked: [residence hasAmenity: amenity]];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Header (we don't use viewForHeaderInSection because we don't want
  // the header to float, we want it to scroll)
  return 1 + [[self amenitiesForCategoryInSection: section] count];
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Must account for the header row
  if (indexPath.row > 0) {
    NSString *amenity = [self amenityAtIndexPath: indexPath];
    // Remove the amenity
    if ([residence hasAmenity: amenity]) {
      [residence removeAmenity: amenity];
    }
    // Add the amenity
    else {
      [residence addAmenity: amenity];
    }
    [tableView reloadData];
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];

  // BOOL reload = NO;
  // // Pets
  // if (indexPath.section == 0) {
  //   // Dogs
  //   if (indexPath.row == 1) {
  //     reload = YES;
  //     residence.dogs = !residence.dogs;
  //   }
  //   // Cats
  //   else if (indexPath.row == 2) {
  //     reload = YES;
  //     residence.cats = !residence.cats;
  //   }
  //   // None
  //   else if (indexPath.row == 3) {
  //     reload = YES;
  //     residence.cats = residence.dogs = NO;
  //   }
  // }
  // // Amenities
  // else if (indexPath.section == 1) {
  //   if(indexPath.row){
  //     reload = YES;
  //     // NSString *string = [[OMBResidence defaultListOfAmenities] objectAtIndex:
  //     //                   (indexPath.row - 1)];
  //     // int value = [[residence.amenities objectForKey: string] intValue];
  //     // int newValue = 0;
  //     // if (value) {
  //     //   newValue = 0;
  //     // }
  //     // else {
  //     //   newValue = 1;
  //     // }
  //     // [residence.amenities setObject: [NSNumber numberWithInt: newValue]
  //     //                       forKey: string];
  //   }
  // }
//  if(reload)
//    [tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation:
//     UITableViewRowAnimationNone];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBFinishListingAmenityCell heightForCell];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (NSArray *) amenitiesForCategoryInSection: (NSInteger) section
{
  return [[OMBAmenityStore sharedStore] amenitiesForCategory:
    [self categoryForSection: section]];
}

- (NSString *) amenityAtIndexPath: (NSIndexPath *) indexPath
{
  // Need to minus 1 to account for the header of each section
  return [[self amenitiesForCategoryInSection: 
    indexPath.section] objectAtIndex: indexPath.row - 1];
}

- (NSString *) categoryForSection: (NSInteger) section
{
  return [[[OMBAmenityStore sharedStore] categories] objectAtIndex: section];
}

@end
