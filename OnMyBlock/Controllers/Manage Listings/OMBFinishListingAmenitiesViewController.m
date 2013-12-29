//
//  OMBFinishListingAmenitiesViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingAmenitiesViewController.h"

#import "UIColor+Extensions.h"

@implementation OMBFinishListingAmenitiesViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  self.screenName = self.title = @"Amenities";

  amenitiesArray = @[
    @"air conditioning",
    @"backyard",
    @"central heating",
    @"dishwasher",
    @"fence",
    @"front yard",
    @"garbage disposal",
    @"gym",
    @"hard floors",
    @"newly remodeled",
    @"patio/balcony",
    @"pool",
    @"storage",
    @"washer/dryer" 
  ];

  amenities = [NSMutableDictionary dictionary];
  for (NSString *string in amenitiesArray) {
    [amenities setObject: [NSNumber numberWithInt: 0] forKey: string];
  }

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setupForTable];
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
  if (indexPath.section == 0) {
    NSString *string = [amenitiesArray objectAtIndex: indexPath.row];
    cell.textLabel.text = [string capitalizedString];
    int value = [[amenities objectForKey: string] intValue];
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
  else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      cell.contentView.backgroundColor = tableView.backgroundColor;
      cell.textLabel.text  = @"";
      [imageView removeFromSuperview];
    }
    else if (indexPath.row == 1) {
      cell.textLabel.text = @"Dogs";
    }
    else if (indexPath.row == 2) {
      cell.textLabel.text = @"Cats";
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Amenities
  if (section == 0)
    return [amenitiesArray count];
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
  if (indexPath.section == 0) {
    NSString *string = [amenitiesArray objectAtIndex: indexPath.row];
    int value = [[amenities objectForKey: string] intValue];
    if (value) {
      [amenities setObject: [NSNumber numberWithInt: 0] forKey: string];
    }
    else {
      [amenities setObject: [NSNumber numberWithInt: 1] forKey: string];
    }
    [tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation:
      UITableViewRowAnimationNone];
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 58.0f;
}

@end
