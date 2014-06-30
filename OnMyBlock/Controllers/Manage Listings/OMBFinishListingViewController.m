//
//  OMBFinishListingViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingViewController.h"

#import "AMBlurView.h"
#import "LEffectLabel.h"
#import "NSUserDefaults+OnMyBlock.h"
#import "OMBActivityView.h"
#import "OMBAlertViewBlur.h"
#import "OMBCenteredImageView.h"
#import "OMBFinishListingAddressViewController.h"
#import "OMBFinishListingAmenitiesViewController.h"
#import "OMBFinishListingDescriptionViewController.h"
#import "OMBFinishListingLeaseDetailsViewController.h"
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
#import "OMBResidencePublishConnection.h"
#import "OMBResidenceUploadImageConnection.h"
#import "OMBResidenceUpdateConnection.h"
#import "OMBTableViewCell.h"
#import "OMBTemporaryResidence.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

float const photoViewImageHeightPercentage = 0.32;

@implementation OMBFinishListingViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  numberOfSteps = 7;
  residence = object;

  if ([residence isKindOfClass: [OMBTemporaryResidence class]]) {
    self.title = @"Finish Listing";
  }
  else
    self.title = @"Edit Listing";

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadView
{
  [super loadView];

  CGRect screen   = [self screen];
  CGFloat padding = OMBPadding;

  previewBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Preview"
      style: UIBarButtonItemStylePlain target: self action: @selector(preview)];
  [previewBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: [UIFont boldSystemFontOfSize: 17]
  } forState: UIControlStateNormal];
  unlistBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Unlist"
      style: UIBarButtonItemStylePlain target: self action: @selector(unlist)];
  [unlistBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: [UIFont boldSystemFontOfSize: 17]
  } forState: UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = previewBarButtonItem;

  self.view.backgroundColor = [UIColor clearColor];
  [self setupForTable];
  self.table.backgroundColor = [UIColor clearColor];
  self.table.separatorInset  = UIEdgeInsetsMake(0.0f, padding, 0.0f, padding);

  // Publish Now view
  CGFloat publishHeight = OMBStandardButtonHeight;
  publishNowView = [[AMBlurView alloc] init];
  publishNowView.blurTintColor = [UIColor blue];
  publishNowView.frame = CGRectMake(0.0f,
    screen.size.height - publishHeight, screen.size.width,
      publishHeight);
  [self.view addSubview: publishNowView];
  // Publish Now button
  publishNowButton = [UIButton new];
  publishNowButton.frame = CGRectMake(0.0f, 0.0f, screen.size.width,
    publishNowView.frame.size.height);
  publishNowButton.titleLabel.font = [UIFont mediumTextFontBold];
  [publishNowButton addTarget: self action: @selector(publishNow)
    forControlEvents:UIControlEventTouchUpInside];
  [publishNowButton setBackgroundImage:
    [UIImage imageWithColor: [UIColor blueHighlightedAlpha: 0.3f]]
      forState: UIControlStateHighlighted];
  [publishNowButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [publishNowView addSubview: publishNowButton];

  // Effect label
  effectLabel = [[LEffectLabel alloc] init];
  effectLabel.effectColor = [UIColor grayMedium];
  effectLabel.effectDirection = EffectDirectionLeftToRight;
  effectLabel.font = [UIFont mediumTextFontBold];
  effectLabel.frame = publishNowButton.frame;
  effectLabel.sizeToFit = NO;
  effectLabel.text = @"Publish Now";
  effectLabel.textColor = [UIColor whiteColor];
  effectLabel.textAlignment = NSTextAlignmentCenter;
  [publishNowView insertSubview: effectLabel
    belowSubview: publishNowButton];

  // Unlist view
  unlistView = [[AMBlurView alloc] init];
  unlistView.blurTintColor = [UIColor grayVeryLight];
  unlistView.frame = publishNowView.frame;
  [self.view addSubview: unlistView];
  // Unlist button
  unlistButton = [UIButton new];
  unlistButton.frame = publishNowButton.frame;
  unlistButton.titleLabel.font = publishNowButton.titleLabel.font;
  [unlistButton addTarget: self action: @selector(unlist)
    forControlEvents: UIControlEventTouchUpInside];
  [unlistButton setBackgroundImage:
    [UIImage imageWithColor: [UIColor grayUltraLight]]
      forState: UIControlStateHighlighted];
  [unlistButton setTitle: @"Unlist" forState: UIControlStateNormal];
  [unlistButton setTitleColor: [UIColor grayMedium]
    forState: UIControlStateNormal];
  [unlistView addSubview: unlistButton];

  CGFloat visibleImageHeight = screen.size.height *
    photoViewImageHeightPercentage; // ... * 0.32
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

  // Check mark
  CGFloat imageSize = 20.0f;
  UIImageView *imageView = [UIImageView new];
  imageView.frame = CGRectMake(headerImageView.frame.size.width - padding - imageSize,
                                 visibleImageHeight - padding, imageSize, imageSize);
  imageView.tag   = 8888;
  [headerImageView addSubview:imageView];
  imageView.alpha = 0.2f;
  imageView.image = [UIImage imageNamed: @"checkmark_outline.png"];

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

  activityView = [[OMBActivityView alloc] init];
  [self.view addSubview: activityView];

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

  // Alert view blur
  alertBlur = [[OMBAlertViewBlur alloc] init];
  _nextSection = NO;
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  __weak typeof (self) weakSelf = self;
  if ([residence coverPhoto]) {
    [headerImageView setImage: [residence coverPhoto]];
    [self verifyPhotos];
  }
  else if (residence.coverPhotoURL) {
    __weak typeof (headerImageView) weakImageView = headerImageView;
    [headerImageView.imageView setImageWithURL: residence.coverPhotoURL
      placeholderImage: nil options: SDWebImageRetryFailed completed:
        ^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
          if (image) {
            [weakImageView setImage: image];
          }
          [weakSelf verifyPhotos];
        }
      ];
  }
  else {
    // This will download the cover photo url
    // Then download the cover photo and set it
    [residence setImageForCenteredImageView: headerImageView withURL: nil
      completion: ^{
        [weakSelf verifyPhotos];
      }];
  }

  // Reload
  // Photos
  // [self reloadPhotosRow];
  // Title
  // [self reloadTitleRow];

  [self.table reloadData];

  // Calculate how many steps are left
  NSString *publishNowButtonTitle;
  if ([residence numberOfStepsLeft] > 0) {
    effectLabel.hidden = YES;
    publishNowButtonTitle = [residence statusString];
  }
  else {
    effectLabel.hidden = NO;
  }
  [publishNowButton setTitle: publishNowButtonTitle
    forState: UIControlStateNormal];
  [effectLabel performEffectAnimation];

  // If the residence is a temporary residence
  if ([residence isKindOfClass: [OMBTemporaryResidence class]]) {
    // self.navigationItem.rightBarButtonItem = previewBarButtonItem;
    publishNowView.hidden = NO;
    unlistView.hidden     = YES;
  }
  // If a residence
  else {
    publishNowView.hidden = unlistView.hidden = YES;
    UIView *footerView = [UIView new];
    footerView.frame = CGRectMake(0.0f, 0.0f,
      self.table.frame.size.width, 0.0f);
    self.table.tableFooterView = footerView;
  }
  if(_nextSection)
   [self nextIncompleteSection];
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
  cameraImagePicker.allowsEditing = YES;
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

