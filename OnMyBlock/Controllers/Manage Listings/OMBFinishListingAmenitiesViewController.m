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
#import "UIColor+Extensions.h"

@implementation OMBFinishListingAmenitiesViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  self.screenName = self.title = @"Amenities";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

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
  // Amenities
  if (indexPath.section == 0) {
    NSString *string = [[OMBResidence defaultListOfAmenities] objectAtIndex: 
      indexPath.row];
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
  // Pets
  else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      cell.contentView.backgroundColor = tableView.backgroundColor;
      cell.textLabel.text  = @"";
      [imageView removeFromSuperview];
    }
    else {
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
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Amenities
  if (section == 0)
    return [[OMBResidence defaultListOfAmenities] count];
  // Pets
  else if (section == 1) {
    // 1 for the spacing
    return 1 + 2;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Amenities
  if (indexPath.section == 0) {
    NSString *string = [[OMBResidence defaultListOfAmenities] objectAtIndex: 
      indexPath.row];
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
  // Pets
  else if (indexPath.section == 1) {
    // Dogs
    if (indexPath.row == 1) {
      residence.dogs = !residence.dogs;
    }
    // Cats
    else if (indexPath.row == 2) {
      residence.cats = !residence.cats;
    }
  }
  [tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation:
    UITableViewRowAnimationNone];
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 58.0f;
}

@end
