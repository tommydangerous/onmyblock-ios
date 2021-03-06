//
//  OMBHomebaseBuyerViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterViewControllerOLD.h"

#import "AMBlurView.h"
#import "DRNRealTimeBlurView.h"
#import "OMBActivityViewFullScreen.h"
#import "OMBAlertView.h"
#import "OMBBlurView.h"
#import "OMBCenteredImageView.h"
#import "OMBEmptyImageTwoLabelCell.h"
#import "OMBExtendedHitAreaViewContainer.h"
#import "OMBHomebaseLandlordOfferCell.h"
#import "OMBHomebaseRenterAddRemoveRoommatesViewController.h"
#import "OMBHomebaseRenterNotificationCell.h"
#import "OMBHomebaseRenterPaymentNotificationCell.h"
#import "OMBHomebaseRenterRentDepositInfoViewController.h"
#import "OMBHomebaseRenterRoommateImageView.h"
#import "OMBHomebaseRenterSentApplicationViewController.h"
#import "OMBHomebaseRenterTopPriorityCell.h"
#import "OMBInformationHowItWorksViewController.h"
#import "OMBNavigationController.h"
#import "OMBOffer.h"  
#import "OMBOfferInquiryViewController.h"
#import "OMBPayoutMethod.h"
#import "OMBPayoutTransaction.h"
#import "OMBPayPalVerifyMobilePaymentConnection.h"
#import "OMBRenterApplication.h"
#import "OMBRenterProfileViewController.h"
#import "OMBResidence.h"
#import "OMBScrollView.h"
#import "OMBSentApplicationCell.h"
#import "OMBViewController+PayPalPayment.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+NegativeImage.h"

// Make this 0.4f when having roommates
float kHomebaseRenterImagePercentage = 0.15f;
// float kHomebaseRenterImagePercentage = 0.2f;