#pragma mark - Protocol UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  if (buttonIndex == 0) {
    [[self userDefaults] permissionPushNotificationsSet: NO];
  }
  else if (buttonIndex == 1) {
    [[self userDefaults] permissionPushNotificationsSet: YES];
    [[self appDelegate] registerForPushNotifications];
  }
  [self hideAlertBlurAndPopController];
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
  CGFloat adjustment = y / 2.1f;
  // Adjust the header image view
  CGRect headerImageFrame = headerImageView.frame;
  headerImageFrame.origin.y = headerImageOffsetY - adjustment;
  [headerImageView setFrame: headerImageFrame redrawImage: NO];
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
  OMBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell) {
    cell = [[OMBTableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
      reuseIdentifier: CellIdentifier];
    cell.basicTextLabel.frame = CGRectMake(OMBPadding, 0.0f,
      tableView.frame.size.width - (OMBPadding * 2), OMBStandardButtonHeight);
  }
  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  cell.detailTextLabel.text      = @"";
  cell.detailTextLabel.textColor = [UIColor grayMedium];
  cell.basicTextLabel.font       = [UIFont normalTextFontBold];
  cell.basicTextLabel.textColor  = cell.detailTextLabel.textColor;
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

  // Title
  if (indexPath.row == 0) {
    string = @"Title";
    if ([residence.title length]) {
      string = residence.title;
      cell.basicTextLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
  }
  // Description
  else if (indexPath.row == 1) {
    string = @"Description";
    if ([residence.description length]) {
      cell.basicTextLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
  }
  // Rent / Auction Details
  else if (indexPath.row == 2) {
    // string = @"Rent / Auction Details";
    string = @"Rent Details";
    if (residence.minRent) {
      cell.basicTextLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
  }
  // Address
  else if (indexPath.row == 3) {
    string = @"Select Address";
    if ([residence.address length] && [residence.city length] &&
        [residence.state length] && [residence.zip length]) {
      string = [residence.address capitalizedString];
      cell.basicTextLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
  }
  // Lease Details
  else if (indexPath.row == 4) {
    string = @"Lease Details";
    if (residence.moveInDate) {
      cell.basicTextLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
  }
  // Listing Details
  else if (indexPath.row == 5) {
    string = @"Listing Details";
    if (residence.bedrooms) {
      cell.basicTextLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
  }
  // Pets & Amenities
  else if (indexPath.row == 6) {
    string = @"Amenities & Pets";
    cell.basicTextLabel.textColor = [UIColor textColor];
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
      0.0f, 0.0f);
    imageView.alpha = 1.0f;
    imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
  }
  cell.clipsToBounds  = YES;
  cell.basicTextLabel.text = string;
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // ! Photos
  // Title
  // Description
  // Rent / Auction Details
  // Address
  // Lease Details
  // Listing Details
  // Pets & Amenities
  return 7;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Title
  if (indexPath.row == 0) {
    OMBFinishListingTitleViewController *vc =
      [[OMBFinishListingTitleViewController alloc]
        initWithResidence: residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: YES];
  }
  // Description
  else if (indexPath.row == 1) {
    OMBFinishListingDescriptionViewController *vc =
      [[OMBFinishListingDescriptionViewController alloc]
        initWithResidence:residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: YES];
  }
  // Rent / Auction Details
  else if (indexPath.row == 2) {
    OMBFinishListingRentAuctionDetailsViewController *vc =
      [[OMBFinishListingRentAuctionDetailsViewController alloc]
        initWithResidence:residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: YES];
  }
  // Address
  else if (indexPath.row == 3) {
    OMBFinishListingAddressViewController *vc =
      [[OMBFinishListingAddressViewController alloc]
        initWithResidence: residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: YES];
    
  }
  // Lease Details
  else if (indexPath.row == 4) {
    OMBFinishListingLeaseDetailsViewController *vc =
      [[OMBFinishListingLeaseDetailsViewController alloc]
        initWithResidence:residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: YES];
  }
  // Listing Details
  else if (indexPath.row == 5) {
    OMBFinishListingOtherDetailsViewController *vc =
      [[OMBFinishListingOtherDetailsViewController alloc]
        initWithResidence:residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: YES];
  }
  // Pets & Amenities
  else if (indexPath.row == 6) {
    OMBFinishListingAmenitiesViewController *vc =
      [[OMBFinishListingAmenitiesViewController alloc]
        initWithResidence:residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: YES];
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return OMBStandardButtonHeight;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addPhotos
{
  if ([[residence imagesArray] count]) {
    [self.navigationController pushViewController:
      [[OMBFinishListingPhotosViewController alloc] initWithResidence:
        residence] animated: YES];
  }
  else {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
      delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil
        otherButtonTitles: @"Take Photo", @"Choose Existing", nil];
    [self.view addSubview: actionSheet];
    [actionSheet showInView: self.view];
  }
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

  CGSize newSize = CGSizeMake(640.0f, 320.0f);
  image = [UIImage image: image proportionatelySized: newSize];

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

- (void) hideAlertBlurAndPopController
{
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    alertBlur.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    if (finished) {
      [self.navigationController popViewControllerAnimated: YES];
      [alertBlur close];
    }
  }];
}

- (NSString *) incompleteStepString
{
  NSString *string;
  // Photos
  if (![residence.images count])
    string = @"Please upload at least 1 photo.";
  // Title
  else if (![residence.title length])
    string = @"Please give your place a title.";
  // Description
  else if (![residence.description length])
    string = @"Please write short description about your place.";
  // Rent / Auction Details
  else if (!residence.minRent)
    string = @"Please set a price for monthly rent.";
  // Address
  else if (![residence.address length] || ![residence.city length] ||
    ![residence.state length] || ![residence.zip length])
    string = @"Please specify an address for your place.";
  // Lease Details
  else if (!residence.moveInDate)
    string = @"Please set the move-in date.";
  // Listing Details
  else if (!residence.bedrooms)
    string = @"Please set the number of bedrooms.";
  return string;
}

- (void) nextIncompleteSection
{
  NSLog(@"next");
  BOOL animated = NO;
  
  // Title
  if (![residence.title length]){
    OMBFinishListingTitleViewController *vc =
      [[OMBFinishListingTitleViewController alloc]
        initWithResidence: residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: animated];
    return;
  }
  // Description
  if (![residence.description length]){
    OMBFinishListingDescriptionViewController *vc =
      [[OMBFinishListingDescriptionViewController alloc]
        initWithResidence:residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: animated];
    return;
  }
  // Rent / Auction Details
  if (!residence.minRent){
    OMBFinishListingRentAuctionDetailsViewController *vc =
      [[OMBFinishListingRentAuctionDetailsViewController alloc]
        initWithResidence:residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: animated];
    return;
  }
  // Address
  if (![residence.address length] || ![residence.city length] ||
      ![residence.state length] || ![residence.zip length]){
    OMBFinishListingAddressViewController *vc =
      [[OMBFinishListingAddressViewController alloc]
        initWithResidence: residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: animated];
    return;
  }
  // Lease Details
  if (!residence.moveInDate){
    OMBFinishListingLeaseDetailsViewController *vc =
      [[OMBFinishListingLeaseDetailsViewController alloc]
        initWithResidence:residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: animated];
    return;
  }
  // Listing Details
  if (!residence.bedrooms){
    OMBFinishListingOtherDetailsViewController *vc =
      [[OMBFinishListingOtherDetailsViewController alloc]
        initWithResidence:residence];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated: animated];
    return;
  }
  
}

- (void) preview
{
  [self.navigationController pushViewController:
    [[OMBResidenceDetailViewController alloc] initWithResidence: residence]
      animated: YES];
}

- (void) publishNow
{
  NSInteger numberOfStepsLeft = [residence numberOfStepsLeft];
  if (numberOfStepsLeft) {
    // NSString *stepsString = @"steps";
    // if (numberOfStepsLeft == 1)
    //   stepsString = @"step";
    // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
    //   @"Almost Finished" message: [NSString stringWithFormat:
    //     @"%i more %@ to go.", numberOfStepsLeft, stepsString] delegate: nil
    //       cancelButtonTitle: @"Continue" otherButtonTitles: nil];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
      @"Almost Finished" message: [self incompleteStepString] delegate: nil
        cancelButtonTitle: @"Continue" otherButtonTitles: nil];
    [alertView show];
  }
  else if (!isPublishing) {
    [self publishObject];
  }
}

- (void) publishObject
{
  OMBResidence *newResidence = [[OMBResidence alloc] init];
  OMBResidencePublishConnection *conn =
    [[OMBResidencePublishConnection alloc] initWithResidence: residence
      newResidence: newResidence];
  conn.completionBlock = ^(NSError *error) {
    if (!error &&
      (newResidence.uid ||
        ![residence isKindOfClass: [OMBTemporaryResidence class]])) {

      publishNowView.hidden = YES;
      unlistView.hidden     = NO;

      [alertBlur setTitle: @"Published"];
      [alertBlur setMessage: @"Your place has been published, "
        @"now you can start accepting offers."];
      // Buttons
      [alertBlur setConfirmButtonTitle: @"Okay"];
      [alertBlur addTargetForConfirmButton: self
        action: @selector(registerForPushNotifications)];
      [alertBlur showInView: self.view withDetails: NO];
      [alertBlur showOnlyConfirmButton];
      [alertBlur hideQuestionButton];
    }
    else {
      [self showAlertViewWithError: error];
    }
    [[self appDelegate].container stopSpinning];
    isPublishing = NO;
  };
  [[self appDelegate].container startSpinning];
  isPublishing = YES;
  [conn start];
}

- (void) registerForPushNotifications
{
  // Ask to register for push notifications
  if ([[self userDefaults] permissionPushNotifications]) {
    [self hideAlertBlurAndPopController];
  }
  else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
      @"Offer Notifications" message: @"Would you like to be notified "
      @"when someone places an offer on this listing?"
        delegate: self cancelButtonTitle: @"Not now"
          otherButtonTitles: @"Yes", nil];
    [alertView show];
  }
}

- (void) reloadPhotosRow
{
  [self.table reloadRowsAtIndexPaths:
    @[[NSIndexPath indexPathForRow: 0 inSection: 0]]
      withRowAnimation: UITableViewRowAnimationNone];
}

- (void) verifyPhotos
{
  UIImageView *checkImageView = (UIImageView *) [headerImageView viewWithTag:
    8888];
  if ([residence.images count]) {
    checkImageView.alpha =  1.0f;
    checkImageView.image = [UIImage imageNamed:
      @"checkmark_outline_filled.png"];
  }
  else{
    checkImageView.alpha =  0.2f;
    checkImageView.image = [UIImage imageNamed: @"checkmark_outline.png"];
  }
}

- (void) unlist
{
  [[self appDelegate].container startSpinning];
  // [activityView startSpinning];

  residence.inactive = YES;

  OMBResidenceUpdateConnection *conn =
    [[OMBResidenceUpdateConnection alloc] initWithResidence: residence
      attributes: @[@"inactive"]];
  conn.completionBlock = ^(NSError *error) {
    if (residence.inactive) {
      // [self.navigationItem setRightBarButtonItem: previewBarButtonItem
      //   animated: YES];
      publishNowView.hidden = NO;
      unlistView.hidden     = YES;
      // Table footer view
      // UIView *footerView = [UIView new];
      // footerView.frame = CGRectMake(0.0f, 0.0f,
      //   self.table.frame.size.width, publishNowView.frame.size.height);
      // self.table.tableFooterView = footerView;
    }
    else {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Error"
        message: @"Please try again" delegate: nil
          cancelButtonTitle: @"OK"
            otherButtonTitles: nil];
      [alertView show];
    }
    [[self appDelegate].container stopSpinning];
    // [activityView stopSpinning];
  };
  [conn start];
}

@end
