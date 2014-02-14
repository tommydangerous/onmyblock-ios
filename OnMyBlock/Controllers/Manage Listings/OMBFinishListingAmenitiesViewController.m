//
//  OMBFinishListingAmenitiesViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingAmenitiesViewController.h"

#import "OMBResidence.h"
#import "OMBResidenceUpdateConnection.h"
#import "OMBHeaderTitleCell.h"
#import "UIColor+Extensions.h"

@implementation OMBFinishListingAmenitiesViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  self.screenName = self.title = @"Pets & Amenities";

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
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CellIdentifier];
  cell.contentView.backgroundColor = [UIColor whiteColor];
  // Checkmark outline
  CGFloat padding   = 20.0f;
  CGFloat imageSize = 20.0f;
  UIImageView *imageView = (UIImageView *) [cell.contentView viewWithTag: 
    8888];
  if (!imageView) {
    imageView = [UIImageView new];
    // Need 0.75 instead of 0.5 to push it down further midway
    imageView.frame = CGRectMake(
      tableView.frame.size.width - (imageSize + padding), 
        (58.0f - imageSize) * 0.5f, imageSize, imageSize);
    imageView.tag   = 8888;
    [cell.contentView addSubview: imageView];
  }
  static NSString *HeaderTitleCellIdentifier = @"HeaderTitleCellIdentifier";
  OMBHeaderTitleCell *headerTitleCell =
  [tableView dequeueReusableCellWithIdentifier: HeaderTitleCellIdentifier];
  if (!headerTitleCell)
    headerTitleCell = [[OMBHeaderTitleCell alloc] initWithStyle:
                       UITableViewCellStyleDefault reuseIdentifier: HeaderTitleCellIdentifier];
  
  // Pets
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      [imageView removeFromSuperview];
      headerTitleCell.titleLabel.text = @"Pets Allowed";
      return headerTitleCell;
      
    } else {
      
      BOOL value = NO;
      if (indexPath.row == 1) {
        cell.textLabel.text = @"Dogs";
        if (residence.dogs)
          value = YES;
      }
      else if (indexPath.row == 2) {
        cell.textLabel.text = @"Cats";
        if (residence.cats)
          value = YES;
      }
      else if (indexPath.row == 3){
        [imageView removeFromSuperview];
        cell.textLabel.text = @"None";
        if(!residence.dogs && !residence.cats)
          value = YES;
      }
      if (value) {
        cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
                                              size: 15];
        cell.textLabel.textColor = [UIColor textColor];
        imageView.alpha = 1.0f;
        imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
      }
      else {
        cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
                                              size: 15];
        cell.textLabel.textColor = [UIColor grayMedium];
        imageView.alpha = 0.2f;
        imageView.image = [UIImage imageNamed: @"checkmark_outline.png"];
      }
    }
  }
  // Amenities
  else if (indexPath.section == 1) {
    
    if (indexPath.row == 0) {
      [imageView removeFromSuperview];
      headerTitleCell.titleLabel.text = @"Amenities";
      return headerTitleCell;
    }
    
    NSString *string = [[OMBResidence defaultListOfAmenities] objectAtIndex:
                        indexPath.row - 1];
    cell.textLabel.text = [string capitalizedString];
    int value = [[residence.amenities objectForKey: string] intValue];
    if (value) {
      cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
                                            size: 15];
      cell.textLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
    else {
      cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
                                            size: 15];
      cell.textLabel.textColor = [UIColor grayMedium];
      imageView.alpha = 0.2f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline.png"];
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Pets
  if (section == 0){
    // +2 for header and none option
    return 1 + 2 + 1;
  }
  // Amenities
  else if (section == 1) {
    // +1 for header
    return 1 + [[OMBResidence defaultListOfAmenities] count];
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  BOOL reload = NO;
  // Pets
  if (indexPath.section == 0) {
    // Dogs
    if (indexPath.row == 1) {
      reload = YES;
      residence.dogs = !residence.dogs;
    }
    // Cats
    else if (indexPath.row == 2) {
      reload = YES;
      residence.cats = !residence.cats;
    }
    // None
    else if (indexPath.row == 3) {
      reload = YES;
      residence.cats = residence.dogs = NO;
    }
  }
  // Amenities
  else if (indexPath.section == 1) {
    if(indexPath.row){
      reload = YES;
      NSString *string = [[OMBResidence defaultListOfAmenities] objectAtIndex:
                        (indexPath.row - 1)];
      int value = [[residence.amenities objectForKey: string] intValue];
      int newValue = 0;
      if (value) {
        newValue = 0;
      }
      else {
        newValue = 1;
      }
      [residence.amenities setObject: [NSNumber numberWithInt: newValue]
                            forKey: string];
    }
  }
//  if(reload)
//    [tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation:
//     UITableViewRowAnimationNone];
  [tableView reloadData];
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  if((indexPath.section == 0 || indexPath.section == 1)
     && indexPath.row == 0)
    return 44.0f;
  
  return 58.0f;
}

@end
