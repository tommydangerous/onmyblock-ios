//
//  OMBHomebaseBuyerViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterViewController.h"

#import "AMBlurView.h"
#import "DRNRealTimeBlurView.h"
#import "OMBAlertView.h"
#import "OMBCenteredImageView.h"
#import "OMBExtendedHitAreaViewContainer.h"
#import "OMBHomebaseRenterAddRemoveRoommatesViewController.h"
#import "OMBHomebaseRenterNotificationCell.h"
#import "OMBHomebaseRenterPaymentNotificationCell.h"
#import "OMBHomebaseRenterRentDepositInfoViewController.h"
#import "OMBHomebaseRenterRoommateImageView.h"
#import "OMBHomebaseRenterTopPriorityCell.h"
#import "OMBScrollView.h"
#import "UIColor+Extensions.h"

@implementation OMBHomebaseRenterViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Homebase Renter";
  self.title      = @"Tommy's Homebase";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setMenuBarButtonItem];

  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  editBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Edit"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(editRentalPayments)];
  [editBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];

  selectedSegmentIndex = 0;

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];
  self.view.backgroundColor = [UIColor grayUltraLight];

  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = 20.0f;
  CGFloat standardHeight = 44.0f;

  backViewOffsetY = padding + standardHeight;
  // The image in the back
  backView = [UIView new];
  backView.frame = CGRectMake(0.0f, 0.0f, 
    screenWidth, (screenHeight * 0.4f) + (padding + standardHeight + padding));
  [self.view addSubview: backView];
  // Image of residence
  OMBCenteredImageView *residenceImageView = 
    [[OMBCenteredImageView alloc] init];
  residenceImageView.frame = backView.frame;  
  residenceImageView.image = [UIImage imageNamed: 
    @"intro_still_image_slide_3_background.jpg"];
  [backView addSubview: residenceImageView];
  // Black tint
  UIView *colorView = [[UIView alloc] init];
  colorView.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  colorView.frame = residenceImageView.frame;
  [backView addSubview: colorView];
  // Blur
  DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] init];
  blurView.blurRadius = 0.3f;
  blurView.frame = residenceImageView.frame;  
  blurView.renderStatic = YES;
  [backView addSubview: blurView];

  CGFloat imageSize = backView.frame.size.width / 3.0f;
  // Images scroll
  imagesScrollView = [OMBScrollView new];
  imagesScrollView.clipsToBounds = NO;
  imagesScrollView.delegate = self;
  imagesScrollView.frame = CGRectMake(
    (backView.frame.size.width - imageSize) * 0.5f, 
      backViewOffsetY, imageSize, backView.frame.size.height - 
      (standardHeight + padding));
  imagesScrollView.contentSize = CGSizeMake(imageSize * (1 + 2), 
    imagesScrollView.frame.size.height);
  imagesScrollView.pagingEnabled = YES;
  imagesScrollView.showsHorizontalScrollIndicator = NO;
  [self.view addSubview: imagesScrollView];

  // Extended hit area for images scroll
  OMBExtendedHitAreaViewContainer *extendedHitArea = 
    [[OMBExtendedHitAreaViewContainer alloc] init];
  extendedHitArea.frame = CGRectMake(0.0f, backViewOffsetY,
    backView.frame.size.width, backView.frame.size.height);
  extendedHitArea.scrollView = imagesScrollView;
  [self.view addSubview: extendedHitArea];

  // Need to do this or else blur is off
  backView.frame = CGRectMake(0.0f, backViewOffsetY,
    backView.frame.size.width, backView.frame.size.height);

  imageViewArray = [NSMutableArray array];

  for (int i = 0; i < 3; i++) {
    CGRect rect = CGRectMake(imageSize * i, 0.0f, imageSize, 
      imagesScrollView.frame.size.height);
    OMBHomebaseRenterRoommateImageView *imageView = 
      [[OMBHomebaseRenterRoommateImageView alloc] initWithFrame: rect];
    if (i == 2) {
      [imageView setupForAddRoommate];
      }
    else if (i % 2) {
      imageView.imageView.image = [UIImage imageNamed: @"tommy_d.png"];
      imageView.nameLabel.text = @"Tommy";
    }
    else {
      imageView.imageView.image = [UIImage imageNamed: @"edward_d.jpg"];
      imageView.nameLabel.text = @"Edward";
    }
    [imageViewArray addObject: imageView];
    [imagesScrollView addSubview: imageView];
  }

  // Buttons
  buttonsView = [UIView new];
  buttonsView.clipsToBounds = YES;
  buttonsView.frame = CGRectMake(padding, 
    backView.frame.origin.y + backView.frame.size.height - 
    (standardHeight + padding), 
      screenWidth - (padding * 2), standardHeight);
  buttonsView.layer.borderColor = [UIColor whiteColor].CGColor;
  buttonsView.layer.borderWidth = 1.0f;
  buttonsView.layer.cornerRadius = buttonsView.frame.size.height * 0.5f;
  [self.view addSubview: buttonsView];
  // Middle divider
  middleDivider = [UIView new];
  middleDivider.backgroundColor = [UIColor whiteColor];
  middleDivider.frame = CGRectMake((buttonsView.frame.size.width - 1.0f) * 0.5f,
    0.0f, 1.0f, buttonsView.frame.size.height);
  [buttonsView addSubview: middleDivider];

  // Activity button
  activityButton = [UIButton new];
  activityButton.frame = CGRectMake(0.0f, 0.0f, 
    buttonsView.frame.size.width * 0.5f, buttonsView.frame.size.height);
  activityButton.tag = 0;
  activityButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  [activityButton addTarget: self action: @selector(segmentButtonSelected:)
    forControlEvents: UIControlEventTouchUpInside];
  [activityButton setTitle: @"Activity Feed" forState: UIControlStateNormal];
  [activityButton setTitleColor: middleDivider.backgroundColor
    forState: UIControlStateNormal];
  [buttonsView addSubview: activityButton];

  // Payments button
  paymentsButton = [UIButton new];
  paymentsButton.frame = CGRectMake(
    activityButton.frame.origin.x + activityButton.frame.size.width, 
      activityButton.frame.origin.y, 
        activityButton.frame.size.width, activityButton.frame.size.height);
  paymentsButton.tag = 1;
  paymentsButton.titleLabel.font = activityButton.titleLabel.font;
  [paymentsButton addTarget: self action: @selector(segmentButtonSelected:)
    forControlEvents: UIControlEventTouchUpInside];
  [paymentsButton setTitle: @"Rental Payments" forState: UIControlStateNormal];
  [paymentsButton setTitleColor: middleDivider.backgroundColor
    forState: UIControlStateNormal];
  [buttonsView addSubview: paymentsButton];

  CGFloat tableViewOriginY = backView.frame.origin.y + 
    padding + buttonsView.frame.size.height + padding;
  CGRect tableViewFrame = CGRectMake(0.0f, tableViewOriginY, 
    screenWidth, screenHeight - tableViewOriginY);
  // Activity table view
  _activityTableView = [[UITableView alloc] initWithFrame: tableViewFrame
    style: UITableViewStylePlain];
  _activityTableView.alwaysBounceVertical = YES;
  _activityTableView.backgroundColor      = [UIColor clearColor];
  _activityTableView.dataSource           = self;
  _activityTableView.delegate             = self;
  _activityTableView.separatorColor       = [UIColor grayLight];
  _activityTableView.separatorInset = UIEdgeInsetsMake(0.0f, padding, 
    0.0f, 0.0f);
  _activityTableView.showsVerticalScrollIndicator = NO;
  [self.view insertSubview: _activityTableView belowSubview: buttonsView];
  // Activity table header view
  OMBExtendedHitAreaViewContainer *activityTableViewHeader = 
    [OMBExtendedHitAreaViewContainer new];
  activityTableViewHeader.frame = CGRectMake(0.0f, 0.0f,
    _activityTableView.frame.size.width, 
      ((backView.frame.origin.y + backView.frame.size.height) - 
      tableViewOriginY));
  activityTableViewHeader.scrollView = imagesScrollView;
  _activityTableView.tableHeaderView = activityTableViewHeader;

  // Payments table view
  _paymentsTableView = [[UITableView alloc] initWithFrame: tableViewFrame
    style: UITableViewStylePlain];
  _paymentsTableView.alwaysBounceVertical = 
    _activityTableView.alwaysBounceVertical;
  _paymentsTableView.backgroundColor = _activityTableView.backgroundColor;
  _paymentsTableView.dataSource = self;
  _paymentsTableView.delegate = self;
  _paymentsTableView.separatorColor = _activityTableView.separatorColor;
  _paymentsTableView.separatorInset = _activityTableView.separatorInset;
  _paymentsTableView.showsVerticalScrollIndicator = 
    _activityTableView.showsVerticalScrollIndicator;
  [self.view insertSubview: _paymentsTableView belowSubview: buttonsView];
  // Payment table header view
  OMBExtendedHitAreaViewContainer *paymentTableViewHeader = 
    [OMBExtendedHitAreaViewContainer new];
  paymentTableViewHeader.frame = activityTableViewHeader.frame;
  paymentTableViewHeader.scrollView = imagesScrollView;
  _paymentsTableView.tableHeaderView = paymentTableViewHeader;

  alert = [[OMBAlertView alloc] init];

  // Add/Remove Roommates button
  // addRemoveRoommatesButton = [UIButton new];
  // addRemoveRoommatesButton.frame = CGRectMake(
  //   (screenWidth - imageSize) * 0.5f, 
  //     imagesScrollView.frame.origin.y, imageSize, 
  //     imagesScrollView.frame.size.height);
  // addRemoveRoommatesButton.hidden = YES;
  // [addRemoveRoommatesButton addTarget: self 
  //   action: @selector(showAddRemoveRoommates) 
  //     forControlEvents: UIControlEventTouchUpInside];
  // [self.view addSubview: addRemoveRoommatesButton];

  tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self
    action: @selector(showAddRemoveRoommates)];

  [self changeTableView];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [imagesScrollView setContentOffset: 
    CGPointMake(imagesScrollView.frame.size.width, 0.0f) animated: NO];

  // [self showRentDepositInfo];
  // [self showAddRemoveRoommates];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  // CGFloat screenWidth = screen.size.width;
  CGFloat padding        = 20.0f;
  CGFloat standardHeight = 44.0f;
  CGFloat y = scrollView.contentOffset.y;
  
  CGFloat percent = 0.0f;
  
  // Activity or Payments
  if (scrollView == _activityTableView || scrollView == _paymentsTableView) {
    CGFloat originalButtonsViewOriginY = padding + standardHeight + 
      (screen.size.height * 0.4f) + padding;
    CGFloat minOriginY = padding + standardHeight + padding;
    // CGFloat maxDistanceForBackView = originalButtonsViewOriginY - minOriginY;

    CGFloat newOriginY = originalButtonsViewOriginY - y;
    if (newOriginY > originalButtonsViewOriginY)
      newOriginY = originalButtonsViewOriginY;
    else if (newOriginY < minOriginY)
      newOriginY = minOriginY;
    // Move the buttons
    CGRect buttonsViewRect = buttonsView.frame;
    buttonsViewRect.origin.y = newOriginY;
    buttonsView.frame = buttonsViewRect;

    // Change the colors of the buttons
    // CGFloat maxDistancePercent = y / maxDistanceForBackView;
    // if (maxDistancePercent < 0) {
    //   maxDistancePercent = 0;
    // }
    // CGFloat redValue   = 111 + ((255 - 111) * maxDistancePercent);
    // CGFloat greenValue = 174 + ((255 - 174) * maxDistancePercent);
    // CGFloat blueValue  = 193 + ((255 - 193) * maxDistancePercent);
    // UIColor *newColor = [UIColor colorWithRed: redValue/255.0 
    //   green: greenValue/255.0 blue: blueValue/255.0 alpha: 1.0f];
    // buttonsView.layer.borderColor = newColor.CGColor;
    // middleDivider.backgroundColor = newColor;
    // [activityButton setTitleColor: newColor forState: UIControlStateNormal];
    // [paymentsButton setTitleColor: newColor forState: UIControlStateNormal];
    // UIColor *newButtonBackgroundColor = [UIColor colorWithRed: 
    //   redValue/255.0 
    //   green: greenValue/255.0 blue: blueValue/255.0 alpha: 0.3f];
    // if (selectedSegmentIndex == 0) {
    //   activityButton.backgroundColor = newButtonBackgroundColor;
    // }
    // else if (selectedSegmentIndex == 1) {
    //   paymentsButton.backgroundColor = newButtonBackgroundColor;
    // }

    // Move the Add/Remove Roommates button
    // CGFloat originalAddRemoveRoommatesButtonOriginY =
    //   (padding + standardHeight + backView.frame.size.height) - 
    //     (standardHeight + padding + (standardHeight + (padding * 0.5)));
    // CGFloat newAddRemoveOriginY = 
    //   originalAddRemoveRoommatesButtonOriginY - y;
    // if (newAddRemoveOriginY > originalAddRemoveRoommatesButtonOriginY)
    //   newAddRemoveOriginY = originalAddRemoveRoommatesButtonOriginY;
    // CGRect addRemoveRoommatesButtonRect = addRemoveRoommatesButton.frame;
    // addRemoveRoommatesButtonRect.origin.y = newAddRemoveOriginY;
    // addRemoveRoommatesButton.frame = addRemoveRoommatesButtonRect;

    // Move the images scroll view; no need to move the extended hit area
    CGFloat originalImagesScrollOriginY = padding + standardHeight;
    CGFloat newImagesScrollOriginY = originalImagesScrollOriginY - y;
    if (newImagesScrollOriginY > originalImagesScrollOriginY) {
      newImagesScrollOriginY = originalImagesScrollOriginY;
    }
    CGRect imagesScrollRect = imagesScrollView.frame;
    imagesScrollRect.origin.y = newImagesScrollOriginY;
    imagesScrollView.frame = imagesScrollRect;
  }
  // Images
  else if (scrollView == imagesScrollView) {
    CGFloat width = scrollView.frame.size.width;
    CGFloat x     = scrollView.contentOffset.x;
    // CGFloat page  = x / width;
    // Scale the slide views
    for (UIView *iView in imageViewArray) {
      percent = (x - (width * [imageViewArray indexOfObject: iView])) / width;
      if (percent < 0)
        percent *= -1;
      CGFloat scalePercent = 1 - percent;
      if (scalePercent > 1)
        scalePercent = 1;
      else if (scalePercent < 0.5f)
        scalePercent = 0.5f;
      iView.transform = CGAffineTransformMakeScale(scalePercent, scalePercent);
    }
    // If on the last image; add remove roommates button
    if (x > scrollView.contentSize.width - width) {
      // addRemoveRoommatesButton.hidden = NO;
      [imagesScrollView addGestureRecognizer: tapGesture];
    }
    else {
      // addRemoveRoommatesButton.hidden = YES;
      [imagesScrollView removeGestureRecognizer: tapGesture];
    }
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Activity
  if (tableView == _activityTableView) {
    // Top Priority
    // Recent Activity
    return 2;
  }
  // Payments
  else if (tableView == _paymentsTableView) {
    // Top Priority
    return 1;
  }
  return 0;
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
  // Activity
  if (tableView == _activityTableView) {
    // Top Priority
    if (indexPath.section == 0) {
      static NSString *TopPriorityCellIdentifier = @"TopPriorityCellIdentifier";
      OMBHomebaseRenterTopPriorityCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier:
          TopPriorityCellIdentifier];
      if (!cell1)
        cell1 = [[OMBHomebaseRenterTopPriorityCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: 
            TopPriorityCellIdentifier];
      [cell1 loadData];
      [cell1.yesButton addTarget: self action: @selector(showRentDepositInfo)
        forControlEvents: UIControlEventTouchUpInside];
      return cell1;
    }
    // Recent Activity
    else if (indexPath.section == 1) {
      static NSString *NotificationCellIdentifier = 
        @"NotificationCellIdentifier";
      OMBHomebaseRenterNotificationCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier:
          NotificationCellIdentifier];
      if (!cell1)
        cell1 = [[OMBHomebaseRenterNotificationCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: 
            NotificationCellIdentifier];
      [cell1 loadData];
      return cell1;
    }
  }
  // Payments
  else if (tableView == _paymentsTableView) {
    // Top Priority
    if (indexPath.section == 0) {
      static NSString *PaymentNotificationCellIdentifier = 
        @"PaymentNotificationCellIdentifier";
      OMBHomebaseRenterPaymentNotificationCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier:
          PaymentNotificationCellIdentifier];
      if (!cell1)
        cell1 = [[OMBHomebaseRenterPaymentNotificationCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: 
            PaymentNotificationCellIdentifier];
      [cell1 loadData];
      if (arc4random_uniform(100) % 2) {
        [cell1 setupForRoommate];
      }
      else {
        [cell1 setupForSelf];
      }
      [cell1.responseButton addTarget: self 
        action: @selector(paymentResponseButtonSelected:) 
          forControlEvents: UIControlEventTouchUpInside];
      return cell1;
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Activity
  if (tableView == _activityTableView) {
    // Top Priority
    if (section == 0) {
      return 2;
    }
    // Recent Activity
    else if (section == 1) {
      return 10;
    }
  }
  // Payments
  else if (tableView == _paymentsTableView) {
    // Top Priority
    if (section == 0) {
      return 15;
    }
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView 
heightForHeaderInSection: (NSInteger) section
{
  return 13.0f * 2;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Activity
  if (tableView == _activityTableView) {
    // Top Priority
    if (indexPath.section == 0) {
      return [OMBHomebaseRenterTopPriorityCell heightForCell];
    }
    // Recent Activity
    else if (indexPath.section == 1) {
      return [OMBHomebaseRenterNotificationCell heightForCell];
    }
  }
  // Payments
  else if (tableView == _paymentsTableView) {
    // Top Priority
    if (indexPath.section == 0) {
      return [OMBHomebaseRenterPaymentNotificationCell heightForCell];
    }
  }
  return 0.0f;
}

- (UIView *) tableView: (UITableView *) tableView 
viewForHeaderInSection: (NSInteger) section
{
  CGFloat padding = 20.0f;
  AMBlurView *blurView = [[AMBlurView alloc] init];
  blurView.blurTintColor = [UIColor blueLight];
  blurView.frame = CGRectMake(0.0f, 0.0f, 
    tableView.frame.size.width, 13.0f * 2);
  UILabel *label = [UILabel new];
  label.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 13];
  label.frame = CGRectMake(padding, 0.0f, 
    blurView.frame.size.width - (padding * 2), blurView.frame.size.height);
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor blueDark];
  [blurView addSubview: label];
  NSString *titleString = @"";
  // Activity
  if (tableView == _activityTableView) {
    // Top Priority
    if (section == 0) {
      titleString = @"Top Priority";
    }
    else if (section == 1) {
      titleString = @"Recent Activity";
    }
  }
  // Payments
  else if (tableView == _paymentsTableView) {
    // Top Priority
    if (section == 0) {
      titleString = @"Top Priority";
    }
  }
  label.text = titleString;
  return blurView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) editRentalPayments
{
  OMBHomebaseRenterRentDepositInfoViewController *vc = 
    [[OMBHomebaseRenterRentDepositInfoViewController alloc] init];
  vc.delegate = self;
  [vc setupForEditRentalPayments];
  [self.navigationController pushViewController: vc animated: YES];
}

- (void) changeTableView
{
  // CGRect screen = [[UIScreen mainScreen] bounds];
  // CGFloat padding        = 20.0f;
  // CGFloat standardHeight = 44.0f;
  CGFloat threshold      = backView.frame.size.height;
  // CGFloat y = 0.0f;
  // if (selectedSegmentIndex == 0) {
  //   y = _activityTableView.contentOffset.y;
  // }
  // else if (selectedSegmentIndex == 1) {
  //   y = _paymentsTableView.contentOffset.y;
  // }
  // CGFloat originalButtonsViewOriginY = padding + standardHeight + 
  //   (screen.size.height * 0.4f) + padding;
  // CGFloat minOriginY = padding + standardHeight + padding;
  // CGFloat maxDistanceForBackView = originalButtonsViewOriginY - minOriginY;
  // CGFloat maxDistancePercent = y / maxDistanceForBackView;
  // if (maxDistancePercent < 0) {
  //   maxDistancePercent = 0;
  // }
  // // Color values for the button background
  // CGFloat redValue   = 111 + ((255 - 111) * maxDistancePercent);
  // CGFloat greenValue = 174 + ((255 - 174) * maxDistancePercent);
  // CGFloat blueValue  = 193 + ((255 - 193) * maxDistancePercent);
  // UIColor *newColor = [UIColor colorWithRed: redValue/255.0 
  //   green: greenValue/255.0 blue: blueValue/255.0 alpha: 0.3f];

  if (selectedSegmentIndex == 0) {
    activityButton.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.3f];
    _activityTableView.hidden = NO;
    paymentsButton.backgroundColor = [UIColor clearColor];
    _paymentsTableView.hidden = YES;
    // Change the content offset of activity table view 
    // if payments table view is not scrolled pass the threshold
    if (_paymentsTableView.contentOffset.y < threshold) {
      _activityTableView.contentOffset = _paymentsTableView.contentOffset;
    }
    // If activity table view content offset is less than threshold
    else if (_activityTableView.contentOffset.y < threshold) {
      _activityTableView.contentOffset = CGPointMake(
        _activityTableView.contentOffset.x, threshold);
    }
    [self.navigationItem setRightBarButtonItem: nil animated: YES];
  }
  else if (selectedSegmentIndex == 1) {
    activityButton.backgroundColor = [UIColor clearColor];
    _activityTableView.hidden = YES;
    paymentsButton.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.3f];
    _paymentsTableView.hidden = NO;
    // Change the content offset of activity table view 
    // if payments table view is not scrolled pass the threshold
    if (_activityTableView.contentOffset.y < threshold) {
      _paymentsTableView.contentOffset = _activityTableView.contentOffset;
    }
    // If payments table view content offset is less than threshold
    else if (_paymentsTableView.contentOffset.y < threshold) {
      _paymentsTableView.contentOffset = CGPointMake(
        _paymentsTableView.contentOffset.x, threshold);
    }
    [self.navigationItem setRightBarButtonItem: editBarButtonItem 
      animated: YES];
  }
}