@implementation OMBHomebaseRenterViewControllerOLD

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.title = @"Homebase";

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
  // self.navigationItem.rightBarButtonItem = editBarButtonItem;

  selectedSegmentIndex = 0;

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];
  self.view.backgroundColor = [UIColor grayUltraLight];

  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = OMBPadding;
  CGFloat standardHeight = OMBStandardHeight;

  UIButton *infoButton = [UIButton new];
  infoButton.frame = CGRectMake(0.0f, 0.0f, 26.0f, 26.0f);
  infoButton.layer.borderColor = [UIColor blue].CGColor;
  infoButton.layer.borderWidth = 1.0f;
  infoButton.layer.cornerRadius = 26.0f * 0.5f;
  infoButton.titleLabel.font = [UIFont normalTextFontBold];
  [infoButton addTarget: self action: @selector(showHomebaseHowItWorks)
       forControlEvents: UIControlEventTouchUpInside];
  [infoButton setTitle: @"i" forState: UIControlStateNormal];
  [infoButton setTitleColor: [UIColor blue] forState: UIControlStateNormal];
  //self.navigationItem.rightBarButtonItem =
  //  [[UIBarButtonItem alloc] initWithCustomView: infoButton];

  backViewOffsetY = padding + standardHeight;
  // The image in the back
  CGRect backViewRect = CGRectMake(0.0f, 0.0f,
    screenWidth, (screenHeight * kHomebaseRenterImagePercentage) +
    (padding + standardHeight + padding));
  backView = [[OMBBlurView alloc] initWithFrame: backViewRect];
  backView.blurRadius = 5.0f;
  backView.tintColor = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  [self.view addSubview: backView];

  // Image of residence
  // residenceImageView =
  //   [[OMBCenteredImageView alloc] init];
  // residenceImageView.frame = backView.frame;
  // residenceImageView.image = [UIImage imageNamed:
  //   @"intro_still_image_slide_3_background.jpg"];
  // [backView addSubview: residenceImageView];
  // Black tint
  // UIView *colorView = [[UIView alloc] init];
  // colorView.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  // colorView.frame = residenceImageView.frame;
  // [backView addSubview: colorView];
  // Blur
  // blurView = [[DRNRealTimeBlurView alloc] init];
  // blurView.frame = residenceImageView.frame;
  // blurView.renderStatic = YES;
  // [backView addSubview: blurView];

  // The pictures of the users go here
  CGFloat imageSize = backView.frame.size.width / 3.0f;
  // Images scroll
  imagesScrollView = [OMBScrollView new];
  imagesScrollView.clipsToBounds = NO;
  imagesScrollView.delegate = self;
  // imagesScrollView.frame = CGRectMake(
  //   (backView.frame.size.width - imageSize) * 0.5f,
  //     backViewOffsetY, imageSize, backView.frame.size.height -
  //     (standardHeight + padding));
  imagesScrollView.frame = CGRectMake(
    (backView.frame.size.width - imageSize) * 0.5f,
      backViewOffsetY, imageSize, backView.frame.size.height);
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
  // [self.view addSubview: buttonsView];
  // Middle divider
  middleDivider = [UIView new];
  middleDivider.backgroundColor = [UIColor whiteColor];
  middleDivider.frame = CGRectMake((buttonsView.frame.size.width - 1.0f) * 0.5f,
    0.0f, 1.0f, buttonsView.frame.size.height);
  // [buttonsView addSubview: middleDivider];

  // Activity button
  activityButton = [UIButton new];
  activityButton.frame = CGRectMake(0.0f, 0.0f,
    buttonsView.frame.size.width * 1, buttonsView.frame.size.height);
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
  // [buttonsView addSubview: paymentsButton];

  // CGFloat tableViewOriginY = backView.frame.origin.y +
  //   padding + buttonsView.frame.size.height + padding;
  CGFloat tableViewOriginY = padding + standardHeight;
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
  // _activityTableView.showsVerticalScrollIndicator = NO;
  [self.view insertSubview: _activityTableView belowSubview: buttonsView];
  // Activity table header view
  OMBExtendedHitAreaViewContainer *activityTableViewHeader =
    [OMBExtendedHitAreaViewContainer new];
  activityTableViewHeader.frame = CGRectMake(0.0f, 0.0f,
    _activityTableView.frame.size.width,
      ((backView.frame.origin.y + backView.frame.size.height) -
      tableViewOriginY));
  // activityTableViewHeader.scrollView = imagesScrollView;
  _activityTableView.tableHeaderView = activityTableViewHeader;
  // Footer view
  _activityTableView.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectZero];

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
  // Footer view
  _paymentsTableView.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectZero];

  refreshControl = [UIRefreshControl new];
  [refreshControl addTarget:self action:@selector(refresh) forControlEvents:
    UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor lightTextColor];
  [_activityTableView addSubview:refreshControl];

  alert = [[OMBAlertView alloc] init];

  // User image view
  //CGFloat userImageSize = backView.frame.size.width / 3.0f;
  //CGRect userImageViewRect = CGRectMake(
  //  (activityTableViewHeader.frame.size.width - userImageSize) * 0.5f,
  //    (activityTableViewHeader.frame.size.height - userImageSize) * 0.5f,
  //      userImageSize, userImageSize);
  //userImageView = [[OMBHomebaseRenterRoommateImageView alloc] initWithFrame:
  //  userImageViewRect];
  //[activityTableViewHeader addSubview: userImageView];

  //tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self
  //  action: @selector(showMyRenterProfile)];
  //[userImageView addGestureRecognizer: tapGesture];

  CGFloat totalLabelHeights = 27.0f + (22.0f * 2);
  UILabel *welcomeLabel = [UILabel new];
  welcomeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  welcomeLabel.frame = CGRectMake(0.0f,
                            (activityTableViewHeader.frame.size.height - totalLabelHeights) * 0.5f,
                            activityTableViewHeader.frame.size.width, 27.0f);
  welcomeLabel.text = @"Welcome to your Homebase.";
  welcomeLabel.textAlignment = NSTextAlignmentCenter;
  welcomeLabel.textColor = [UIColor whiteColor];
  [activityTableViewHeader addSubview: welcomeLabel];

  UILabel *descriptionLabel = [UILabel new];
  NSString *descriptionString = @"Review all your applications \n"
    @"and bookings here.";
  descriptionLabel.attributedText = [descriptionString attributedStringWithFont:
                           [UIFont fontWithName: @"HelveticaNeue-Light" size: 15] lineHeight: 22.0f];
  descriptionLabel.frame = CGRectMake(0.0f,
                            welcomeLabel.frame.origin.y + welcomeLabel.frame.size.height,
                            activityTableViewHeader.frame.size.width, 22.0f * 2);
  descriptionLabel.numberOfLines = 2;
  descriptionLabel.textColor = welcomeLabel.textColor;
  descriptionLabel.textAlignment = welcomeLabel.textAlignment;
  [activityTableViewHeader addSubview: descriptionLabel];

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

  // tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self
  //   action: @selector(showAddRemoveRoommates)];

  [self changeTableView];

  activityViewFullScreen = [[OMBActivityViewFullScreen alloc] init];
  [self.view addSubview: activityViewFullScreen];
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];

  [refreshControl endRefreshing];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // [self showRentDepositInfo];
  // [self showAddRemoveRoommates];

  [backView refreshWithImage:
    [UIImage imageNamed: @"intro_still_image_slide_2_background.jpg"]];

  // NSInteger tag = 9999;
  // [imageViewArray removeAllObjects];
  // [imagesScrollView.subviews enumerateObjectsUsingBlock:
  //   ^(id obj, NSUInteger idx, BOOL *stop) {
  //     UIView *v = (UIView *) obj;
  //     if (v.tag == tag)
  //       [v removeFromSuperview];
  //   }
  // ];

  // CGFloat imageSize = backView.frame.size.width / 3.0f;
  // for (int i = 0; i < 1; i++) {
  //   CGRect rect = CGRectMake(imageSize * i, 0.0f, imageSize,
  //     imagesScrollView.frame.size.height);

  //   OMBHomebaseRenterRoommateImageView *imageView =
  //     [[OMBHomebaseRenterRoommateImageView alloc] initWithFrame: rect];
  //   imageView.tag = tag;
  //   // if (i == 2) {
  //   //   [imageView setupForAddRoommate];
  //   // }
  //   // else if (i % 2) {
  //   //   imageView.imageView.image = [UIImage imageNamed: @"tommy_d.png"];
  //   //   imageView.nameLabel.text = @"Tommy";
  //   // }
  //   // else {
  //   //   imageView.imageView.image = [UIImage imageNamed: @"edward_d.jpg"];
  //   //   imageView.nameLabel.text = @"Edward";
  //   // }
  //   if ([OMBUser currentUser].image) {
  //     imageView.imageView.image = [OMBUser currentUser].image;
  //     imageView.nameLabel.text  =
  //       [[OMBUser currentUser].firstName capitalizedString];
  //   }
  //   else {
  //     [[OMBUser currentUser] downloadImageFromImageURLWithCompletion:
  //       ^(NSError *error) {
  //         imageView.imageView.image = [OMBUser currentUser].image;
  //       }
  //     ];
  //     imageView.imageView.image =
  //       [[UIImage imageNamed: @"user_icon_default.png"] negativeImage];
  //   }
  //   [imageViewArray addObject: imageView];
  //   [imagesScrollView addSubview: imageView];
  // }

  // User image
  if ([OMBUser currentUser].image) {
    userImageView.imageView.image = [OMBUser currentUser].image;
  }
  else {
    [[OMBUser currentUser] downloadImageFromImageURLWithCompletion:
      ^(NSError *error) {
        userImageView.imageView.image = [OMBUser currentUser].image;
      }
    ];
    userImageView.imageView.image =
      [UIImage imageNamed: @"profile_default_pic.png"];
  }
  // Name for the image
  userImageView.nameLabel.text =
    [[OMBUser currentUser].firstName capitalizedString];

  // imagesScrollView.contentSize = CGSizeMake(imageSize * (1 + 0),
  //   imagesScrollView.frame.size.height);
  // [imagesScrollView setContentOffset: CGPointZero animated: NO];
  // [imagesScrollView setContentOffset:
  //   CGPointMake(imagesScrollView.frame.size.width, 0.0f) animated: NO];

  // Fetch accepted offers
  if (!charging) {
    [[OMBUser currentUser] fetchAcceptedOffersWithCompletion:
      ^(NSError *error) {
        [_activityTableView reloadData];
        [activityViewFullScreen stopSpinning];
      }
    ];
    [activityViewFullScreen startSpinning];
  }

  // If user just came back from setting up payment method
  if (selectedOffer && cameFromSettingUpPayoutMethods) {
    alert.hidden = NO;
    [UIView animateWithDuration: 0.25f animations: ^{
      alert.alpha = 1.0f;
    }];
    cameFromSettingUpPayoutMethods = NO;
  }

  // Fetch confirmed tenants
  [[OMBUser currentUser] fetchMovedInWithCompletion:
    ^(NSError *error) {
      [_activityTableView reloadData];
    }
  ];
  
  // Fetch sent applications
  [[OMBUser currentUser].renterApplication fetchSentApplicationsWithDelegate: 
    nil completion: ^(NSError *error) {
      [_activityTableView reloadData];
    }
  ];
}

