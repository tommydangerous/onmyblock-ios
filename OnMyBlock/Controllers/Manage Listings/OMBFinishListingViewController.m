//
//  OMBFinishListingViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingViewController.h"

#import "AMBlurView.h"
#import "OMBCenteredImageView.h"
#import "OMBFinishListingAddressViewController.h"
#import "OMBFinishListingAmenitiesViewController.h"
#import "OMBFinishListingDescriptionViewController.h"
#import "OMBFinishListingOtherDetailsViewController.h"
#import "OMBFinishListingPhotosViewController.h"
#import "OMBFinishListingRentAuctionDetailsViewController.h"
#import "OMBFinishListingTitleViewController.h"
#import "OMBGradientView.h"
#import "OMBMapViewController.h"
#import "OMBResidence.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBResidenceImage.h"
#import "OMBResidenceImagesConnection.h"
#import "OMBResidenceUploadImageConnection.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

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

  numberOfSteps = 6;
  numberOfStepsCompleted = 3;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;

  UIBarButtonItem *previewBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Preview" 
      style: UIBarButtonItemStylePlain target: self action: @selector(preview)];
  [previewBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: [UIFont boldSystemFontOfSize: 17]
  } forState: UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = previewBarButtonItem;

  self.view.backgroundColor = [UIColor clearColor];
  [self setupForTable];
  self.table.backgroundColor = [UIColor clearColor];

  // Publish Now view
  publishNowView = [[AMBlurView alloc] init];
  publishNowView.blurTintColor = [UIColor blue];
  publishNowView.frame = CGRectMake(0.0f, screen.size.height - 58.0f,
    screen.size.width, 58.0f);
  [self.view addSubview: publishNowView];
  // Publish Now button
  publishNowButton = [UIButton new];
  publishNowButton.frame = CGRectMake(0.0f, 0.0f, screen.size.width,
    publishNowView.frame.size.height);
  publishNowButton.titleLabel.font = 
    [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  [publishNowButton addTarget: self action: @selector(publishNow)
    forControlEvents: UIControlEventTouchUpInside];
  [publishNowButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueHighlighted]] 
      forState: UIControlStateHighlighted];
  [publishNowButton setTitle: @"6 More Steps" forState: UIControlStateNormal];
  [publishNowButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [publishNowView addSubview: publishNowButton];

  CGFloat visibleImageHeight = screen.size.height * 
    PropertyInfoViewImageHeightPercentage;
  CGFloat headerImageHeight = 44.0f + visibleImageHeight + 44.0f;

  // Table header view
  UIView *headerView = [UIView new];
  headerView.frame = CGRectMake(0.0f, 0.0f, 
    screen.size.width, headerImageHeight - 44.0f);
  UITapGestureRecognizer *tap = 
    [[UITapGestureRecognizer alloc] initWithTarget: self
      action: @selector(addPhotos)];
  [headerView addGestureRecognizer: tap];
  self.table.tableHeaderView = headerView;

  // Table footer view
  UIView *footerView = [UIView new];
  footerView.frame = CGRectMake(0.0f, 0.0f, 
    screen.size.width, publishNowView.frame.size.height);
  self.table.tableFooterView = footerView;

  // Background image
  headerImageOffsetY = padding;
  headerImageView = [[OMBCenteredImageView alloc] init];
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
  cameraView.frame = CGRectMake(0.0f, padding + 44.0f,
    headerView.frame.size.width, 
      headerView.frame.size.height - (padding + 44.0f));
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

  // Steps Remaining view
  // stepsRemainingView = [[AMBlurView alloc] init];
  // stepsRemainingView.blurTintColor = [UIColor grayVeryLight];
  // stepsRemainingView.frame = CGRectMake(0.0f, padding + 44.0f,
  //   screen.size.width, padding * 0.5f);
  // [self.view addSubview: stepsRemainingView];
  // // Bottom border
  // UIView *stepsBottomBorder = [UIView new];
  // stepsBottomBorder.backgroundColor = [UIColor grayMedium];
  // stepsBottomBorder.frame = CGRectMake(0.0f, 
  //   stepsRemainingView.frame.size.height - 0.5f, 
  //     stepsRemainingView.frame.size.width, 0.5f);

  // CGFloat stepViewWidth = screen.size.width / numberOfSteps;
  // stepViews = [NSMutableArray array];
  // for (int i = 0; i < numberOfSteps; i++) {
  //   AMBlurView *stepView = [[AMBlurView alloc] init];
  //   stepView.frame = CGRectMake(i * stepViewWidth, 0.0f,
  //     stepViewWidth, stepsRemainingView.frame.size.height);
  //   // Left border
  //   if (i > 0) {
  //     CALayer *leftBorder = [CALayer layer];
  //     leftBorder.backgroundColor = stepsBottomBorder.backgroundColor.CGColor;
  //     leftBorder.frame = CGRectMake(0.0f, 0.0f, 
  //       stepsBottomBorder.frame.size.height, stepView.frame.size.height);
  //     [stepView.layer addSublayer: leftBorder];
  //   }
  //   [stepViews addObject: stepView];
  //   [stepsRemainingView addSubview: stepView];
  // }
  // // Add it in front of everything
  // [stepsRemainingView addSubview: stepsBottomBorder];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // Download the residence's images
  OMBResidenceImagesConnection *conn = 
    [[OMBResidenceImagesConnection alloc] initWithResidence: residence];
  conn.completionBlock = ^(NSError *error) {
    // Add the cover photo
    headerImageView.image = [residence coverPhoto];
    // Update the Photos (X) count
    [self reloadPhotosRow];
  };
  [conn start];

  // Image
  if ([residence coverPhoto])
    headerImageView.image = [residence coverPhoto];
  else
    [headerImageView clearImage];

  [self reloadPhotosRow];

  // for (int i = 0; i < numberOfSteps; i++) {
  //   AMBlurView *stepView = [stepViews objectAtIndex: i];
  //   if (i < numberOfStepsCompleted) {
  //     stepView.blurTintColor = [UIColor blue];
  //   }
  //   else {
  //     stepView.blurTintColor = [UIColor clearColor];
  //   }
  // }

  // [self tableView: self.table didSelectRowAtIndexPath: 
  //   [NSIndexPath indexPathForRow: 5 inSection: 0]];
}