- (void) paymentAlertCancel
{
  [alert hideAlert];
}

- (void) paymentAlertConfirm
{
  [alert hideAlert];
}

- (void) paymentResponseButtonSelected: (UIButton *) button
{
  if (button.tag == 0) {
    alert.alertTitle.text = @"Confirm Payment";
    alert.alertMessage.text = @"You will be charged $750 for rent using Venmo.";
    [alert.alertCancel addTarget: self action: @selector(paymentAlertCancel)
      forControlEvents: UIControlEventTouchUpInside];
    [alert.alertCancel setTitle: @"Wait" forState: UIControlStateNormal];
    [alert.alertConfirm addTarget: self action: @selector(paymentAlertConfirm)
      forControlEvents: UIControlEventTouchUpInside];
    [alert.alertConfirm setTitle: @"Pay" forState: UIControlStateNormal];
    [alert showAlert];
  }
}

- (void) segmentButtonSelected: (UIButton *) button
{
  if (selectedSegmentIndex != button.tag) {
    selectedSegmentIndex = button.tag;
    [self changeTableView];
  }
}

- (void) showAddRemoveRoommates
{
  [self.navigationController pushViewController: 
    [[OMBHomebaseRenterAddRemoveRoommatesViewController alloc] init] 
      animated: YES];
}

- (void) showRentDepositInfo
{
  OMBHomebaseRenterRentDepositInfoViewController *vc = 
    [[OMBHomebaseRenterRentDepositInfoViewController alloc] init];
  vc.delegate = self;
  [self.navigationController pushViewController: vc animated: YES];
}

- (void) switchToPaymentsTableView
{
  selectedSegmentIndex = 1;
  [self changeTableView];
  [_paymentsTableView setContentOffset: CGPointZero animated: NO];
}

@end