-(void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear: animated];
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
      (screen.size.height * kHomebaseRenterImagePercentage) + padding;
    CGFloat minOriginY = padding + standardHeight + padding;
    CGFloat maxDistanceForBackView = originalButtonsViewOriginY - minOriginY;

    CGFloat newOriginY = originalButtonsViewOriginY - y;
    if (newOriginY > originalButtonsViewOriginY)
      newOriginY = originalButtonsViewOriginY;
    else if (newOriginY < minOriginY)
      newOriginY = minOriginY;
    // Move the buttons
    CGRect buttonsViewRect = buttonsView.frame;
    buttonsViewRect.origin.y = newOriginY;
    buttonsView.frame = buttonsViewRect;

    // Move view up
    CGFloat adjustment = y / 3.0f;
    // Adjust the header image view
    CGRect backViewRect = backView.frame;
    CGFloat newOriginY2 = backViewOffsetY - adjustment;
    if (newOriginY2 > backViewOffsetY)
      newOriginY2 = backViewOffsetY;
    else if (newOriginY2 < backViewOffsetY - (maxDistanceForBackView / 3.0f))
      newOriginY2 = backViewOffsetY - (maxDistanceForBackView / 3.0f);
    backViewRect.origin.y = newOriginY2;
    backView.frame = backViewRect;

    // Scale the background image
    CGFloat newScale = 1 + ((y * -3.0f) / backView.imageView.frame.size.height);
    if (newScale < 1)
      newScale = 1;
    backView.imageView.transform = CGAffineTransformScale(
      CGAffineTransformIdentity, newScale, newScale);

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
    // Sent Applications
    // Booking Requests
    // Move In
    return 3;
    // return 2;
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
    // Sent Applications
    if (indexPath.section == 0) {
      // Blank space
      if (indexPath.row == 0) {
        static NSString *EmptySentAppsCellIdentifier =
          @"EmptySentAppsCellIdentifier";
        OMBEmptyImageTwoLabelCell *cell =
          [tableView dequeueReusableCellWithIdentifier:
            EmptySentAppsCellIdentifier];
        if (!cell)
          cell = [[OMBEmptyImageTwoLabelCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier:
              EmptySentAppsCellIdentifier];
        [cell setTopLabelText: @"Your sent applications will"];
        [cell setMiddleLabelText: @"appear here after you have"];
        [cell setBottomLabelText: @"applied to a property."];
        [cell setObjectImageViewImage:
          [UIImage  imageNamed:@"papers_icon_white.png"]];
        cell.clipsToBounds = YES;
        return cell;
      }
      else {
        static NSString *SentApplicationCellIdentifier =
          @"SentApplicationCellIdentifier";
        OMBSentApplicationCell *cell =
          [tableView dequeueReusableCellWithIdentifier:
            SentApplicationCellIdentifier];
        if (!cell)
          cell = [[OMBSentApplicationCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier: 
              SentApplicationCellIdentifier];
        [cell loadInfo: 
          [[self sentApplications] objectAtIndex: indexPath.row - 1]];
        cell.clipsToBounds = YES;
        return cell;
      }
    }
    // Booking Requests
    if (indexPath.section == 1) {
      // Blank space
      if (indexPath.row == 0) {
        static NSString *EmptyOffersCellIdentifier =
        @"EmptyOffersCellIdentifier";
        OMBEmptyImageTwoLabelCell *cell1 =
        [tableView dequeueReusableCellWithIdentifier:
         EmptyOffersCellIdentifier];
        if (!cell1)
          cell1 = [[OMBEmptyImageTwoLabelCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier:
              EmptyOffersCellIdentifier];
        [cell1 setTopLabelText: @"Your offers will appear here."];
        [cell1 setMiddleLabelText: @"You will be able to confirm"];
        [cell1 setBottomLabelText: @"or reject them."];
        [cell1 setObjectImageViewImage: [UIImage imageNamed:
          @"moneybag_icon.png"]];
        cell1.clipsToBounds = YES;
        return cell1;
      }
      else {
        // static NSString *TopPriorityCellIdentifier =
        //   @"TopPriorityCellIdentifier";
        // OMBHomebaseRenterTopPriorityCell *cell1 =
        //   [tableView dequeueReusableCellWithIdentifier:
        //     TopPriorityCellIdentifier];
        // if (!cell1)
        //   cell1 = [[OMBHomebaseRenterTopPriorityCell alloc] initWithStyle:
        //     UITableViewCellStyleDefault reuseIdentifier:
        //       TopPriorityCellIdentifier];
        // OMBOffer *offer = [[self offers] objectAtIndex: indexPath.row - 1];
        // cell1.noButton.tag = cell1.yesButton.tag = offer.uid;
        // [cell1.noButton addTarget: self action: @selector(rejectOffer:)
        //   forControlEvents: UIControlEventTouchUpInside];
        // [cell1.yesButton addTarget: self action: @selector(confirmOffer:)
        //   forControlEvents: UIControlEventTouchUpInside];
        // [cell1 loadOffer: offer];
        // return cell1;
        static NSString *OfferCellIdentifier = @"OfferCellIdentifier";
        OMBHomebaseLandlordOfferCell *cell1 =
        [tableView dequeueReusableCellWithIdentifier:
         OfferCellIdentifier];
        if (!cell1)
          cell1 = [[OMBHomebaseLandlordOfferCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier: OfferCellIdentifier];
        [cell1 loadOfferForRenter:
         [[self offers] objectAtIndex: indexPath.row - 1]];
        cell1.clipsToBounds = YES;
        return cell1;
      }
    }
    // Moved In
    else if (indexPath.section == 2) {
      // Blank space
      if (indexPath.row == 0) {
        static NSString *EmptyTenantsCellIdentifier =
          @"EmptyTenantsCellIdentifier";
        OMBEmptyImageTwoLabelCell *cell1 =
          [tableView dequeueReusableCellWithIdentifier:
            EmptyTenantsCellIdentifier];
        if (!cell1)
          cell1 = [[OMBEmptyImageTwoLabelCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier:
              EmptyTenantsCellIdentifier];
        [cell1 setTopLabelText: @"Places you're moving into will"];
        [cell1 setMiddleLabelText: @"appear here after you have"];
        [cell1 setBottomLabelText: @"paid and signed the lease."];
        [cell1 setObjectImageViewImage: [UIImage imageNamed:
          @"confirm_place_icon.png"]];
        cell1.clipsToBounds = YES;
        return cell1;

        // cell.separatorInset = UIEdgeInsetsMake(0.0f,
        //   tableView.frame.size.width, 0.0f, 0.0f);
      }
      else {
        static NSString *ConfirmedTenantIdentifier =
          @"ConfirmedTenantIdentifier";
        OMBHomebaseLandlordOfferCell *cell1 =
          [tableView dequeueReusableCellWithIdentifier:
            ConfirmedTenantIdentifier];
        if (!cell1) {
          cell1 = [[OMBHomebaseLandlordOfferCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier:
              ConfirmedTenantIdentifier];
          // Account for empty row
          /*[cell1 loadConfirmedTenant:
            [[self movedIn] objectAtIndex: indexPath.row - 1]];*/

          [cell1 loadMoveInConfirmedTenant:
           [[self movedIn] objectAtIndex: indexPath.row - 1]];
          [cell1 adjustFramesWithoutImage];
        }
        cell1.clipsToBounds = YES;
        return cell1;
      }
    }
    // Recent Activity
    else if (indexPath.section == 99) {
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
      cell1.clipsToBounds = YES;
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
      cell1.clipsToBounds = YES;
      return cell1;
    }
  }
  cell.clipsToBounds = YES;
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Activity
  if (tableView == _activityTableView) {
    // Sent Applications
    if (section == 0){
      return 1 + [self sentApplications].count;
      //return 2; // remove this
    }
    // Booking Requests
    else if (section == 1) {
      // Blank space
      return 1 + [[[OMBUser currentUser].acceptedOffers allValues] count];
      // return 2;
    }
    // Moved In
    else if (section == 2) {
      // First row is for when there are no moved in
      return 1 + [[OMBUser currentUser].movedIn count];
    }
    // Recent Activity
    else if (section == 99) {
      return 0;
      // return 10;
    }
  }
  // Payments
  else if (tableView == _paymentsTableView) {
    // Top Priority
    if (section == 0) {
      return 0;
      // return 15;
    }
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (tableView == _activityTableView) {
    // Sent Applications
    if (indexPath.section == 0) {
      if (indexPath.row > 0) {
        // new view controller
        [self.navigationController pushViewController: 
          [[OMBHomebaseRenterSentApplicationViewController alloc] initWithOffer:
            nil] animated: YES];
      }
    }
    // Offers
    else if (indexPath.section == 1) {
      if (indexPath.row > 0) {
        OMBOffer *offer = [[self offers] objectAtIndex:
          indexPath.row - 1];
        
        [self.navigationController pushViewController:
          [[OMBOfferInquiryViewController alloc] initWithOffer: offer]
            animated: YES];
      }
    }
    // Moved In
    else if (indexPath.section == 2) {
      if (indexPath.row > 0) {
        [self.navigationController pushViewController:
          [[OMBOfferInquiryViewController alloc]
            initWithOffer: [[self movedIn] objectAtIndex:
              indexPath.row - 1]] animated: YES];
      }
    }
  }
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
    // Sent Applications
    if (indexPath.section == 0){
      // Blank space
      if (indexPath.row == 0) {
        if ([self sentApplications].count == 0) {
          return [OMBEmptyImageTwoLabelCell heightForCell];
        }
      }
      else {
        return [OMBSentApplicationCell heightForCell];
      }
    }
    // Booking Requests
    else if (indexPath.section == 1) {
      // Blank space
      if (indexPath.row == 0) {
        if ([[[OMBUser currentUser].acceptedOffers allValues] count] == 0) {
          return [OMBEmptyImageTwoLabelCell heightForCell];
          // return tableView.frame.size.height -
          //   (tableView.tableHeaderView.frame.size.height + (13.0f * 2));
        }
      }
      else {
        OMBOffer *offer = [[self offers] objectAtIndex: indexPath.row - 1];
        if (![offer isExpiredForLandlord] && [offer statusForStudent] ==
          OMBOfferStatusForStudentWaitingForLandlordResponse) {
          return [OMBHomebaseLandlordOfferCell heightForCellWithNotes];
        }
        else if ([offer statusForStudent] == OMBOfferStatusForStudentOnHold) {
          return [OMBHomebaseLandlordOfferCell heightForCellWithNotes];
        }
        else if (![offer isExpiredForStudent] && [offer statusForStudent] ==
          OMBOfferStatusForStudentAccepted) {
          return [OMBHomebaseLandlordOfferCell heightForCellWithNotes];
        }
        // return [OMBHomebaseRenterTopPriorityCell heightForCell];
        return [OMBHomebaseLandlordOfferCell heightForCell];
      }
    }
    // Moved In
    else if (indexPath.section == 2) {
      // Blank space
      if (indexPath.row == 0) {
        if ([[[OMBUser currentUser].movedIn allValues] count] == 0) {
          return [OMBEmptyImageTwoLabelCell heightForCell];
          // return tableView.frame.size.height -
          //   (tableView.tableHeaderView.frame.size.height + (13.0f * 2));
        }
      }
      else {
        return [OMBHomebaseLandlordOfferCell heightForCell];
      }
    }
    // Recent Activity
    else if (indexPath.section == 99) {
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
  AMBlurView *blur = [[AMBlurView alloc] init];
  // blur.blurTintColor = [UIColor blueLight];
  blur.blurTintColor = [UIColor grayLight];
  blur.frame = CGRectMake(0.0f, 0.0f,
    tableView.frame.size.width, 13.0f * 2);
  UILabel *label = [UILabel new];
  label.font = [UIFont smallTextFontBold];
  label.frame = CGRectMake(padding, 0.0f,
    blur.frame.size.width - (padding * 2), blur.frame.size.height);
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor blueDark];
  [blur addSubview: label];
  NSString *titleString = @"";
  // Activity
  if (tableView == _activityTableView) {
    UIButton *infoButton = [UIButton new];
    CGFloat widthIcon = 18.f;
    infoButton.frame = CGRectMake(blur.frame.size.width - widthIcon - 5.f,
      4.0f, widthIcon, widthIcon);
    infoButton.layer.borderColor = [UIColor blueDark].CGColor;
    infoButton.layer.borderWidth = 1.0f;
    infoButton.layer.cornerRadius = widthIcon * 0.5f;
    infoButton.titleLabel.font = [UIFont normalTextFontBold];
    [infoButton setTitle: @"i" forState: UIControlStateNormal];
    [infoButton setTitleColor: [UIColor blueDark] forState: UIControlStateNormal];
    // Sent Applications
    if (section == 0){
      [infoButton addTarget: self action: @selector(showSentAppHowItWorks)
        forControlEvents: UIControlEventTouchUpInside];
      [blur addSubview:infoButton];
      titleString = @"Sent Applications";
    }
    // Booking Requests
    else if (section == 1) {
      [infoButton addTarget: self action: @selector(showHomebaseHowItWorks)
        forControlEvents: UIControlEventTouchUpInside];
      [blur addSubview:infoButton];
      titleString = @"Booking Requests";
    }
    else if (section == 2) {
      // titleString = @"Confirmed Places";
      titleString = @"Ready to Move In";
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
  return blur;
}

#pragma mark - Methods

#pragma mark - Instance Methods

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
    paymentsButton.backgroundColor = [UIColor clearColor];

    _activityTableView.hidden = NO;
    _paymentsTableView.hidden = YES;

    if (_activityTableView.contentSize.height <=
      _activityTableView.frame.size.height) {

      [_paymentsTableView setContentOffset: CGPointZero animated: YES];
    }
    // Change the content offset of activity table view
    // if payments table view is not scrolled pass the threshold
    else if (_paymentsTableView.contentOffset.y < threshold) {
      _activityTableView.contentOffset = _paymentsTableView.contentOffset;
    }
    // If activity table view content offset is less than threshold
    else if (_activityTableView.contentOffset.y < threshold) {
      _activityTableView.contentOffset = CGPointMake(
        _activityTableView.contentOffset.x, threshold);
    }
    // [self.navigationItem setRightBarButtonItem: nil animated: YES];
  }
  else if (selectedSegmentIndex == 1) {
    activityButton.backgroundColor = [UIColor clearColor];
    paymentsButton.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.3f];

    _activityTableView.hidden = YES;
    _paymentsTableView.hidden = NO;

    if (_paymentsTableView.contentSize.height <=
      _paymentsTableView.frame.size.height) {

      [_activityTableView setContentOffset: CGPointZero animated: YES];
    }
    // Change the content offset of activity table view
    // if payments table view is not scrolled pass the threshold
    else if (_activityTableView.contentOffset.y < threshold) {
      _paymentsTableView.contentOffset = _activityTableView.contentOffset;
    }
    // If payments table view content offset is less than threshold
    else if (_paymentsTableView.contentOffset.y < threshold) {
      _paymentsTableView.contentOffset = CGPointMake(
        _paymentsTableView.contentOffset.x, threshold);
    }

    // Show edit button to edit rental payments
    // [self.navigationItem setRightBarButtonItem: editBarButtonItem
    //   animated: YES];
  }
}

- (void) completeOfferConfirmation
{
  if (!selectedOffer)
    return;

  // Remove the offer from the user's accepted offers
  [[OMBUser currentUser] removeOffer: selectedOffer
    type: OMBUserOfferTypeAccepted];

  // Refresh the activity table view
  [_activityTableView reloadData];
  [_activityTableView reloadRowsAtIndexPaths:
    @[[NSIndexPath indexPathForRow: 0 inSection: 0]]
      withRowAnimation: UITableViewRowAnimationFade];

  selectedOffer = nil;

  // Congratulations somewhere

  [alert hideAlert];
}

- (void) confirmOffer: (UIButton *) button
{
  selectedOffer = [[OMBUser currentUser].acceptedOffers objectForKey:
    [NSNumber numberWithInt: button.tag]];
  if (selectedOffer) {
    [alert showAlert];
  }
}

- (void) editRentalPayments
{
  OMBHomebaseRenterRentDepositInfoViewController *vc =
    [[OMBHomebaseRenterRentDepositInfoViewController alloc] init];
  vc.delegate = self;
  [vc setupForEditRentalPayments];
  [self.navigationController pushViewController: vc animated: YES];
}

- (void) hideAlert
{
  [alert hideAlert];
}

- (NSArray *) movedIn
{
  return [[OMBUser currentUser].movedIn allValues];
}

- (NSArray *) offers
{
  return [[OMBUser currentUser] sortedOffersType: OMBUserOfferTypeAccepted
    withKeys: @[@"acceptedDate", @"createdAt"] ascending: NO];
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

- (void) refresh
{
  // Fetch accepted offers
  [[OMBUser currentUser] fetchAcceptedOffersWithCompletion: ^(NSError *error) {
    [_activityTableView reloadData];
    [refreshControl endRefreshing];
  }];

  // Fetch confirmed tenants
  [[OMBUser currentUser] fetchMovedInWithCompletion: ^(NSError *error) {
     [_activityTableView reloadData];
     [refreshControl endRefreshing];
   }];
}

- (void) rejectOfferConfirm
{
  if (!selectedOffer)
    return;
  // NSInteger index = [[self offers] indexOfObject: selectedOffer];
  [[OMBUser currentUser] rejectOffer: selectedOffer
    withCompletion: ^(NSError *error) {
      // If offer is rejected and no error
      if (selectedOffer.rejected && !error) {
        // [_activityTableView beginUpdates];
        // // +1 to account for the blank space
        // [_activityTableView deleteRowsAtIndexPaths:
        //   @[[NSIndexPath indexPathForRow: index + 1 inSection: 0]]
        //     withRowAnimation: UITableViewRowAnimationFade];

        // Remove the offer from the user's accepted offers
        [[OMBUser currentUser] removeOffer: selectedOffer
          type: OMBUserOfferTypeAccepted];

        // [_activityTableView endUpdates];
        [_activityTableView reloadData];

        [_activityTableView reloadRowsAtIndexPaths:
          @[[NSIndexPath indexPathForRow: 0 inSection: 0]]
            withRowAnimation: UITableViewRowAnimationFade];
        selectedOffer = nil;
      }
      else {
        NSString *message = @"Please try again.";
        if (error)
          message = error.localizedDescription;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
          @"Unsuccessful" message: message delegate: nil
            cancelButtonTitle: @"Try again" otherButtonTitles: nil];
        [alertView show];
      }
      [[self appDelegate].container stopSpinning];
    }
  ];
  [[self appDelegate].container startSpinning];
  [alert hideAlert];
}

- (void) rejectOffer: (UIButton *) button
{
  selectedOffer = [[OMBUser currentUser].acceptedOffers objectForKey:
    [NSNumber numberWithInt: button.tag]];
  if (!selectedOffer)
    return;
  alert.alertTitle.text   = @"Decline Offer";
  alert.alertMessage.text = @"Are you sure?";
  [alert.alertCancel setTitle: @"Cancel" forState: UIControlStateNormal];
  [alert.alertConfirm setTitle: @"Yes" forState: UIControlStateNormal];

  [alert addTarget: self action: @selector(hideAlert)
    forButton: alert.alertCancel];
  [alert addTarget: self action: @selector(rejectOfferConfirm)
    forButton: alert.alertConfirm];

  [alert showAlert];
}

- (void) scrollTableViewIfBelowThreshold: (UITableView *) tableView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat threshold = screen.size.height - tableView.frame.origin.y;
  if (tableView == _activityTableView) {
    NSLog(@"%f", _activityTableView.contentSize.height);
    NSLog(@"%f", _activityTableView.tableHeaderView.frame.size.height);
    CGFloat height = _activityTableView.contentSize.height -
      _activityTableView.tableHeaderView.frame.size.height;
    NSLog(@"%f", threshold);
    NSLog(@"%f", height);
    if (height < threshold) {
      CGFloat difference = threshold - height;
      if (difference < 0)
        difference = 0.0f;
      CGPoint point = CGPointMake(0.0f,
        _activityTableView.contentOffset.y - difference);
      [_activityTableView setContentOffset: point animated: YES];
    }
  }
}

- (void) segmentButtonSelected: (UIButton *) button
{
  if (selectedSegmentIndex != button.tag) {
    selectedSegmentIndex = button.tag;
    [self changeTableView];
  }
}

- (NSArray *) sentApplications
{
   return [[OMBUser currentUser].renterApplication
     sentApplicationsSortedByKey: @"createdAt" ascending: NO];
}

- (void) showAddRemoveRoommates
{
  [self.navigationController pushViewController:
    [[OMBHomebaseRenterAddRemoveRoommatesViewController alloc] init]
      animated: YES];
}

- (void) showHomebaseHowItWorks
{
  NSString *info1 = [NSString stringWithFormat:
    @"The landlord will have %@ to accept or decline your offer. "
    @"You will not be charged anything until the landlord accepts your offer. "
    @"If the landlord declines your offer, any payment authorization "
    @"will be voided.",
    [OMBOffer timelineStringForLandlord]
  ];
  NSString *info2 = [NSString stringWithFormat:
    @"If the landlord accepts your offer, you will have %@ to confirm or "
    @"reject. If you reject, you will not be charged any further.",
    [OMBOffer timelineStringForStudent]
  ];
  NSString *info3 = [NSString stringWithFormat:
    @"If you confirmed the offer, you will be asked to pay the remaining "
    @"balance. After that, you will have %@ to sign the lease we email you.",
    [OMBOffer timelineStringForStudent]
  ];
  NSArray *array = @[
    @{
      @"title": @"Accepted or Declined",
      @"information": info1
    },
    @{
      @"title": @"Confirm or Reject",
      @"information": info2
    },
    @{
      @"title": @"Pay & Sign the Lease",
      @"information": info3
    }
  ];

  OMBInformationHowItWorksViewController *vc =
    [[OMBInformationHowItWorksViewController alloc] initWithInformationArray:
      array];
  vc.title = @"Bookings";
  [(OMBNavigationController *) self.navigationController pushViewController:
     vc animated: YES ];
}

- (void) showMyRenterProfile
{
  OMBRenterProfileViewController *vc =
    [[OMBRenterProfileViewController alloc] init];
  [vc loadUser: [OMBUser currentUser]];
  [self.navigationController pushViewController: vc animated: YES];
}

- (void) showPayPalPayment
{
  if (!selectedOffer)
    return;

  [UIView animateWithDuration: 0.25f animations: ^{
    alert.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    if (finished)
      alert.hidden = YES;
  }];
  cameFromSettingUpPayoutMethods = YES;

  // Present the PayPalPaymentViewController.
  NSString *shortDescription =
    [selectedOffer.residence.address capitalizedString];
  [self presentViewController:
    [self payPalPaymentViewControllerWithAmount: [selectedOffer totalAmount]
      intent: PayPalPaymentIntentSale shortDescription: shortDescription
        delegate: self] animated: YES completion: nil];
}

- (void) showRentDepositInfo: (NSInteger) index
{
  OMBHomebaseRenterRentDepositInfoViewController *vc =
    [[OMBHomebaseRenterRentDepositInfoViewController alloc] init];
  vc.delegate = self;
  [self.navigationController pushViewController: vc animated: YES];
}

- (void) showPayoutMethods
{
  [UIView animateWithDuration: 0.25f animations: ^{
    alert.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    if (finished)
      alert.hidden = YES;
  }];
  cameFromSettingUpPayoutMethods = YES;
  [[self appDelegate].container showPayoutMethods];
}

- (void) showSentAppHowItWorks
{
  NSString *info1 = [NSString stringWithFormat:
                     @"Find a property that’s right for you and apply! "
                     @"Once you submit an application it will "
                     @"be sent to the landlord to review."];
  NSString *info2 = [NSString stringWithFormat:
                     @"If the landlord approves your application and chooses "
                     @"you as a tenant you will be given 4 days "
                     @"to pay the first month’s rent & deposit and sign the lease."];
                     //[OMBOffer timelineStringForLandlord]
  NSString *info3 = [NSString stringWithFormat:
                     @"Once you’ve paid the place is yours, get ready to move-in!"];
  
  NSArray *array = @[
   @{
     @"title": @"Send an Application",
     @"information": info1
     },
   @{
     @"title": @"Landlord Approved",
     @"information": info2
     },
   @{
     @"title": @"Move In!",
     @"information": info3
     }
   ];
  
  OMBInformationHowItWorksViewController *vc =
    [[OMBInformationHowItWorksViewController alloc] initWithInformationArray:
      array];
  vc.title = @"Applications";
  [(OMBNavigationController *) self.navigationController pushViewController:
    vc animated: YES ];
}

- (void) switchToPaymentsTableView
{
  selectedSegmentIndex = 1;
  [self changeTableView];
  [_paymentsTableView setContentOffset: CGPointZero animated: NO];
}

@end
