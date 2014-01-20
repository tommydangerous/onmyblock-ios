//
//  OMBHomebaseLandlordViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseLandlordViewController.h"

#import "AMBlurView.h"
#import "DRNRealTimeBlurView.h"
#import "NSString+Extensions.h"
#import "OMBCenteredImageView.h"
#import "OMBHomebaseLandlordConfirmedTenantsViewController.h"
#import "OMBHomebaseLandlordOfferCell.h"
#import "OMBHomebaseLandlordPaymentCell.h"
#import "OMBInboxViewController.h"
#import "OMBOfferInquiryViewController.h"
#import "UIColor+Extensions.h"

@implementation OMBHomebaseLandlordViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Homebase Landlord";
  self.title      = @"Homebase";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setMenuBarButtonItem];

  inboxBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Inbox" 
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(showInbox)];
  self.navigationItem.rightBarButtonItem = inboxBarButtonItem;

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
    screenWidth, (screenHeight * 0.4f) + backViewOffsetY);
  [self.view addSubview: backView];
  // Image of residence
  OMBCenteredImageView *residenceImageView = 
    [[OMBCenteredImageView alloc] init];
  residenceImageView.frame = backView.frame;  
  residenceImageView.image = [UIImage imageNamed: 
    @"intro_still_image_slide_1_background.jpg"];
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
  // Need to do this or else blur is off
  backView.frame = CGRectMake(0.0f, backViewOffsetY,
    backView.frame.size.width, backView.frame.size.height);

  // Buttons
  buttonsView = [UIView new];
  buttonsView.clipsToBounds = YES;
  buttonsView.frame = CGRectMake(padding, 
    (backView.frame.origin.y + backView.frame.size.height - backViewOffsetY) - 
    (standardHeight + padding), screenWidth - (padding * 2), standardHeight);
  buttonsView.layer.borderColor = [UIColor whiteColor].CGColor;
  buttonsView.layer.borderWidth = 1.0f;
  buttonsView.layer.cornerRadius = buttonsView.frame.size.height * 0.5f;
  [self.view addSubview: buttonsView];
  UIView *middleDivider = [UIView new];
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
  [activityButton setTitleColor: [UIColor whiteColor] 
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
  [paymentsButton setTitleColor: [UIColor whiteColor] 
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
  UIView *activityTableViewHeader = [UIView new];
  activityTableViewHeader.frame = CGRectMake(0.0f, 0.0f,
    _activityTableView.frame.size.width, 
      (backView.frame.origin.y + backView.frame.size.height) -
      (tableViewOriginY + backViewOffsetY));
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
  UIView *paymentTableViewHeader = [UIView new];
  paymentTableViewHeader.frame = activityTableViewHeader.frame;
  _paymentsTableView.tableHeaderView = paymentTableViewHeader;

  // Welcome view
  welcomeView = [UIView new];
  welcomeView.frame = CGRectMake(0.0f, backViewOffsetY,
    screenWidth, buttonsView.frame.origin.y - (padding + standardHeight));
  [self.view addSubview: welcomeView];

  CGFloat totalLabelHeights = 27.0f + (22.0f * 2);

  UILabel *label1 = [UILabel new];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  label1.frame = CGRectMake(0.0f, 
    (welcomeView.frame.size.height - totalLabelHeights) * 0.5f, 
      welcomeView.frame.size.width, 27.0f);
  label1.text = @"Welcome to your Homebase!";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor whiteColor];
  [welcomeView addSubview: label1];

  UILabel *label2 = [UILabel new];
  NSString *label2String = @"See all of your offers,\n"
    @"messages, and payments here.";
  label2.attributedText = [label2String attributedStringWithFont: 
    [UIFont fontWithName: @"HelveticaNeue-Light" size: 15] lineHeight: 22.0f];
  label2.frame = CGRectMake(0.0f, 
    label1.frame.origin.y + label1.frame.size.height, 
      welcomeView.frame.size.width, 22.0f * 2);
  label2.numberOfLines = 2;
  label2.textColor = label1.textColor;
  label2.textAlignment = label1.textAlignment;
  [welcomeView addSubview: label2];

  [self changeTableView];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];
  // [self tableView: _activityTableView didSelectRowAtIndexPath:
  //   [NSIndexPath indexPathForRow: 0 inSection: 0]];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding        = 20.0f;
  CGFloat standardHeight = 44.0f;
  CGFloat y = scrollView.contentOffset.y;

  if (scrollView == _activityTableView || scrollView == _paymentsTableView) {
    CGFloat originalButtonsViewOriginY = screen.size.height * 0.4f;
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

    // Move the welcome view
    CGFloat originalWelcomeViewOriginY = backViewOffsetY;
    CGFloat welcomeViewNewOriginY = backViewOffsetY - y;
    if (welcomeViewNewOriginY > originalWelcomeViewOriginY)
      welcomeViewNewOriginY = originalWelcomeViewOriginY;
    CGRect welcomeViewRect = welcomeView.frame;
    welcomeViewRect.origin.y = welcomeViewNewOriginY;
    welcomeView.frame = welcomeViewRect;

    // Move the back view image
    CGFloat adjustment = y / 3.0f;
    if (y > maxDistanceForBackView)
      adjustment = maxDistanceForBackView / 3.0f;
    CGRect backViewRect = backView.frame;
    backViewRect.origin.y = backViewOffsetY - adjustment;
    backView.frame = backViewRect;
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Activity
  if (tableView == _activityTableView) {
    // Inquiries
    // Confirmed Tenants
    // return 2;
    return 1;
  }
  // Payments
  else if (tableView == _paymentsTableView) {
    // Pending Payments
    // Previous Payments
    // Late Payments
    return 3;
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
    // Offers & Inquiries
    if (indexPath.section == 0) {
      static NSString *OfferCellIdentifier = @"OfferCellIdentifier";
      OMBHomebaseLandlordOfferCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier:
          OfferCellIdentifier];
      if (!cell1)
        cell1 = [[OMBHomebaseLandlordOfferCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: OfferCellIdentifier];
      [cell1 loadOfferData];
      return cell1;
    }
    // Confirmed Tenants
    else if (indexPath.section == 1) {
      static NSString *OfferCellIdentifier = @"OfferCellIdentifier";
      OMBHomebaseLandlordOfferCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier:
          OfferCellIdentifier];
      if (!cell1)
        cell1 = [[OMBHomebaseLandlordOfferCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: OfferCellIdentifier];
      [cell1 loadConfirmedTenantData];
      return cell1;
    }
  }
  // Payments
  else if (tableView == _paymentsTableView) {
    // Pending Payments
    if (indexPath.section == 0) {
      static NSString *PendingPaymentCellIdentifier = 
        @"PendingPaymentCellIdentifier";
      OMBHomebaseLandlordPaymentCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier:
          PendingPaymentCellIdentifier];
      if (!cell1)
        cell1 = [[OMBHomebaseLandlordPaymentCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: 
            PendingPaymentCellIdentifier];
      [cell1 loadPendingPaymentData];
      return cell1;
    }
    // Previous Payments
    else if (indexPath.section == 1) {
      static NSString *PreviousPaymentCellIdentifier = 
        @"PreviousPaymentCellIdentifier";
      OMBHomebaseLandlordPaymentCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier:
          PreviousPaymentCellIdentifier];
      if (!cell1)
        cell1 = [[OMBHomebaseLandlordPaymentCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: 
            PreviousPaymentCellIdentifier];
      [cell1 loadPreviousPaymentData];
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
    // Offers & Inquiries
    if (section == 0) {
      return 5;
    }
    // Confirmed Tenants
    else if (section == 1) {
      return 2;
    }
  }
  // Payments
  else if (tableView == _paymentsTableView) {
    // Pending Payments
    if (section == 0) {
      return 2;
    }
    // Previous Payments
    else if (section == 1) {
      return 5;
    }
    // Late Payments
    else if (section == 2) {
      return 1;
    }
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (tableView == _activityTableView) {
    // Offers & Inquiries
    if (indexPath.section == 0) {
      [self.navigationController pushViewController:
        [[OMBOfferInquiryViewController alloc] initWithOffer: nil]
          animated: YES];
    }
    // Confirmed Tenants
    else if (indexPath.section == 1) {
      [self.navigationController pushViewController:
        [[OMBHomebaseLandlordConfirmedTenantsViewController alloc] init]
          animated: YES];
    }
  }
  else if (tableView == _paymentsTableView) {

  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView 
heightForHeaderInSection: (NSInteger) section
{
  // Activity
  if (tableView == _activityTableView) {
    return 13.0f * 2;
  }
  // Payments
  else if (tableView == _paymentsTableView) {
    return 13.0f * 2;
  }
  return 0.0f;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Activity
  if (tableView == _activityTableView) {
    // Offers & Inquiries
    if (indexPath.section == 0) {
      return [OMBHomebaseLandlordOfferCell heightForCell];
    }
    // Confirmed Tenants
    else if (indexPath.section == 1) {
      return [OMBHomebaseLandlordOfferCell heightForCell];
    }
  }
  // Payments
  else if (tableView == _paymentsTableView) {
    // Pending Payments
    if (indexPath.section == 0) {
      return [OMBHomebaseLandlordPaymentCell heightForCell];
    }
    // Previous Payments
    else if (indexPath.section == 1) {
      return [OMBHomebaseLandlordPaymentCell heightForCell];
    }
    // Late Payments
    else if (indexPath.section == 2) {

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
    if (section == 0) {
      titleString = @"Offers";
    }
    else if (section == 1) {
      titleString = @"Confirmed Tenants";
    }
  }
  // Payments
  else if (tableView == _paymentsTableView) {
    if (section == 0) {
      titleString = @"Upcoming Payments";
    }
    else if (section == 1) {
      titleString = @"Received Payments";
    }
    else if (section == 2) {
      titleString = @"Late Payments";
    }
  }
  label.text = titleString;
  return blurView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) changeTableView
{
  CGFloat padding = 20.0f;
  if (selectedSegmentIndex == 0) {
    activityButton.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.5f];
    _activityTableView.hidden = NO;
    paymentsButton.backgroundColor = [UIColor clearColor];
    _paymentsTableView.hidden = YES;
    // Change the content offset of activity table view 
    // if payments table view is not scrolled pass the threshold
    CGFloat threshold = ((backView.frame.size.height - backViewOffsetY) - 
      (padding + buttonsView.frame.size.height + padding));
    if (_paymentsTableView.contentOffset.y < threshold) {
      _activityTableView.contentOffset = _paymentsTableView.contentOffset;
    }
    // If activity table view content offset is less than threshold
    else if (_activityTableView.contentOffset.y < threshold) {
      _activityTableView.contentOffset = CGPointMake(
        _activityTableView.contentOffset.x, threshold);
    }
  }
  else if (selectedSegmentIndex == 1) {
    activityButton.backgroundColor = [UIColor clearColor];
    _activityTableView.hidden = YES;
    paymentsButton.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.5f];
    _paymentsTableView.hidden = NO;
    // Change the content offset of payments table view 
    // if activity table view is not scrolled pass the threshold
    CGFloat threshold = ((backView.frame.size.height - backViewOffsetY) - 
      (padding + buttonsView.frame.size.height + padding));
    if (_activityTableView.contentOffset.y < threshold) {
      _paymentsTableView.contentOffset = _activityTableView.contentOffset;
    }
    // If payments table view content offset is less than threshold
    else if (_paymentsTableView.contentOffset.y < threshold) {
      _paymentsTableView.contentOffset = CGPointMake(
        _paymentsTableView.contentOffset.x, threshold);
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

- (void) showInbox
{
  [self.navigationController pushViewController:
    [[OMBInboxViewController alloc] init] animated: YES];
}

@end
