//
//  OMBFinishListingViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingViewController.h"

#import "AMBlurView.h"
#import "OMBActivityView.h"
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
#import "OMBTemporaryResidence.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

@implementation OMBFinishListingViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  numberOfSteps = 7;
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
  CGFloat padding = 20.0f;

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
  [publishNowButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [publishNowView addSubview: publishNowButton];

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
    PropertyInfoViewImageHeightPercentage; // ... * 0.4
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
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // Download the residence's images
  OMBResidenceImagesConnection *conn = 
    [[OMBResidenceImagesConnection alloc] initWithResidence: residence];
  conn.completionBlock = ^(NSError *error) {
    // Add the cover photo
    if (!headerImageView.image)
      headerImageView.image = [residence coverPhoto];

    // Update the Photos (X) count
    [self verifyPhotos];
  };
  [conn start];

  // Image
  if ([residence coverPhoto])
    headerImageView.image = [residence coverPhoto];
  else
    [headerImageView clearImage];

  // Reload
  // Photos
  // [self reloadPhotosRow];
  // Title
  // [self reloadTitleRow];

  [self.table reloadData];
  [self verifyPhotos];

  // Calculate how many steps are left
  NSString *publishNowButtonTitle = @"Publish Now";
  if ([residence numberOfStepsLeft] > 0)
    publishNowButtonTitle = [residence statusString];
  [publishNowButton setTitle: publishNowButtonTitle 
    forState: UIControlStateNormal];

  // If the residence is a temporary residence
  if ([residence isKindOfClass: [OMBTemporaryResidence class]]) {
    // self.navigationItem.rightBarButtonItem = previewBarButtonItem;
    publishNowView.hidden = NO;
    unlistView.hidden     = YES;
  }
  // If a residence
  else {
    // If unlisted
    if (residence.inactive) {
      // self.navigationItem.rightBarButtonItem = previewBarButtonItem;
      publishNowView.hidden = NO;
      unlistView.hidden     = YES;
    }
    // If listed
    else {
      // self.navigationItem.rightBarButtonItem = unlistBarButtonItem;
      publishNowView.hidden = YES;
      unlistView.hidden     = NO;
      // // Table footer view
      // UIView *footerView = [UIView new];
      // footerView.frame = CGRectMake(0.0f, 0.0f, 
      //   self.table.frame.size.width, 0.0f);
      // self.table.tableFooterView = footerView;
    }
  }

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
  
  // Title
  if (indexPath.row == 0) {
    string = @"Title";
    if ([residence.title length]) {
      string = residence.title;
      cell.textLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
  }
  // Description
  else if (indexPath.row == 1) {
    string = @"Description";
    if ([residence.description length]) {
      cell.textLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
  }
  // Rent / Auction Details
  else if (indexPath.row == 2) {
    // string = @"Rent / Auction Details";
    string = @"Rent Details";
    if (residence.minRent) {
      cell.textLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
  }
  // Address
  else if (indexPath.row == 3) {
    string = @"Select Address";
    if ([residence.address length]) {
      string = [residence.address capitalizedString];
      cell.textLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
  }  
  // Lease Details
  else if (indexPath.row == 4) {
    string = @"Lease Details";
    if (residence.moveInDate) {
      cell.textLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
  }
  // Listing Details
  else if (indexPath.row == 5) {
    string = @"Listing Details";
    if (residence.bedrooms) {
      cell.textLabel.textColor = [UIColor textColor];
      imageView.alpha = 1.0f;
      imageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
    }
  }
  cell.textLabel.text = string;
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
  return 6;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Title
  if (indexPath.row == 0) {
    [self.navigationController pushViewController:
      [[OMBFinishListingTitleViewController alloc] initWithResidence: 
        residence] animated: YES];
  }
  // Description
  else if (indexPath.row == 1) {
    [self.navigationController pushViewController:
      [[OMBFinishListingDescriptionViewController alloc] initWithResidence: 
        residence] animated: YES];
  }
  // Rent / Auction Details
  else if (indexPath.row == 2) {
    [self.navigationController pushViewController:
      [[OMBFinishListingRentAuctionDetailsViewController alloc] 
        initWithResidence: residence] animated: YES]; 
  }
  // Address
  else if (indexPath.row == 3) {
    [self.navigationController pushViewController:
      [[OMBFinishListingAddressViewController alloc] initWithResidence: 
        residence] animated: YES];
  }
  // Lease Details
  else if (indexPath.row == 4) {
    [self.navigationController pushViewController:
     [[OMBFinishListingLeaseDetailsViewController alloc] initWithResidence:
      residence] animated: YES];
  }
  // Listing Details
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
    NSString *stepsString = @"steps";
    if (numberOfStepsLeft == 1)
      stepsString = @"step";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: 
      @"Almost Finished" message: [NSString stringWithFormat: 
        @"%i more %@ to go.", numberOfStepsLeft, stepsString] delegate: nil 
          cancelButtonTitle: @"Continue" otherButtonTitles: nil];
    [alertView show];
  }
  else {
    [[self appDelegate].container startSpinning];
    // [activityView startSpinning];

    OMBResidencePublishConnection *conn = 
      [[OMBResidencePublishConnection alloc] initWithResidence: residence];
    conn.completionBlock = ^(NSError *error) {
      if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Error" 
          message: error.localizedDescription delegate: nil 
            cancelButtonTitle: @"Try again"
              otherButtonTitles: nil];
        [alertView show];
      }
      else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: 
          @"Congratulations" message: @"Your place has been published." 
          delegate: nil 
            cancelButtonTitle: @"OK"
              otherButtonTitles: nil];
        [alertView show];
        // [self.navigationController popViewControllerAnimated: YES];
        publishNowView.hidden = YES;
        unlistView.hidden     = NO;
      }
      [[self appDelegate].container stopSpinning];
      // [activityView stopSpinning];
    };
    [conn start];
  }
}

- (void) reloadPhotosRow
{
  NSLog(@"reloadPhotosRow");
  [self.table reloadRowsAtIndexPaths: 
    @[[NSIndexPath indexPathForRow: 0 inSection: 0]]
      withRowAnimation: UITableViewRowAnimationNone];
  
}

-(void)verifyPhotos{
  NSLog(@"photos");
  UIImageView *checkImageView = (UIImageView *) [headerImageView viewWithTag: 8888];
  if ([residence.images count]) {
    checkImageView.alpha =  1.0f;
    checkImageView.image = [UIImage imageNamed: @"checkmark_outline_filled.png"];
  }else{
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
