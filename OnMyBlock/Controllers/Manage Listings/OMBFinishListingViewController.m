//
//  OMBFinishListingViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingViewController.h"

#import "OMBFinishListingAddressViewController.h"
#import "OMBFinishListingAmenitiesViewController.h"
#import "OMBFinishListingDescriptionViewController.h"
#import "OMBFinishListingOtherDetailsViewController.h"
#import "OMBFinishListingPhotosViewController.h"
#import "OMBGradientView.h"
#import "OMBMapViewController.h"
#import "OMBResidence.h"
#import "UIColor+Extensions.h"

@implementation OMBFinishListingViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;

  self.screenName = self.title = @"Finish Listing";

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Preview" 
      style: UIBarButtonItemStylePlain target: self action: @selector(preview)];

  self.view.backgroundColor  = [UIColor clearColor];
  [self setupForTable];
  self.table.backgroundColor = [UIColor clearColor];

  CGFloat visibleImageHeight = screen.size.height * 
    PropertyInfoViewImageHeightPercentage;
  CGFloat headerImageHeight = 44.0f + visibleImageHeight + 44.0f;

  // Table header view
  UIView *headerView = [UIView new];
  headerView.frame = CGRectMake(0.0f, 0.0f, 
    screen.size.width, headerImageHeight - 44.0f);
  self.table.tableHeaderView = headerView;

  // Background image
  headerImageOffsetY = 20.0f;
  headerImageView = [UIImageView new];
  headerImageView.image =
    [UIImage imageNamed: @"intro_still_image_slide_2_background.jpg"];  
  headerImageView.frame = CGRectMake(0.0f, headerImageOffsetY,
    screen.size.width, headerImageHeight);
  [self.view insertSubview: headerImageView belowSubview: self.table];
  // Gradient
  headerImageViewGradient = [[OMBGradientView alloc] init];
  headerImageViewGradient.colors = @[
    [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.0],
      [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.3f]];
  headerImageViewGradient.frame = headerImageView.frame;
  [self.view insertSubview: headerImageViewGradient belowSubview: self.table];

  // Camera view for add photo button
  cameraView = [UIView new];
  cameraView.frame = CGRectMake(0.0f, 20.0f + 44.0f,
    headerView.frame.size.width, 
      headerView.frame.size.height - (20.0f + 44.0f));
  [self.view insertSubview: cameraView belowSubview: self.table];
  CGFloat cameraImageSize = visibleImageHeight * 0.3f;
  // Camera icon
  UIImageView *cameraImageView = [UIImageView new];
  cameraImageView.frame = CGRectMake(
    (cameraView.frame.size.width - cameraImageSize) * 0.5, 
      (cameraView.frame.size.height - cameraImageSize) * 0.5, 
        cameraImageSize, cameraImageSize);
  cameraImageView.image = [UIImage imageNamed: @"camera_icon.png"];
  [cameraView addSubview: cameraImageView];
  // Add Photos label
  UILabel *addPhotosLabel = [UILabel new];
  addPhotosLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  addPhotosLabel.frame = CGRectMake(0.0f, 
    cameraImageView.frame.origin.y + cameraImageView.frame.size.height, 
      cameraView.frame.size.width, 27.0f);
  addPhotosLabel.text = @"Add Photos";
  addPhotosLabel.textAlignment = NSTextAlignmentCenter;
  addPhotosLabel.textColor = [UIColor whiteColor];
  [cameraView addSubview: addPhotosLabel];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // [self tableView: self.table didSelectRowAtIndexPath: 
  //   [NSIndexPath indexPathForRow: 0 inSection: 0]];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGFloat y = scrollView.contentOffset.y;
  CGFloat adjustment = y / 3.0f;
  // Adjust the header image view
  CGRect headerImageFrame = headerImageView.frame;  
  headerImageFrame.origin.y = headerImageOffsetY - adjustment;
  headerImageView.frame = headerImageFrame;
  headerImageViewGradient.frame = headerImageFrame;
  // Adjust the camera view
  CGRect cameraViewRect = cameraView.frame;
  cameraViewRect.origin.y = 20.0f + 44.0f - adjustment;
  cameraView.frame = cameraViewRect;
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
      reuseIdentifier: CellIdentifier];
  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  cell.detailTextLabel.text = @"";
  cell.detailTextLabel.textColor = [UIColor grayMedium];
  cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  cell.textLabel.textColor = cell.detailTextLabel.textColor;
  // Checkmark image view
  CGFloat padding   = 20.0f;
  CGFloat imageSize = 20.0f;
  UIImageView *imageView = (UIImageView *) [cell.contentView viewWithTag: 8888];
  if (!imageView) {
    imageView = [UIImageView new];
    // Need 0.75 instead of 0.5 to push it down further midway
    imageView.frame = CGRectMake(
      tableView.frame.size.width - (imageSize + padding), 
        (58.0f - imageSize) * 0.5f, imageSize, imageSize);
    imageView.tag   = 8888;
    [cell.contentView addSubview: imageView];
  }
  imageView.alpha = 0.2f;
  imageView.image = [UIImage imageNamed: @"checkmark_outline.png"];
  NSString *string = @"";
  if (indexPath.row == 0) {
    // cell.detailTextLabel.text = @"0/3";
    string = @"Photos";
  }
  else if (indexPath.row == 1) {
    // cell.detailTextLabel.text = @"0/1";
    cell.textLabel.textColor = [UIColor textColor];
    string = @"Description";
    imageView.alpha = 1.0f;
    imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
  }
  else if (indexPath.row == 2) {
    // cell.detailTextLabel.text = @"2/5";
    string = @"Rent / Auction Details";
  }
  else if (indexPath.row == 3) {
    cell.textLabel.textColor = [UIColor textColor];
    string = @"275 Josselyn Lane";
    // Checkmark
    imageView.alpha = 1.0f;
    imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
  }
  else if (indexPath.row == 4) {
    // cell.detailTextLabel.text = @"0/1";
    string = @"Amenities";
  }
  else if (indexPath.row == 5) {
    // cell.detailTextLabel.text = @"4/6";
    string = @"Other Details";
  }
  cell.textLabel.text = string;
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Subclasses implement this
  return 6;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Photos
  if (indexPath.row == 0) {
    [self.navigationController pushViewController:
      [[OMBFinishListingPhotosViewController alloc] initWithResidence: 
        residence] animated: YES];
  }
  // Description
  else if (indexPath.row == 1) {
    [self.navigationController pushViewController:
      [[OMBFinishListingDescriptionViewController alloc] initWithResidence: 
        residence] animated: YES];
  }
  // Address
  else if (indexPath.row == 3) {
    [self.navigationController pushViewController:
      [[OMBFinishListingAddressViewController alloc] initWithResidence: 
        residence] animated: YES];
  }
  // Amenities
  else if (indexPath.row == 4) {
    [self.navigationController pushViewController:
      [[OMBFinishListingAmenitiesViewController alloc] initWithResidence: 
        residence] animated: YES];
  }
  // Other Details
  else if (indexPath.row == 5) {
    [self.navigationController pushViewController:
      [[OMBFinishListingOtherDetailsViewController alloc] initWithResidence: 
        residence] animated: YES];
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Subclasses implement this
  return 58.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) preview
{
  NSLog(@"PREVIEW");
}

@end