#pragma mark - Protocol

#pragma mark - Protocol ELCImagePickerControllerDelegate

- (void) elcImagePickerController: (ELCImagePickerController *) picker
didFinishPickingMediaWithInfo: (NSArray *) info
{
  for (NSDictionary *dict in info) {
    [self createResidenceImageWithDictionary: dict];
  }
  [self.navigationController pushViewController:
    [[OMBFinishListingPhotosViewController alloc] initWithResidence: residence]
      animated: NO];
  [picker dismissViewControllerAnimated: YES completion: nil];
}

- (void) elcImagePickerControllerDidCancel: (ELCImagePickerController *) picker
{
  [picker dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Protocol UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  UIImagePickerController *cameraImagePicker =
    [[UIImagePickerController alloc] init];
  cameraImagePicker.delegate = self;

  // Select multiple images
  ELCImagePickerController *libraryImagePicker = 
    [[ELCImagePickerController alloc] initImagePicker];
  libraryImagePicker.imagePickerDelegate = self;
  // Set the maximum number of images to select, defaults to 4
  libraryImagePicker.maximumImagesCount = 4;
  // Only return the fullScreenImage, not the fullResolutionImage
  libraryImagePicker.returnsOriginalImage = NO;

  // Take Photo
  if (buttonIndex == 0) {
    // Show camera
    if ([UIImagePickerController isSourceTypeAvailable:
      UIImagePickerControllerSourceTypeCamera]) {
      
      cameraImagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
      [self presentViewController: cameraImagePicker animated: YES 
        completion: nil];
    }
    // Default to the library
    else {
      [self presentViewController: libraryImagePicker animated: YES
        completion: nil];
    }
  }
  // Choose existing
  else if (buttonIndex == 1) {
    [self presentViewController: libraryImagePicker animated: YES
        completion: nil];
  }
}

#pragma mark - Protocol UIImagePickerControllerDelegate

- (void) imagePickerController: (UIImagePickerController *) picker 
didFinishPickingMediaWithInfo: (NSDictionary *) info
{
  [self createResidenceImageWithDictionary: info];

  [self.navigationController pushViewController:
    [[OMBFinishListingPhotosViewController alloc] initWithResidence: residence]
      animated: NO];
  [picker dismissViewControllerAnimated: YES completion: nil];
}

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
  // Photos
  if (indexPath.row == 0) {
    // cell.detailTextLabel.text = @"0/3";
    string = @"Photos";
    if ([residence.images count]) {
      string = [string stringByAppendingString: 
        [NSString stringWithFormat: @" (%i)", [residence.images count]]];
    }
  }
  // Title
  else if (indexPath.row == 1) {
    string = @"Title";
  }
  // Description
  else if (indexPath.row == 2) {
    // cell.detailTextLabel.text = @"0/1";
    cell.textLabel.textColor = [UIColor textColor];
    string = @"Description";
    imageView.alpha = 1.0f;
    imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
  }
  // Rent / Auction Details
  else if (indexPath.row == 3) {
    // cell.detailTextLabel.text = @"2/5";
    string = @"Rent / Auction Details";
  }
  // Address
  else if (indexPath.row == 4) {
    string = @"Select Address";
    // Checkmark
    imageView.alpha = 1.0f;
    imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
  }  
  // Additional Details
  else if (indexPath.row == 5) {
    // cell.detailTextLabel.text = @"4/6";
    string = @"Additional Details";
  }
  cell.textLabel.text = string;
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Photos
  // Title
  // Description
  // Rent / Auction Details
  // Address
  // Other Details
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
  // Title
  else if (indexPath.row == 1) {
    [self.navigationController pushViewController:
      [[OMBFinishListingTitleViewController alloc] initWithResidence: 
        residence] animated: YES];
  }
  // Description
  else if (indexPath.row == 2) {
    [self.navigationController pushViewController:
      [[OMBFinishListingDescriptionViewController alloc] initWithResidence: 
        residence] animated: YES];
  }
  // Rent / Auction Details
  else if (indexPath.row == 3) {
    [self.navigationController pushViewController:
      [[OMBFinishListingRentAuctionDetailsViewController alloc] 
        initWithResidence: residence] animated: YES]; 
  }
  // Address
  else if (indexPath.row == 4) {
    [self.navigationController pushViewController:
      [[OMBFinishListingAddressViewController alloc] initWithResidence: 
        residence] animated: YES];
  }
  // Additional Details
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
  return 58.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addPhotos
{
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil 
    delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil
      otherButtonTitles: @"Take Photo", @"Choose Existing", nil];
  [self.view addSubview: actionSheet];
  [actionSheet showInView: self.view];
}

