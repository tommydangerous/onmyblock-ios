//
//  OMBManageListingDetailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBManageListingDetailViewController.h"

#import "OMBCenteredImageView.h"
#import "OMBFinishListingViewController.h"
#import "OMBImageOneLabelCell.h"
#import "OMBManageListingDetailEditCell.h"
#import "OMBManageListingDetailStatusCell.h"
#import "OMBResidence.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBResidenceImagesConnection.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Resize.h"

@interface OMBManageListingDetailViewController ()
{
  OMBCenteredImageView *backgroundImageView;
  UIImage *editCellImage;
  UIImage *previewCellImage;
  OMBResidence *residence;
  UIImage *statusCellImage;
}

@end

@implementation OMBManageListingDetailViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  editCellImage = [UIImage image: [UIImage imageNamed: @"house_icon.png"]
    size: [OMBManageListingDetailEditCell sizeForImage]];
  previewCellImage = [UIImage image: [UIImage imageNamed: @"eye_icon_black.png"]
    size: [OMBImageOneLabelCell sizeForImage]];
  statusCellImage = [UIImage image:
    [UIImage imageNamed: @"light_bulb_icon_black.png"]
      size: [OMBImageOneLabelCell sizeForImage]];
  residence = object;

  self.title = [residence titleOrAddress];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.table.separatorInset = UIEdgeInsetsMake(0.0f, OMBPadding,
    0.0f, OMBPadding);

  CGRect screen = [self screen];
  backgroundImageView = [[OMBCenteredImageView alloc] init];
  backgroundImageView.frame = CGRectMake(0.0f, 0.0f,
    screen.size.width, screen.size.height * 0.4f);
  [self setupBackgroundWithView: backgroundImageView
    startingOffsetY: OMBPadding + OMBStandardHeight];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [self updateBackgroundImage];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  if (section == OMBManageListingDetailSectionTop) {
    if (row == OMBManageListingDetailSectionTopRowEdit) {
      static NSString *EditID = @"EditID";
      OMBManageListingDetailEditCell *cell =
        [tableView dequeueReusableCellWithIdentifier: EditID];
      if (!cell)
        cell = [[OMBManageListingDetailEditCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: EditID];
      cell.bottomLabel.text = [NSString stringWithFormat: @"%@ - %i bd / %i ba",
        [NSString numberToCurrencyString: residence.minRent],
          (int) residence.bedrooms, (int) residence.bathrooms];
      cell.middleLabel.text = [NSString stringWithFormat: @"%@, %@",
        [residence.city capitalizedString], [residence stateFormattedString]];
      cell.topLabel.text = [residence.address capitalizedString];
      [cell setImage: editCellImage];
      return cell;
    }
    else if (row == OMBManageListingDetailSectionTopRowPreview) {
      static NSString *PreviewID = @"PreviewID";
      OMBImageOneLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:
        PreviewID];
      if (!cell) {
        cell = [[OMBImageOneLabelCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: PreviewID];
      }
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      [cell setFont: [UIFont normalTextFontBold]];
      [cell setImage: previewCellImage text: @"Preview Listing"];
      [cell setImageViewAlpha: 0.3f];
      [cell setImageViewCircular: NO];
      return cell;
    }
    else if (row == OMBManageListingDetailSectionTopRowStatus) {
      static NSString *StatusID = @"StatusID";
      OMBManageListingDetailStatusCell *cell =
        [tableView dequeueReusableCellWithIdentifier: StatusID];
      if (!cell)
        cell = [[OMBManageListingDetailStatusCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: StatusID];
      cell.separatorInset = UIEdgeInsetsMake(0.0f,
        tableView.frame.size.width, 0.0f, 0.0f);
      cell.textFieldLabel.text = @"Listing Status";
      [cell setImage: statusCellImage];
      return cell;
    }
  }
  return [UITableViewCell new];
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Edit
  // Preview
  // Listing Status
  return 3;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  if (section == OMBManageListingDetailSectionTop) {
    if (row == OMBManageListingDetailSectionTopRowEdit) {
      return [OMBManageListingDetailEditCell heightForCell];
    }
    else if (row == OMBManageListingDetailSectionTopRowPreview) {
      return [OMBImageOneLabelCell heightForCell];
    }
    else if (row == OMBManageListingDetailSectionTopRowStatus) {
      return [OMBManageListingDetailStatusCell heightForCell];
    }
  }
  return 0.0f;
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  if (section == OMBManageListingDetailSectionTop) {
    UIViewController *vc;
    if (row == OMBManageListingDetailSectionTopRowEdit) {
      vc = [[OMBFinishListingViewController alloc] initWithResidence:
        residence];
    }
    else if (row == OMBManageListingDetailSectionTopRowPreview) {
      vc = [[OMBResidenceDetailViewController alloc] initWithResidence:
        residence];
    }
    if (vc)
      [self.navigationController pushViewController: vc animated: YES];
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) updateBackgroundImage
{
  // Download the residence's images
  OMBResidenceImagesConnection *conn =
    [[OMBResidenceImagesConnection alloc] initWithResidence: residence];
  conn.completionBlock = ^(NSError *error) {
    // Add the cover photo
    if (!backgroundImageView.image)
      [residence setImageForCenteredImageView: backgroundImageView
        withURL: residence.coverPhotoURL completion: nil];
  };
  [conn start];
}

@end