- (void) createResidenceImageWithDictionary: (NSDictionary *) dictionary
{
  NSString *absoluteString = [NSString stringWithFormat: @"%f",
    [[NSDate date] timeIntervalSince1970]];
  UIImage *image = [dictionary objectForKey: 
    UIImagePickerControllerOriginalImage];
  int position = 0;
  NSArray *array = [residence imagesArray];
  if ([array count]) {
    OMBResidenceImage *previousResidenceImage = [array objectAtIndex:
      [array count] - 1];
    position = previousResidenceImage.position + 1;
  }

  OMBResidenceImage *residenceImage = [[OMBResidenceImage alloc] init];
  residenceImage.absoluteString = absoluteString;
  residenceImage.image    = image;
  residenceImage.position = position;
  residenceImage.uid      = -999 + arc4random_uniform(100);

  [residence addResidenceImage: residenceImage];

  // Upload image
  OMBResidenceUploadImageConnection *conn = 
    [[OMBResidenceUploadImageConnection alloc] initWithResidence: residence 
      residenceImage: residenceImage];
  [conn start];
}

- (void) preview
{
  NSLog(@"PREVIEW");
  [self.navigationController pushViewController:
    [[OMBResidenceDetailViewController alloc] initWithResidence: residence]
      animated: YES];
}

- (void) publishNow
{
  NSLog(@"PUBLISH NOW");
}

- (void) reloadPhotosRow
{
  [self.table reloadRowsAtIndexPaths: 
    @[[NSIndexPath indexPathForRow: 0 inSection: 0]]
      withRowAnimation: UITableViewRowAnimationNone];
}

@end
