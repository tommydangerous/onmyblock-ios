//
//  OMBOfferInquiryViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOfferInquiryViewController.h"

#import "AMBlurView.h"
#import "LEffectLabel.h"
#import "NSString+Extensions.h"
#import "OMBActivityView.h"
#import "OMBAlertView.h"
#import "OMBAlertViewBlur.h"
#import "OMBCenteredImageView.h"
#import "OMBCoapplicantCell.h"
#import "OMBResidenceConfirmDetailsDatesCell.h"
#import "OMBCosigner.h"
#import "OMBCosignerCell.h"
#import "OMBEmploymentCell.h"
#import "OMBGradientView.h"
#import "OMBHomebaseLandlordConfirmedTenantCell.h"
#import "OMBLegalQuestion.h"
#import "OMBLegalQuestionAndAnswerCell.h"
#import "OMBLegalQuestionStore.h"
#import "OMBMessageDetailViewController.h"
#import "OMBMessageStore.h"
#import "OMBOffer.h"
#import "OMBOfferInquiryResidenceCell.h"
#import "OMBUserDetailViewController.h"
#import "OMBPayoutMethod.h"
#import "OMBPayoutMethodsViewController.h"
#import "OMBPayoutTransaction.h"
#import "OMBPayPalVerifyMobilePaymentConnection.h"
#import "OMBPreviousRentalCell.h"
#import "OMBRenterApplication.h"
#import "OMBResidence.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBRoommate.h"
#import "OMBRoommateCell.h"
#import "OMBViewController+PayPalPayment.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"

@implementation OMBOfferInquiryViewController

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object
{
  if (!(self = [super init])) return nil;

  offer = object;

  // Student
  if ([self offerBelongsToCurrentUser]) {
    // Expired
    if ([offer isExpiredForStudent]) {
      self.title = @"Offer Expired";
    }
    else {
      if ([offer statusForStudent] == OMBOfferStatusForStudentOfferPaid) {
        self.title = @"Moved In";
      }
      else {
        self.title = [[offer statusStringForStudent] capitalizedString];
      }
    }
  }
  // Landlord
  else {
    // Expired
    if ([offer isExpiredForLandlord]) {
      self.title = @"Offer Expired";
    }
    else {
      if ([offer statusForLandlord] == OMBOfferStatusForLandlordOfferPaid) {
        self.title = @"Confirmed Tenant";
      }
      else {
        self.title = [[offer statusStringForLandlord] capitalizedString];
      }
    }
  }

  // When the Venmo payment info is sent to our web servers and verified
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(offerPaidWithVenmo:)
      name: OMBOfferNotificationPaidWithVenmo object: nil];

  // When a user comes back from the Venmo iOS App and they made a payment
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(offerProcessingWithServer:)
      name: OMBOfferNotificationProcessingWithServer object: nil];

  // When the user cancels the Venmo app from the Venmo iOS app
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(venmoAppSwitchCancelled:)
      name: OMBOfferNotificationVenmoAppSwitchCancelled object: nil];

  // When a landlor adds their first payout method
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(userAddedFirstPayoutMethod)
      name: OMBPayoutMethodNotificationFirst object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"MMM d, yyyy";

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
  backView.frame = CGRectMake(0.0f, backViewOffsetY,
                              screenWidth, screenHeight * 0.4f);
  [self.view addSubview: backView];
  // Image of user
  userImageView =
  [[OMBCenteredImageView alloc] init];
  userImageView.frame = CGRectMake(0.0f, 0.0f, backView.frame.size.width,
                                   backView.frame.size.height);
  [backView addSubview: userImageView];

  gradient = [[OMBGradientView alloc] init];
  gradient.frame = userImageView.frame;
  gradient.colors = @[
                      [UIColor colorWithWhite: 0.0f alpha: 0.0f],
                      [UIColor colorWithWhite: 0.0f alpha: 0.5f]
                      ];
  [backView addSubview: gradient];

  // Buttons
  buttonsView = [UIView new];
  buttonsView.clipsToBounds = YES;
  buttonsView.frame = CGRectMake(padding,
                                 (backView.frame.origin.y + backView.frame.size.height) -
                                 (standardHeight + padding),
                                 screenWidth - (padding * 2), standardHeight);
  buttonsView.layer.borderColor = [UIColor whiteColor].CGColor;
  buttonsView.layer.borderWidth = 1.0f;
  buttonsView.layer.cornerRadius = buttonsView.frame.size.height * 0.5f;
  [self.view addSubview: buttonsView];

  CGFloat buttonWidth = buttonsView.frame.size.width / 3.0f;

  UIView *border1 = [UIView new];
  border1.backgroundColor = [UIColor whiteColor];
  border1.frame = CGRectMake(buttonWidth * 1, 0.0f,
                             1.0f, buttonsView.frame.size.height);
  [buttonsView addSubview: border1];
  UIView *border2 = [UIView new];
  border2.backgroundColor = [UIColor whiteColor];
  border2.frame = CGRectMake(buttonWidth * 2, 0.0f,
                             1.0f, buttonsView.frame.size.height);
  [buttonsView addSubview: border2];

  // Offer button
  offerButton = [UIButton new];
  offerButton.frame = CGRectMake(0.0f, 0.0f,
                                 buttonWidth, buttonsView.frame.size.height);
  offerButton.tag = 0;
  offerButton.titleLabel.font = [UIFont normalTextFontBold];
  [offerButton addTarget: self action: @selector(segmentButtonSelected:)
        forControlEvents: UIControlEventTouchUpInside];
  [offerButton setTitle: @"Offer" forState: UIControlStateNormal];
  [offerButton setTitleColor: [UIColor whiteColor]
                    forState: UIControlStateNormal];
  [buttonsView addSubview: offerButton];

  // Profile button
  profileButton = [UIButton new];
  profileButton.frame = CGRectMake(
                                   offerButton.frame.origin.x + offerButton.frame.size.width,
                                   offerButton.frame.origin.y,
                                   offerButton.frame.size.width, offerButton.frame.size.height);
  profileButton.tag = 1;
  profileButton.titleLabel.font = offerButton.titleLabel.font;
  [profileButton addTarget: self action: @selector(segmentButtonSelected:)
          forControlEvents: UIControlEventTouchUpInside];
  [profileButton setTitle: @"Applicants" forState: UIControlStateNormal];
  [profileButton setTitleColor: [UIColor whiteColor]
                      forState: UIControlStateNormal];
  [buttonsView addSubview: profileButton];

  // Contact button
  contactButton = [UIButton new];
  contactButton.frame = CGRectMake(
                                   profileButton.frame.origin.x + profileButton.frame.size.width,
                                   profileButton.frame.origin.y,
                                   profileButton.frame.size.width, profileButton.frame.size.height);
  contactButton.tag = 2;
  contactButton.titleLabel.font = profileButton.titleLabel.font;
  [contactButton addTarget: self action: @selector(segmentButtonSelected:)
          forControlEvents: UIControlEventTouchUpInside];
  [contactButton setTitle: @"Contact" forState: UIControlStateNormal];
  [contactButton setTitleColor: [UIColor whiteColor]
                      forState: UIControlStateNormal];
  [buttonsView addSubview: contactButton];

  CGFloat tableViewOriginY = backView.frame.origin.y +
  padding + buttonsView.frame.size.height + padding;
  CGRect tableViewFrame = CGRectMake(0.0f, tableViewOriginY,
                                     screenWidth, screenHeight - tableViewOriginY);
  // Offer table view
  _offerTableView = [[UITableView alloc] initWithFrame: tableViewFrame
                                                 style: UITableViewStylePlain];
  _offerTableView.alwaysBounceVertical = YES;
  _offerTableView.backgroundColor      = [UIColor clearColor];
  _offerTableView.dataSource           = self;
  _offerTableView.delegate             = self;
  _offerTableView.separatorColor       = [UIColor grayLight];
  _offerTableView.separatorInset = UIEdgeInsetsMake(0.0f, padding,
                                                    0.0f, 0.0f);
  _offerTableView.showsVerticalScrollIndicator = NO;
  [self.view insertSubview: _offerTableView belowSubview: buttonsView];
  // Offer table header view
  UIView *offerHeader = [UIView new];
  offerHeader.frame = CGRectMake(0.0f, 0.0f, _offerTableView.frame.size.width,
                                 (backView.frame.origin.y + backView.frame.size.height) - tableViewOriginY);
  _offerTableView.tableHeaderView = offerHeader;

  // Profile table view
  _profileTableView = [[UITableView alloc] initWithFrame: tableViewFrame
                                                   style: UITableViewStylePlain];
  _profileTableView.alwaysBounceVertical = _offerTableView.alwaysBounceVertical;
  _profileTableView.backgroundColor = _offerTableView.backgroundColor;
  _profileTableView.dataSource = self;
  _profileTableView.delegate = self;
  _profileTableView.hidden = YES;
  _profileTableView.separatorColor = _offerTableView.separatorColor;
  _profileTableView.separatorInset = UIEdgeInsetsMake(0.f, padding, 
    0.f, padding);
  _profileTableView.showsVerticalScrollIndicator =
  _offerTableView.showsVerticalScrollIndicator;
  [self.view insertSubview: _profileTableView belowSubview: buttonsView];
  // Profile table header view
  UIView *profileHeader = [UIView new];
  profileHeader.frame = offerHeader.frame;
  _profileTableView.tableHeaderView = profileHeader;

  // Respond view
  CGFloat respondHeight = OMBStandardButtonHeight;
  respondView = [UIView new];
  respondView.backgroundColor = [UIColor blueAlpha: 0.95f];
  respondView.clipsToBounds = YES;
  respondView.frame = CGRectMake(0.0f, screenHeight - respondHeight,
    screenWidth, respondHeight);
  // respondView.frame = CGRectMake(padding,
  //   screenHeight - (standardHeight + padding), screenWidth - (padding * 2),
  //     standardHeight);
  // respondView.layer.borderColor = [UIColor blue].CGColor;
  // respondView.layer.borderWidth = 1.0f;
  // respondView.layer.cornerRadius = respondView.frame.size.height * 0.5f;
  [self.view addSubview: respondView];

  // Respond button
  respondButton = [UIButton new];
  respondButton.frame = CGRectMake(0.0f, 0.0f,
    respondView.frame.size.width, respondView.frame.size.height);
  respondButton.titleLabel.font = [UIFont mediumTextFontBold];
  [respondButton addTarget: self action: @selector(respond)
    forControlEvents: UIControlEventTouchUpInside];
  [respondButton setBackgroundImage:
    [UIImage imageWithColor: [UIColor blueHighlightedAlpha: 0.3f]]
      forState: UIControlStateHighlighted];
  [respondButton setTitleColor: [UIColor whiteColor]
                      forState: UIControlStateNormal];
  [respondView addSubview: respondButton];

  // Effect label
  effectLabel = [[LEffectLabel alloc] init];
  effectLabel.effectColor = [UIColor grayMedium];
  effectLabel.effectDirection = EffectDirectionLeftToRight;
  effectLabel.font = [UIFont mediumTextFontBold];
  effectLabel.frame = respondButton.frame;
  effectLabel.sizeToFit = NO;
  effectLabel.textColor = [UIColor whiteColor];
  effectLabel.textAlignment = NSTextAlignmentCenter;
  [respondView insertSubview: effectLabel belowSubview: respondButton];

  // Countdown timer label
  countDownTimerLabel = [[UILabel alloc] init];
  countDownTimerLabel.backgroundColor = [UIColor greenAlpha: 0.8f];
  countDownTimerLabel.font = [UIFont normalTextFontBold];
  countDownTimerLabel.frame = CGRectMake(0.0f,
    respondView.frame.origin.y - padding, screenWidth, padding);
  countDownTimerLabel.textColor = [UIColor whiteColor];
  countDownTimerLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview: countDownTimerLabel];

  // Offer table footer view
  _offerTableView.tableFooterView = [[UIView alloc] initWithFrame:
   CGRectMake(0.0f, 0.0f, screenWidth,
    countDownTimerLabel.frame.size.height + respondView.frame.size.height)];
  _offerTableView.tableFooterView.backgroundColor =
    [UIColor grayUltraLight];
  // Profile table footer view
  _profileTableView.tableFooterView = [[UIView alloc] initWithFrame:
    _offerTableView.tableFooterView.frame];
  _profileTableView.tableFooterView.backgroundColor =
    _offerTableView.tableFooterView.backgroundColor;

  previouslySelectedIndex = selectedSegmentIndex = 0;

  // Alert view
  alert = [[OMBAlertView alloc] init];
  [alert addTarget: self action: @selector(alertCancelSelected)
         forButton: alert.alertCancel];
  [alert addTarget: self action: @selector(alertConfirmSelected)
         forButton: alert.alertConfirm];

  // Alert view blur
  alertBlur = [[OMBAlertViewBlur alloc] init];

  activityView = [[OMBActivityView alloc] init];
  [self.view addSubview: activityView];

  [self changeTableView];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  firstTimeAlert = YES;

  // Size for offer note
  sizeForOfferNotes = [offer.note boundingRectWithSize:
    CGSizeMake(_offerTableView.frame.size.width - (OMBPadding * 2), 9999)
      font: [UIFont smallTextFont]].size;

  [self setupSizeForRememberDetails];

  BOOL performEffect = YES;
  // Student
  if ([self offerBelongsToCurrentUser]) {
    switch ([offer statusForStudent]) {
        // Accepted
      case OMBOfferStatusForStudentAccepted: {
        if ([offer isExpiredForStudent]) {
          [self hideCountdownAndRespondButton];
        }
        else {
          // [respondButton setTitle: @"Confirm and Pay or Reject"
            // forState: UIControlStateNormal];
          effectLabel.text = @"Confirm or Reject";
          respondView.backgroundColor = [UIColor blueAlpha: 0.95f];
        }
        break;
      }
        // Waiting for landlord
      case OMBOfferStatusForStudentWaitingForLandlordResponse: {
        // [respondButton setTitle: @"Waiting for landlord response" forState:
        //   UIControlStateNormal];
        effectLabel.text = @"Waiting for landlord approval";
        performEffect = NO;
        respondView.backgroundColor = [UIColor blueLight];
        respondButton.userInteractionEnabled = NO;
        break;
      }
      default: {
        [self hideCountdownAndRespondButton];
        break;
      }
    }
  }
  // Landlord
  else {
    switch ([offer statusForLandlord]) {
        // Accepted
      case OMBOfferStatusForLandlordAccepted: {
        if ([offer isExpiredForStudent]) {
          [self hideCountdownAndRespondButton];
        }
        else {
          // [respondButton setTitle: @"Waiting for student response" forState:
          //   UIControlStateNormal];
          effectLabel.text = @"Waiting for student response";
          performEffect = NO;
          respondView.backgroundColor = [UIColor blueLightAlpha: 0.95f];
          respondButton.userInteractionEnabled = NO;
        }
        break;
      }
        // Landlord needs to do something
      case OMBOfferStatusForLandlordResponseRequired: {
        // [respondButton setTitle: @"Accept or Decline"
        //   forState: UIControlStateNormal];
        effectLabel.text = @"Accept or Decline";
        respondView.backgroundColor = [UIColor blueAlpha: 0.95f];
        break;
      }
      default: {
        [self hideCountdownAndRespondButton];
        break;
      }
    }
  }

  if (performEffect) {
    [effectLabel performEffectAnimation];
  }

  // User image view
  if ([self user].image) {
    userImageView.image = [self user].image;
  }
  else {
    [[self user] downloadImageFromImageURLWithCompletion: ^(NSError *error) {
      userImageView.image = [self user].image;
    }];
  }

  // After setting up a payout method
  if (cameFromSettingUpPayoutMethods) {
    // If student
    if ([self offerBelongsToCurrentUser]) {
      [alertBlur showBothButtons];
      [self confirmOfferFinalAnswer];
    }
    // If landlord
    else {
      [alertBlur showBothButtons];
      [self acceptOfferFinalAnswer];
    }
    alertBlur.hidden = NO;
    [UIView animateWithDuration: 0.25f animations: ^{
      alertBlur.alpha = 1.0f;
    }];
    cameFromSettingUpPayoutMethods = NO;
  }

  // Timer
  [self timerFireMethod: nil];
  countdownTimer = [NSTimer timerWithTimeInterval: 1 target: self
    selector: @selector(timerFireMethod:) userInfo: nil repeats: YES];
  // NSRunLoopCommonModes, mode used for tracking events
  [[NSRunLoop currentRunLoop] addTimer: countdownTimer
    forMode: NSRunLoopCommonModes];
}

#pragma mark - Protocol

#pragma mark - Protocol Connection

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  [[self renterApplication] readFromDictionary: dictionary
    forModelName: [OMBRoommate modelName]];
  [_profileTableView reloadData];
}

#pragma mark - Protocol PayPalPaymentDelegate

- (void) payPalPaymentViewController: (PayPalPaymentViewController *)
paymentViewController
didCompletePayment: (PayPalPayment *) completedPayment
{
  offer.paymentConfirmation = completedPayment.confirmation;
  [paymentViewController dismissViewControllerAnimated: YES completion: ^{
    [self charge];
  }];
}

- (void) payPalPaymentDidCancel: (PayPalPaymentViewController *)
paymentViewController
{
  [paymentViewController dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGFloat padding        = 20.0f;
  CGFloat standardHeight = 44.0f;
  CGFloat y = scrollView.contentOffset.y;
  if (scrollView == _offerTableView || scrollView == _profileTableView) {
    CGFloat originalButtonsViewOriginY =
    (backViewOffsetY + backView.frame.size.height) -
    (buttonsView.frame.size.height + padding);
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
    CGFloat newScale = 1 + ((y * -3.0f) / userImageView.frame.size.height);
    if (newScale < 1)
      newScale = 1;
    gradient.transform = CGAffineTransformScale(
                                                CGAffineTransformIdentity, newScale, newScale);
    userImageView.transform = CGAffineTransformScale(
                                                     CGAffineTransformIdentity, newScale, newScale);
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Offer
  if (tableView == _offerTableView) {
    return 1;
  }
  // Profile
  else if (tableView == _profileTableView) {
    return 1;
    // Name, school, about
    // Co-signers
    // Co-applicants
    // Pets
    // Rental history
    // Work history
    // Legal stuff
    // return 7;
  }
  return 0;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat padding = OMBPadding;
  NSUInteger row  = indexPath.row;

  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
      reuseIdentifier: CellIdentifier];
  cell.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  cell.detailTextLabel.text = @"";
  cell.detailTextLabel.textColor = [UIColor blueDark];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  cell.textLabel.numberOfLines = 1;
  cell.textLabel.text = @"";
  cell.textLabel.textColor = [UIColor textColor];
  // Offer
  if (tableView == _offerTableView) {
    if (indexPath.section == OMBOfferInquirySectionOffer) {
      // Residence
      if (indexPath.row == OMBOfferInquirySectionOfferRowResidence) {
        static NSString *ResidenceCellIdentifier = @"ResidenceCellIdentifier";
        OMBOfferInquiryResidenceCell *cell1 =
        [tableView dequeueReusableCellWithIdentifier:
         ResidenceCellIdentifier];
        if (!cell1)
          cell1 = [[OMBOfferInquiryResidenceCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier:
              ResidenceCellIdentifier];
        [cell1 loadResidence: [self residence]];
        cell1.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        cell1.clipsToBounds = YES;
        return cell1;
      }
      // Move-in date, move-out date, lease months
      else if (indexPath.row == OMBOfferInquirySectionOfferRowDates) {
        static NSString *DatesID = @"DatesID";
        OMBResidenceConfirmDetailsDatesCell *cell1 =
          [tableView dequeueReusableCellWithIdentifier: DatesID];
        if (!cell1) {
          cell1 = [[OMBResidenceConfirmDetailsDatesCell alloc] initWithStyle:
                   UITableViewCellStyleDefault reuseIdentifier: DatesID];
          // [cell1 loadResidence: [self residence]];
          cell1.leaseMonthsLabel.text = [NSString stringWithFormat:
            @"%i month lease", [self numberOfMonthsBetweenMovingDates]];
          // Move in date
          cell1.moveInBackground.backgroundColor  = [UIColor whiteColor];
          cell1.moveInDateLabel.text = [dateFormatter stringFromDate:
            [NSDate dateWithTimeIntervalSince1970: [self moveInDate]]];
          cell1.moveInDateLabel.textColor = [UIColor blue];
          // Move out date
          cell1.moveOutDateLabel.text = [dateFormatter stringFromDate:
            [NSDate dateWithTimeIntervalSince1970: [self moveOutDate]]];
          cell1.moveOutDateLabel.textColor =   [UIColor blue];
          cell1.moveOutBackground.backgroundColor  = [UIColor whiteColor];
        }
        cell1.clipsToBounds = YES;
        return cell1;
      }
      // Spacing below dates
      else if (indexPath.row == OMBOfferInquirySectionOfferSpacingBelowDates) {
        cell.backgroundColor = [UIColor grayUltraLight];
        cell.separatorInset  = UIEdgeInsetsMake(0.0f,
                                                tableView.frame.size.width, 0.0f, 0.0f);
      }
      // Price breakdown, security deposit, down payment, remaining payment, offer
      else if (
               indexPath.row == OMBOfferInquirySectionOfferRowPriceBreakdown ||
               indexPath.row == OMBOfferInquirySectionOfferRowSecurityDeposit ||
               indexPath.row == OMBOfferInquirySectionOfferRowOffer ||
               indexPath.row == OMBOfferInquirySectionOfferRowDownPayment ||
               indexPath.row == OMBOfferInquirySectionOfferRowRemainingPayment) {

        static NSString *PriceCellIdentifier = @"PriceCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 PriceCellIdentifier];
        if (!cell) {
          cell = [[UITableViewCell alloc] initWithStyle:
                  UITableViewCellStyleValue1 reuseIdentifier: PriceCellIdentifier];
        }
        UIView *bor = [cell.contentView viewWithTag: 9999];
        if (!bor) {
          bor = [UIView new];
          bor.backgroundColor = [UIColor grayLight];
          bor.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 0.5f);
          bor.tag = 9999;
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.detailTextLabel.font =
          [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == OMBOfferInquirySectionOfferRowPriceBreakdown) {
          cell.textLabel.font = [UIFont normalTextFontBold];
          [bor removeFromSuperview];
          [cell.contentView addSubview: bor];
        }
        else
          cell.textLabel.font = [UIFont normalTextFont];
        cell.detailTextLabel.text = @"";
        cell.detailTextLabel.textColor = [UIColor textColor];
        cell.textLabel.textColor = [UIColor textColor];
        if (indexPath.row == OMBOfferInquirySectionOfferRowPriceBreakdown) {
          cell.textLabel.text = @"Price Breakdown";
        }
        else if (indexPath.row == OMBOfferInquirySectionOfferRowOffer) {
          cell.detailTextLabel.text = [NSString numberToCurrencyString:
            [self rentAmount]];
          cell.textLabel.text = @"1st Month's Rent";
        }
        else if (indexPath.row ==
          OMBOfferInquirySectionOfferRowSecurityDeposit) {

          cell.detailTextLabel.text = [NSString numberToCurrencyString:
            [[self residence] deposit]];
          cell.textLabel.text = @"Security Deposit";
        }
        else if (indexPath.row ==
          OMBOfferInquirySectionOfferRowDownPayment) {

          cell.detailTextLabel.text = [NSString numberToCurrencyString:
            [offer downPaymentAmount]];
          cell.textLabel.text = @"Down Payment";
        }
        else if (indexPath.row ==
          OMBOfferInquirySectionOfferRowRemainingPayment) {

          cell.detailTextLabel.text = [NSString numberToCurrencyString:
            [offer remainingBalanceAmount]];
          cell.textLabel.text = @"Remaining Payment";
        }
        cell.clipsToBounds = YES;
        return cell;
      }
      // Total
      else if (indexPath.row == OMBOfferInquirySectionOfferRowTotal) {
        static NSString *TotalCellIdentifier = @"TotalCellIdentifier";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
                                  TotalCellIdentifier];
        if (!cell1) {
          cell1 = [[UITableViewCell alloc] initWithStyle:
                   UITableViewCellStyleValue1 reuseIdentifier: TotalCellIdentifier];
          // Bottom border
          UIView *bor = [UIView new];
          bor.backgroundColor = [UIColor grayLight];
          bor.frame = CGRectMake(0.0f, (padding + 36.0f + padding) - 0.5f,
                                 tableView.frame.size.width, 0.5f);
          [cell1.contentView addSubview: bor];
        }
        cell1.backgroundColor = [UIColor whiteColor];
        cell1.detailTextLabel.font =
        [UIFont fontWithName: @"HelveticaNeue-Medium" size: 27];
        cell1.detailTextLabel.text = [NSString numberToCurrencyString:
          [self rentAmount] + [[self residence] deposit]];
        cell1.detailTextLabel.textColor = [UIColor green];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.textLabel.font =
        [UIFont fontWithName: @"HelveticaNeue-Light" size: 27];
        cell1.textLabel.text = @"Total";
        cell1.textLabel.textColor = [UIColor textColor];
        cell1.clipsToBounds = YES;
        return cell1;
      }
      // Remember Detail
      else if (indexPath.row == OMBOfferInquirySectionOfferRowRememberDetail) {
        static NSString *RememberDetailIdentifier = @"RememberDetailIdentifier";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
                                  RememberDetailIdentifier];
        if (!cell1) {
          cell1 = [[UITableViewCell alloc] initWithStyle:
                   UITableViewCellStyleDefault reuseIdentifier: RememberDetailIdentifier];
          UILabel *label = [UILabel new];
          label.font = [UIFont smallTextFont];
          label.numberOfLines = 0;
          label.text = rememberDetails;
          label.textAlignment = NSTextAlignmentCenter;
          label.textColor = [UIColor grayMedium];
          label.frame = CGRectMake(padding, padding,
            tableView.frame.size.width - (padding * 2),
              sizeForRememberDetails.height);
          [cell1.contentView addSubview: label];
        }
        cell1.backgroundColor = [UIColor grayUltraLight];
        cell1.separatorInset = UIEdgeInsetsMake(0.0f,
          tableView.frame.size.width, 0.0f, 0.0f);
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.clipsToBounds = YES;
        return cell1;
      }
      // Spacing below total
      /*else if (indexPath.row == OMBOfferInquirySectionOfferSpacingBelowTotal) {
        cell.backgroundColor = [UIColor grayUltraLight];
        cell.separatorInset  = UIEdgeInsetsMake(0.0f,
                                                tableView.frame.size.width, 0.0f, 0.0f);
      }*/
      // Notes
      else if (indexPath.row == OMBOfferInquirySectionOfferRowNotes) {
        static NSString *OfferNoteIdentifier = @"OfferNoteIdentifier";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
                                  OfferNoteIdentifier];
        if (!cell1) {
          cell1 = [[UITableViewCell alloc] initWithStyle:
                   UITableViewCellStyleDefault reuseIdentifier: OfferNoteIdentifier];
          UILabel *label = [UILabel new];
          label.font = [UIFont smallTextFont];
          label.numberOfLines = 0;
          label.text = offer.note;
          label.textColor = [UIColor textColor];
          label.frame = CGRectMake(padding, padding,
                                   tableView.frame.size.width - (padding * 2),
                                   sizeForOfferNotes.height);
          [cell1.contentView addSubview: label];

          UIView *bor = [UIView new];
          bor.backgroundColor = [UIColor grayLight];
          bor.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 0.5f);
          [cell1.contentView addSubview: bor];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.clipsToBounds = YES;
        return cell1;
      }
    }
  }
  // Profile
  else if (tableView == _profileTableView) {
    static NSString *RoommateCellID = @"RoommateCellID";
    OMBRoommateCell *cell = [tableView dequeueReusableCellWithIdentifier:
      RoommateCellID];
    if (!cell) {
      cell = [[OMBRoommateCell alloc] initWithStyle: UITableViewCellStyleDefault
        reuseIdentifier: RoommateCellID];
      cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
      cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    [cell loadDataFromUser: [self userAtIndexPath:indexPath]];
    // Remove the bottom separator
    if (row == [[self objects] count] - 1) {
      cell.separatorInset = UIEdgeInsetsMake(
        0.f, CGRectGetWidth(tableView.frame), 0.f, 0.f);
    }
    else {
      cell.separatorInset = tableView.separatorInset;
    }
    cell.clipsToBounds = YES;
    return cell;
  }
  cell.clipsToBounds = YES;
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
  // Offer
  if (tableView == _offerTableView) {
    // Residence
    // Dates
    // Spacing below dates
    // Price breakdown
    // Security deposit
    // Down Payment
    // Remaining Payment
    // Offer
    // Total
    // Remember details
    // !Spacing below total
    // Notes
    return 10;
  }
  // Profile
  else if (tableView == _profileTableView) {
    return [[self objects] count];
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Offer
  if (tableView == _offerTableView) {
    if (indexPath.section == OMBOfferInquirySectionOffer) {
      // Residence
      if (indexPath.row == OMBOfferInquirySectionOfferRowResidence) {
        [self.navigationController pushViewController:
         [[OMBResidenceDetailViewController alloc] initWithResidence:
          [self residence]] animated: YES];
      }
    }
  }
  // Applicants
  else if (tableView == _profileTableView) {
    [self.navigationController pushViewController:
      [[OMBUserDetailViewController alloc] initWithUser:
        [self userAtIndexPath:indexPath]] animated:YES];
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForHeaderInSection: (NSInteger) section
{
  // Profile
  if (tableView == _profileTableView) {
    if (section > 0) {
      return 13.0f * 2;
    }
  }
  return 0.0f;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat padding        = OMBPadding;
  CGFloat standardHeight = OMBStandardHeight;
  // Offer
  if (tableView == _offerTableView) {
    if (indexPath.section == OMBOfferInquirySectionOffer) {
      // Residence
      if (indexPath.row == OMBOfferInquirySectionOfferRowResidence) {
        return [OMBOfferInquiryResidenceCell heightForCell];
      }
      // Move-in date, move-out date, lease months
      else if (indexPath.row == OMBOfferInquirySectionOfferRowDates) {
        return [OMBResidenceConfirmDetailsDatesCell heightForCell];
      }
      // Spacing below dates
      else if (indexPath.row == OMBOfferInquirySectionOfferSpacingBelowDates) {
        // return standardHeight;
      }
      // Price breakdown
      else if (indexPath.row == OMBOfferInquirySectionOfferRowPriceBreakdown) {
        return standardHeight;
      }
      // Offer
      else if (indexPath.row == OMBOfferInquirySectionOfferRowOffer) {
        return standardHeight;
      }
      // Security deposit
      else if (indexPath.row == OMBOfferInquirySectionOfferRowSecurityDeposit) {
        return standardHeight;
      }
      // Down Payment
      else if (indexPath.row == OMBOfferInquirySectionOfferRowDownPayment) {
        if ([offer isAboveThreshold])
          return standardHeight;
      }
      // Remaining Payment
      else if (indexPath.row ==
        OMBOfferInquirySectionOfferRowRemainingPayment) {
        if ([offer isAboveThreshold])
          return standardHeight;
      }
      // Remember detail
      else if (indexPath.row == OMBOfferInquirySectionOfferRowRememberDetail) {
        return padding + sizeForRememberDetails.height + padding;;
      }
      // Total
      else if (indexPath.row == OMBOfferInquirySectionOfferRowTotal) {
        return padding + 36.0f + padding;
      }
      // Spacing below total
      /*else if (indexPath.row == OMBOfferInquirySectionOfferSpacingBelowTotal) {
        return standardHeight;
      }*/
      // Notes
      else if (indexPath.row == OMBOfferInquirySectionOfferRowNotes) {
        if (offer.note && [offer.note length]) {
          return padding + sizeForOfferNotes.height + padding;
        }
      }
    }
  }
  // Profile
  else if (tableView == _profileTableView) {
      return [OMBRoommateCell heightForCell];
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
  label.textColor = [UIColor blueDark];
  [blurView addSubview: label];
  NSString *titleString = @"";
  // Profile
  if (tableView == _profileTableView) {
  }
  label.text = titleString;
  return blurView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Private

- (void) acceptOfferCanceled
{
  [alertBlur close];
}

- (void) acceptOfferConfirmed
{
  // If user has a primary payout method
  if ([[OMBUser currentUser] primaryDepositPayoutMethod]) {
    [[OMBUser currentUser] acceptOffer: offer withCompletion:
     ^(NSError *error) {
      // If offer is accepted and no error
      if (offer.accepted && !error) {
        NSString *message;
        if ([offer isAboveThreshold]) {
          message = [NSString stringWithFormat:
            @"%@ has been charged a %@ non-refundable down payment and will "
            @"have %@ to sign the lease and pay the remainder of the "
            @"1st month’s rent and deposit. Once the lease has been signed, "
            @"and payment is made in full, we will transfer the 1st month’s "
            @"rent and deposit to your payout account and email both parties "
            @"the signed lease.",
            [[self user].firstName capitalizedString],
            [NSString numberToCurrencyString: [offer downPaymentAmount]],
            [offer timelineStringForStudent]];
        }
        else {
          message = [NSString stringWithFormat:
            @"%@ has been charged a total payment of %@ and will have %@ "
            @"to sign the lease. Once the lease has been signed, "
            @"we will email both parties the signed lease.",
            [[self user].firstName capitalizedString],
            [NSString numberToCurrencyString: [offer downPaymentAmount]],
            [offer timelineStringForStudent]];
        }
          [alertBlur setTitle: @"Offer Accepted!"];
          [alertBlur setMessage: message];
          [alertBlur resetQuestionDetails];
          [alertBlur hideQuestionButton];
          // Buttons
          [alertBlur setConfirmButtonTitle: @"Okay"];
          [alertBlur addTargetForConfirmButton: self
            action: @selector(offerAcceptedConfirmed)];
          [alertBlur showOnlyConfirmButton];
          [alertBlur animateChangeOfContent];
          [alertBlur hideCloseButton];

          // Decline and put other offers on hold
          [[OMBUser currentUser] declineAndPutOtherOffersOnHold: offer];

          // Send push notifications for when an offer is accepted
          [offer sendPushNotificationAccepted];
        }
        else {
          [self showAlertViewWithError: error];
        }
        [[self appDelegate].container stopSpinning];
       }
     ];
    [[self appDelegate].container startSpinning];
  }
  // If user has not set up a primary payout method
  else {
    [alertBlur setTitle: @"Payout Method Setup"];
    [alertBlur setMessage: @"Before accepting this offer, you must first "
      @"set up a payout method to receive payment for the 1st month's rent and "
      @"deposit."];
    [alertBlur resetQuestionDetails];
    [alertBlur hideQuestionButton];
    // Buttons
    [alertBlur setConfirmButtonTitle: @"Set up payout method"];
    [alertBlur addTargetForConfirmButton: self
      action: @selector(setupPayoutMethod)];
    [alertBlur showOnlyConfirmButton];
    [alertBlur animateChangeOfContent];
  }
}

- (void) acceptOfferFinalAnswer
{
  NSString *message;
  if ([offer isAboveThreshold]) {
    message = [NSString stringWithFormat:
    @"Ready to accept %@’s offer? %@ will be charged a %@ non-refundable "
    @"down payment and will have %@ to sign the lease and pay the "
    @"remainder of the 1st month’s rent and deposit.",
      [[self user].firstName capitalizedString],
        [[self user].firstName capitalizedString],
          [NSString numberToCurrencyString:[offer downPaymentAmount]],
            [offer timelineStringForStudent]];
  }
  else {
    message = [NSString stringWithFormat:
    @"Ready to accept %@’s offer? %@ will be charged a total of %@ "
    @"for the 1st month's rent and deposit and "
    @"will have %@ to sign the lease.",
      [[self user].firstName capitalizedString],
        [[self user].firstName capitalizedString],
          [NSString numberToCurrencyString: [offer downPaymentAmount]],
            [offer timelineStringForStudent]];
  }
  [alertBlur setTitle: @"Accepting Offer"];
  [alertBlur setMessage: message];
  [alertBlur resetQuestionDetails];
  [alertBlur hideQuestionButton];
  // Buttons
  [alertBlur setCancelButtonTitle: @"No"];
  [alertBlur setConfirmButtonTitle: @"Yes"];
  [alertBlur addTargetForCancelButton: self
    action: @selector(acceptOfferCanceled)];
  [alertBlur addTargetForConfirmButton: self
    action: @selector(acceptOfferConfirmed)];
  [alertBlur animateChangeOfContent];
}

- (void) alertCancelSelected
{
  [alert hideAlert];

  if (!accepted && !acceptedConfirmed) {
    [[OMBUser currentUser] declineOffer: offer
                         withCompletion: ^(NSError *error) {
                           if (offer.declined && !error) {
                             // Remove the offer from the user's received offers
                             [[OMBUser currentUser] removeReceivedOffer: offer];

                             [self.navigationController popViewControllerAnimated: YES];
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
  }

  accepted          = NO;
  acceptedConfirmed = NO;

  [alert addTarget: self action: @selector(alertCancelSelected)
         forButton: alert.alertCancel];
  [alert addTarget: self action: @selector(alertConfirmSelected)
         forButton: alert.alertConfirm];
}

- (void) alertConfirmSelected
{
  [alert showBothButtons];

  // User added a payout method already and accepted; last step
  if (accepted && acceptedConfirmed) {
    [self.navigationController pushViewController:
     [[OMBPayoutMethodsViewController alloc] init] animated: YES];
    [self alertCancelSelected];
  }
  // Steps before
  else {
    // Step 1
    if (!accepted) {
      accepted = YES;

      // Alert buttons
      [alert.alertConfirm setTitle: @"Yes" forState: UIControlStateNormal];
      [alert.alertCancel setTitle: @"No" forState: UIControlStateNormal];
      [alert addTarget: self action: @selector(alertConfirmSelected)
             forButton: alert.alertConfirm];
      // Alert message
      alert.alertMessage.text = [NSString stringWithFormat:
                                 @"Accepting %@'s offer will automatically decline all other offers.",
                                 [[self user].firstName capitalizedString]];
      // Alert title
      alert.alertTitle.text = @"Are You Sure?";
    }
    // Step 2
    else if (!acceptedConfirmed) {
      // If user has
      if ([[OMBUser currentUser] primaryDepositPayoutMethod]) {
        [[OMBUser currentUser] acceptOffer: offer
                            withCompletion: ^(NSError *error) {
                              // If offer is accepted and no error
                              if (offer.accepted && !error) {
                                acceptedConfirmed = YES;

                                [alert addTarget: self action: @selector(alertCancelSelected)
                                       forButton: alert.alertCancel];
                                [alert onlyShowOneButton: alert.alertCancel];
                                // Alert buttons
                                [alert.alertCancel setTitle: @"Ok" forState:
                                 UIControlStateNormal];
                                // Alert message
                                alert.alertMessage.text = @"Once the student confirms, "
                                @"you'll receive money within 24 hours.";
                                // Alert title
                                alert.alertTitle.text = @"Offer Accepted!";

                                // Decline all other offers from the user's received offers
                                // for the offers that are related to the same residence
                                [[OMBUser currentUser] removeAllReceivedOffersWithOffer: offer];

                                // Hide the respond button at the bottom
                                // and change the height of the table footer views
                                [UIView animateWithDuration: 0.25f animations: ^{
                                  respondView.alpha = 0.0f;
                                  _offerTableView.tableFooterView = [[UIView alloc] initWithFrame:
                                                                     CGRectZero];
                                  _profileTableView.tableFooterView =
                                  [[UIView alloc] initWithFrame: CGRectZero];
                                  [_offerTableView beginUpdates];
                                  [_offerTableView endUpdates];
                                  [_profileTableView beginUpdates];
                                  [_profileTableView endUpdates];
                                }];
                              }
                              else {
                                [self showAlertViewWithError: error];
                              }
                              [[self appDelegate].container stopSpinning];
                            }
         ];
        [[self appDelegate].container startSpinning];
      }
      // If user has not set up a primary deposit payout method
      else {
        // Alert buttons
        [alert.alertConfirm setTitle: @"Setup" forState: UIControlStateNormal];
        [alert.alertCancel setTitle: @"Cancel" forState: UIControlStateNormal];
        [alert addTarget: self action: @selector(showPayoutMethods)
               forButton: alert.alertConfirm];
        // Alert message
        alert.alertMessage.text = @"Please add at least one way to get paid.";
        // Alert title
        alert.alertTitle.text = @"Payout Method Required";
      }
    }
    [alert animateChangeOfContent];
  }
}

- (void) changeTableView
{
  CGFloat padding   = OMBPadding;
  CGFloat threshold = backView.frame.size.height -
    (padding + buttonsView.frame.size.height + padding);

  UIColor *normalBackgroundColor   = [UIColor clearColor];
  UIColor *normalTextColor         = [UIColor whiteColor];
  UIColor *selectedBackgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.8f];
  UIColor *selectedTextColor       = [UIColor blueDark];
  // Offer
  if (selectedSegmentIndex == 0) {
    previouslySelectedIndex = 0;

    offerButton.backgroundColor   = selectedBackgroundColor;
    profileButton.backgroundColor = normalBackgroundColor;
    contactButton.backgroundColor = normalBackgroundColor;

    [offerButton setTitleColor: selectedTextColor
      forState: UIControlStateNormal];
    [profileButton setTitleColor: normalTextColor
      forState: UIControlStateNormal];
    [contactButton setTitleColor: normalTextColor
      forState: UIControlStateNormal];

    _offerTableView.hidden   = NO;
    _profileTableView.hidden = YES;

    // If the offer table view content size height minus the
    // respond view's height is less than the offer table's height
    if (_offerTableView.contentSize.height - respondView.frame.size.height <=
        _offerTableView.frame.size.height) {
      [_profileTableView setContentOffset: CGPointZero animated: YES];
    }
    else if (_profileTableView.contentOffset.y < threshold) {
      _offerTableView.contentOffset = _profileTableView.contentOffset;
    }
    // If activity table view content offset is less than threshold
    else if (_offerTableView.contentOffset.y < threshold) {
      _offerTableView.contentOffset = CGPointMake(
        _offerTableView.contentOffset.x, threshold);
    }
  }
  // Profile
  else if (selectedSegmentIndex == 1) {
    previouslySelectedIndex = 1;

    offerButton.backgroundColor   = normalBackgroundColor;
    profileButton.backgroundColor = selectedBackgroundColor;
    contactButton.backgroundColor = normalBackgroundColor;

    [offerButton setTitleColor: normalTextColor
      forState: UIControlStateNormal];
    [profileButton setTitleColor: selectedTextColor
      forState: UIControlStateNormal];
    [contactButton setTitleColor: normalTextColor
      forState: UIControlStateNormal];

    _offerTableView.hidden   = YES;
    _profileTableView.hidden = NO;

    // If the profile table view content size height minus the
    // respond view's height is less than the profile table's height
    if (_profileTableView.contentSize.height - respondView.frame.size.height <=
        _profileTableView.frame.size.height) {

      [_offerTableView setContentOffset: CGPointZero animated: YES];
    }
    else if (_offerTableView.contentOffset.y < threshold) {
      _profileTableView.contentOffset = _offerTableView.contentOffset;
    }
    // If payments table view content offset is less than threshold
    else if (_profileTableView.contentOffset.y < threshold) {
      _profileTableView.contentOffset = CGPointMake(
       _profileTableView.contentOffset.x, threshold);
    }

    selectedSegmentIndex = previouslySelectedIndex;
  }
  // Contact
  else if (selectedSegmentIndex == 2) {
    [self showContact];
    selectedSegmentIndex = previouslySelectedIndex;
  }
}

- (void) celebrateAfterPayment
{
  [self hideAlertBlurAndPopController];
}

- (void) closeAlertBlur
{
  [alertBlur close];
}

- (void) confirmOfferCanceled
{
  [alertBlur close];
}

- (void) confirmOfferConfirmed
{
  // If user has a primary payout method
  OMBPayoutMethod *payoutMethod =
    [[OMBUser currentUser] primaryPaymentPayoutMethod];
  if (payoutMethod) {
    // PayPal
    if ([payoutMethod isPayPal]) {
      [self showPayPalPayment];
    }
    // Venmo
    else if ([payoutMethod isVenmo]) {
      // If the total is over 3000
      if ([offer remainingBalanceAmount] >
        [OMBPayoutMethod maximumVenmoTransfer]) {

        [alertBlur setTitle: @"Venmo Transfer Limit"];
        [alertBlur setMessage: [NSString stringWithFormat: @"Venmo does not "
          @"allow for payment transfers over %@ a week. Please choose another "
          @"payment method.",
          [NSString numberToCurrencyString:
            [OMBPayoutMethod maximumVenmoTransfer]]]];
        [alertBlur resetQuestionDetails];
        [alertBlur hideQuestionButton];
        // Buttons
        [alertBlur setConfirmButtonTitle: @"Select New Payment Method"];
        [alertBlur addTargetForConfirmButton: self
          action: @selector(setupPayoutMethod)];
        [alertBlur showOnlyConfirmButton];
        [alertBlur animateChangeOfContent];
      }
      // Charge Venmo
      else {
        [self launchVenmoApp];
      }
    }
  }
  // If user has not set up a primary payout method
  else {
    [alertBlur setTitle: @"Payment Method Setup"];
    [alertBlur setMessage: @"You have not yet set up a payment method to "
     @"pay the remaining balance."];
    [alertBlur resetQuestionDetails];
    [alertBlur hideQuestionButton];
    // Buttons
    [alertBlur setConfirmButtonTitle: @"Set up payment method"];
    [alertBlur addTargetForConfirmButton: self
      action: @selector(setupPayoutMethod)];
    [alertBlur showOnlyConfirmButton];
    [alertBlur animateChangeOfContent];
  }
}

- (void) charge
{
  [[OMBUser currentUser] confirmOffer: offer withCompletion: ^(NSError *error) {
    if ([offer isOfferPaymentPaid]) {
      [alertBlur setTitle: @"Remaining Balance Paid"];
      [alertBlur setMessage: [NSString stringWithFormat:
        @"You have successfully paid the remaining balance of %@ "
        @"The place is yours! Please sign the lease "
        @"we have emailed you and enjoy your new place.",
        [NSString numberToCurrencyString: [offer remainingBalanceAmount]]
      ]];
      [alertBlur resetQuestionDetails];
      [alertBlur hideQuestionButton];
      // Buttons
      [alertBlur setConfirmButtonTitle: @"Okay"];
      [alertBlur addTargetForConfirmButton: self
        action: @selector(celebrateAfterPayment)];
      [alertBlur showOnlyConfirmButton];
      [alertBlur animateChangeOfContent];
    }
    else {
      [self showAlertViewWithError: error];
      // Try again
      [self confirmOfferFinalAnswer];
      [alertBlur showCloseButton];
    }
    [alertBlur stopSpinning];
  }];
  [alertBlur startSpinning];
}

- (void) confirmOfferFinalAnswer
{
  NSString *paymentTypeName;
  if ([[[OMBUser currentUser] primaryPaymentPayoutMethod] isPayPal]) {
    paymentTypeName = @"PayPal";
  }
  else if ([[[OMBUser currentUser] primaryPaymentPayoutMethod] isVenmo]) {
    paymentTypeName = @"Venmo";
  }
  [alertBlur setTitle: @"Confirm & Pay"];
  [alertBlur setMessage: [NSString stringWithFormat:
    @"Ready to pay the remaining balance for the 1st month's rent and "
    @"deposit? If so, we will charge %@ from your %@ account now.",
    [NSString numberToCurrencyString: [offer remainingBalanceAmount]],
    paymentTypeName
  ]];
  [alertBlur resetQuestionDetails];
  [alertBlur hideQuestionButton];
  // Buttons
  [alertBlur setCancelButtonTitle: @"No"];
  [alertBlur setConfirmButtonTitle: @"Yes"];
  [alertBlur addTargetForCancelButton: self
    action: @selector(confirmOfferCanceled)];
  [alertBlur addTargetForConfirmButton: self
    action: @selector(confirmOfferConfirmed)];
  [alertBlur animateChangeOfContent];
}

- (void) declineOfferCanceled
{
  [alertBlur close];
}

- (void) declineOfferConfirmed
{
  [[OMBUser currentUser] declineOffer: offer
     withCompletion: ^(NSError *error) {
       if (offer.declined && !error) {
         [UIView animateWithDuration: OMBStandardDuration animations: ^{
           alertBlur.alpha = 0.0f;
         } completion: ^(BOOL finished) {
           if (finished) {
             [self.navigationController popViewControllerAnimated: YES];
             [alertBlur close];
           }
         }];
       }
       else {
         [self showAlertViewWithError: error];
       }
       [[self appDelegate].container stopSpinning];
     }
   ];
  [[self appDelegate].container startSpinning];
}

- (void) declineOfferFinalAnswer
{
  [alertBlur setTitle: @"Decline Offer"];
  [alertBlur setMessage: [NSString stringWithFormat:
                          @"Are you sure you want to decline %@'s offer?",
                          [[self user].firstName capitalizedString]]];
  [alertBlur resetQuestionDetails];
  [alertBlur hideQuestionButton];
  // Buttons
  [alertBlur setCancelButtonTitle: @"No"];
  [alertBlur setConfirmButtonTitle: @"Yes"];
  [alertBlur addTargetForCancelButton: self
                               action: @selector(declineOfferCanceled)];
  [alertBlur addTargetForConfirmButton: self
                                action: @selector(declineOfferConfirmed)];
  [alertBlur animateChangeOfContent];
}

- (void) fetchObjectsForResourceName: (NSString *) resourceName
{
  [[self renterApplication] fetchListForResourceName: resourceName
    userUID: [self user].uid delegate: self completion: ^(NSError *error) {}
  ];
}

- (void) hideAlert
{
  [alert hideAlert];
}

- (void) hideAlertBlurAndPopController
{
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    alertBlur.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    [alertBlur close];
    [self.navigationController popViewControllerAnimated: YES];
  }];
}

- (void) launchVenmoApp
{
  if (didCancelVenmoAppFromWebView) {
    [self charge];
    didCancelVenmoAppFromWebView = NO;
    return;
  }

  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    alertBlur.alpha = 0.0f;
  }];

  [self appDelegate].currentOfferBeingPaidFor = offer;

  // VenmoTransaction *venmoTransaction = [[VenmoTransaction alloc] init];
  // venmoTransaction.type = VenmoTransactionTypePay;
  // venmoTransaction.amount = [NSDecimalNumber decimalNumberWithString:
  //   [NSString stringWithFormat: @"%f", [offer remainingBalanceAmount]]];
  // venmoTransaction.note = [NSString stringWithFormat: @"From: %@, To: %@ - %@",
  //   [[OMBUser currentUser] fullName], [[self residence].user fullName],
  //     [[self residence].address capitalizedString]];
  // venmoTransaction.toUserHandle = @"OnMyBlock";

  // VenmoViewController *venmoViewController =
  //   [[self appDelegate].venmoClient viewControllerWithTransaction:
  //     venmoTransaction];
  // // Completion handler for when Venmo is presented in a web view
  // venmoViewController.completionHandler =
  //   ^(VenmoViewController *viewController, BOOL canceled) {
  //     if (canceled) {
  //       didCancelVenmoAppFromWebView = YES;
  //       [UIView animateWithDuration: OMBStandardDuration animations: ^{
  //         alertBlur.alpha = 1.0f;
  //       }];
  //     }
  //     [viewController dismissViewControllerAnimated: YES
  //       completion: nil];
  //   };
  // if (venmoViewController)
  //   [self presentViewController: venmoViewController animated: YES
  //     completion: ^{

  //     }];
}

- (NSTimeInterval) moveInDate
{
  return offer.moveInDate;
}

- (NSTimeInterval) moveOutDate
{
  return offer.moveOutDate;
}

- (NSInteger) numberOfMonthsBetweenMovingDates
{
  return [offer numberOfMonthsBetweenMovingDates];
}

- (NSArray *) objects
{
  return @[];
}

- (void) offerAcceptedConfirmed
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

- (BOOL) offerBelongsToCurrentUser
{
  return [self user].uid == [OMBUser currentUser].uid;
}

- (void) offerPaidWithVenmo: (NSNotification *) notification
{
  // [[self appDelegate].container stopSpinning];
  // [activityView stopSpinning];
  [alertBlur stopSpinning];

  if ([offer isOfferPaymentPaid]) {
    [alertBlur setTitle: @"Payment Successful"];
    // [alertBlur setMessage: @"Your payment using Venmo is complete."];
    [alertBlur setMessage:
      @"You're ready to move in! "
      @"We have transferred the 1st month's rent and deposit to your "
      @"landlord and have emailed the executed lease to both parties."
    ];
    [alertBlur resetQuestionDetails];
    [alertBlur hideQuestionButton];
    // Buttons
    [alertBlur setConfirmButtonTitle: @"Okay"];
    [alertBlur addTargetForConfirmButton: self
      action: @selector(celebrateAfterPayment)];
    [alertBlur showOnlyConfirmButton];
    [alertBlur animateChangeOfContent];
    [alertBlur hideCloseButton];
    // [UIView animateWithDuration: OMBStandardDuration animations: ^{
    //   alertBlur.alpha = 1.0f;
    // }];
  }
  else if ([[notification userInfo] objectForKey: @"error"] != [NSNull null]) {
    [alertBlur showCloseButton];
    [self showAlertViewWithError:
      (NSError *) [[notification userInfo] objectForKey: @"error"]];
  }
  else {
    NSLog(@"OFFER PAYOUT TRANSACTION WAS NOT VERIFIED");
  }
}

- (void) offerProcessingWithServer: (NSNotification *) notification
{
  // [UIView animateWithDuration: OMBStandardDuration animations: ^{
  //   alertBlur.alpha = 0.0f;
  // } completion: ^(BOOL finished) {
  //   if (finished) {
  //     [alertBlur close];
  //     [[self appDelegate].container startSpinning];
  //   }
  // }];
  NSLog(@"OFFER PROCESSING WITH SERVER");
  // [[self appDelegate].container startSpinning];
  // [activityView startSpinning];
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    alertBlur.alpha = 1.0f;
  }];
  [alertBlur startSpinning];
}

- (void) rejectOffer
{
  alert.alertTitle.text   = @"Reject Offer";
  alert.alertMessage.text = @"Are you sure?";
  [alert.alertCancel setTitle: @"Cancel" forState: UIControlStateNormal];
  [alert.alertConfirm setTitle: @"Yes" forState: UIControlStateNormal];

  [alert addTarget: self action: @selector(hideAlert)
         forButton: alert.alertCancel];
  [alert addTarget: self action: @selector(rejectOfferConfirm)
         forButton: alert.alertConfirm];

  [alert animateChangeOfContent];
}

- (void) rejectOfferConfirm
{
  [[OMBUser currentUser] rejectOffer: offer
                      withCompletion: ^(NSError *error) {
                        if (offer.rejected && !error) {
                          [self.navigationController popViewControllerAnimated: YES];
                        }
                        else {
                          [self showAlertViewWithError: error];
                        }
                        [[self appDelegate].container stopSpinning];
                      }
   ];
  [[self appDelegate].container startSpinning];
  [alert hideAlert];
}

- (void) rejectOfferCanceled
{
  [alertBlur close];
}

- (void) rejectOfferConfirmed
{
  [[OMBUser currentUser] rejectOffer: offer
                      withCompletion: ^(NSError *error) {
                        if (offer.rejected && !error) {
                          [self hideAlertBlurAndPopController];
                        }
                        else {
                          [self showAlertViewWithError: error];
                        }
                        [[self appDelegate].container stopSpinning];
                      }
   ];
  [[self appDelegate].container startSpinning];
}

- (void) rejectOfferFinalAnswer
{
  [alertBlur setTitle: @"Reject Offer"];
  [alertBlur setMessage: @"Are you sure you would like to notify the "
   @"landlord you are no longer interested in this place?"];
  [alertBlur resetQuestionDetails];
  [alertBlur hideQuestionButton];
  // Buttons
  [alertBlur setCancelButtonTitle: @"No"];
  [alertBlur setConfirmButtonTitle: @"Yes"];
  [alertBlur addTargetForCancelButton: self
                               action: @selector(rejectOfferCanceled)];
  [alertBlur addTargetForConfirmButton: self
                                action: @selector(rejectOfferConfirmed)];
  [alertBlur animateChangeOfContent];
}

- (CGFloat) rentAmount
{
  return offer.amount;
}

- (OMBRenterApplication *) renterApplication
{
  return [self user].renterApplication;
}

- (OMBResidence *) residence
{
  return offer.residence;
}

- (void) respond
{
  // Student
  if ([self offerBelongsToCurrentUser]) {
    NSString *paymentMethodName = [[[OMBUser currentUser]
      primaryPaymentPayoutMethod].payoutType capitalizedString];
    [alertBlur setTitle: @"Confirm & Pay"];
    [alertBlur setMessage: [NSString stringWithFormat:
      @"The landlord has accepted your offer! "
      @"To complete the process, you must pay the remaining balance of "
      @"%@ by tapping \"Confirm\" below. Then you have %@ to sign the lease "
      @"that we have emailed you.",
      [NSString numberToCurrencyString: [offer remainingBalanceAmount]],
      [offer timelineStringForStudent]
    ]];
    [alertBlur setQuestionDetails: [NSString stringWithFormat:
      @"Confirm: Charges the remaining balance of %@ from "
      @"your %@ account.\n\n"
      @"Reject: Tells the landlord that you are no longer interested.",
      [NSString numberToCurrencyString: [offer remainingBalanceAmount]],
      paymentMethodName]
    ];
    // Buttons
    [alertBlur setCancelButtonTitle: @"Reject"];
    [alertBlur setConfirmButtonTitle: @"Confirm"];
    [alertBlur addTargetForCancelButton: self
      action: @selector(rejectOfferFinalAnswer)];
    [alertBlur addTargetForConfirmButton: self
      action: @selector(confirmOfferFinalAnswer)];
    [alertBlur showInView: self.view withDetails: NO];
    didCancelVenmoAppFromWebView = NO;
  }
  // Landlord
  else {
    NSString *moveInDateString = [dateFormatter stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: [self moveInDate]]];
    NSString *moveOutDateString = [dateFormatter stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: [self moveOutDate]]];
    [alertBlur setTitle: @"Respond Now"];
    [alertBlur setMessage: [NSString stringWithFormat:
      @"%@ would like to rent your place from %@ - %@ for %@/mo with a "
      @"deposit of %@.",
        [[self user].firstName capitalizedString], moveInDateString,
          moveOutDateString, [NSString numberToCurrencyString: offer.amount],
            [NSString numberToCurrencyString: [[self residence] deposit]]]];
    NSString *details;
    if ([offer isAboveThreshold]) {
      details = [NSString stringWithFormat:
        @"Accept: Charges a non-refundable down payment of %@ to %@ and "
        @"gives the applicant party %@ to sign the lease and pay the remainder "
        @"of the 1st month’s rent and deposit.\n\n"
        @"Decline: Tells the student to look for another place to rent.",
        [NSString numberToCurrencyString: [offer downPaymentAmount]],
        [[[self user] firstName] capitalizedString],
        [offer timelineStringForStudent]];
    }
    else {
      details = [NSString stringWithFormat:
        @"Accept: Charges a total payment of %@ to %@ and "
        @"gives the applicant party %@ to sign the lease.\n\n"
        @"Decline: Tells the student to look for another place to rent.",
        [NSString numberToCurrencyString: [offer downPaymentAmount]],
        [[[self user] firstName] capitalizedString],
        [offer timelineStringForStudent]];
    }
    [alertBlur setQuestionDetails: details];
    // Buttons
    [alertBlur setCancelButtonTitle: @"Decline"];
    [alertBlur setConfirmButtonTitle: @"Accept"];
    [alertBlur addTargetForCancelButton: self
      action: @selector(declineOfferFinalAnswer)];
    [alertBlur addTargetForConfirmButton: self
      action: @selector(acceptOfferFinalAnswer)];
    [alertBlur showInView: self.view withDetails:firstTimeAlert];
    firstTimeAlert = NO;
  }
}

- (void) segmentButtonSelected: (UIButton *) button
{
  if (selectedSegmentIndex != button.tag) {
    selectedSegmentIndex = button.tag;
    [self changeTableView];
  }
}

- (void) setupPayoutMethod
{
  [UIView animateWithDuration: 0.25f animations: ^{
    alertBlur.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    if (finished)
      alertBlur.hidden = YES;
  }];
  cameFromSettingUpPayoutMethods = YES;
  [[self appDelegate].container showPayoutMethods];
}

- (void) setupSizeForRememberDetails
{
  if ([self offerBelongsToCurrentUser]) {
    if ([offer isAboveThreshold])
      rememberDetails = [NSString stringWithFormat:
        @"The landlord will have %@ to review your application and either "
        @"accept or decline your offer. "
        @"A non-refundable down payment of %@ will be charged from your "
        @"primary payment method if the landlord accepts your offer.",
        [offer timelineStringForLandlord],
          [NSString numberToCurrencyString: [offer downPaymentAmount]]
      ];
    else {
      rememberDetails = [NSString stringWithFormat:
        @"The landlord will have %@ to review your application and either "
        @"accept or decline your offer. "
        @"A total payment of %@ will be charged from your "
        @"primary payment method if the landlord accepts your offer.",
        [offer timelineStringForLandlord],
          [NSString numberToCurrencyString: [offer downPaymentAmount]]
      ];
    }
    if (offer.accepted) {
      if ([offer isAboveThreshold]) {
        rememberDetails = [NSString stringWithFormat:
          @"Your offer has been accepted! A down payment of %@ has been "
          @"sent to the landlord. You have %@ to sign the lease "
          @"and pay the remaining balance of %@.",
          [NSString numberToCurrencyString: [offer downPaymentAmount]],
          [offer timelineStringForStudent],
          [NSString numberToCurrencyString: [offer remainingBalanceAmount]]
        ];
      }
      else {
        rememberDetails = [NSString stringWithFormat:
          @"Your offer has been accepted! A total payment of %@ has been "
          @"sent to the landlord. You have %@ to sign the lease.",
          [NSString numberToCurrencyString: [offer downPaymentAmount]],
          [offer timelineStringForStudent]
        ];
      }
    }
    else if (offer.declined) {
      rememberDetails = @"Sorry, but your offer has been declined. "
        @"You will not be charged anything.";
    }
    else if (offer.confirmed) {
      rememberDetails = [NSString stringWithFormat:
        @"Congratulations! You have confirmed this offer and paid a total of "
        @"%@. You are ready to move into your new place.",
        [NSString numberToCurrencyString: [offer totalAmount]]
      ];
    }
    else if (offer.rejected) {
      if ([offer isAboveThreshold]) {
        rememberDetails = [NSString stringWithFormat:
          @"You have rejected this offer. Unfortunately your down payment of "
          @"%@ is non-refundable. If you have any questions or concerns please "
          @"contact us and we will be happy to assist you.",
          [NSString numberToCurrencyString: [offer downPaymentAmount]]
        ];
      }
      else {
        rememberDetails = @"You have rejected this offer.";
      }
    }
  }
  else {
    NSString *downPaymentAmount = [NSString numberToCurrencyString:
      [offer downPaymentAmount]];
    NSString *remainingBalanceAmount = [NSString numberToCurrencyString:
      [offer remainingBalanceAmount]];
    NSString *userFirstName = [[self user].firstName capitalizedString];
    if ([offer isAboveThreshold]) {
      rememberDetails = [NSString stringWithFormat:
        @"A non-refundable down payment of %@ will be "
        @"charged to %@ upon offer acceptance. If the offer is accepted, "
        @"the applicant party will have  %@ to sign the lease and pay "
        @"the remainder of the 1st month’s rent and deposit through OnMyBlock.",
        [NSString numberToCurrencyString: [offer downPaymentAmount]],
        userFirstName,
        [offer timelineStringForStudent]];
    }
    else {
      rememberDetails = [NSString stringWithFormat:
        @"A total payment of %@ will be "
        @"charged to %@ upon offer acceptance. If the offer is accepted, "
        @"the applicant party will have %@ to sign the lease through "
        @"OnMyBlock.",
        [NSString numberToCurrencyString: [offer downPaymentAmount]],
        userFirstName,
        [offer timelineStringForStudent]];
    }
    if (offer.accepted) {
      if ([offer isAboveThreshold]) {
        rememberDetails = [NSString stringWithFormat:
          @"You have accepted %@'s' offer. A non-refundable down payment of %@ "
          @"has been sent to your primary payout method's account. %@ "
          @"will have %@ to sign the lease and pay the remaining balance "
          @"of %@.",
          userFirstName,
          downPaymentAmount,
          userFirstName,
          [offer timelineStringForStudent],
          remainingBalanceAmount
        ];
      }
      else {
        rememberDetails = [NSString stringWithFormat:
          @"You have accepted %@'s' offer. A total payment of %@ "
          @"has been sent to your primary payout method's account. %@ "
          @"will have %@ to sign the lease.",
          userFirstName,
          downPaymentAmount,
          userFirstName,
          [offer timelineStringForStudent]
        ];
      }
    }
    else if (offer.declined) {
      rememberDetails = [NSString stringWithFormat:
        @"You have declined %@'s offer. All other offers for %@ that were "
        @"placed on hold have been reverted back to pending. Please review "
        @"those offers and respond to them.",
        userFirstName,
        [[self residence].address capitalizedString]
      ];
    }
    else if (offer.confirmed) {
      if ([offer isAboveThreshold]) {
        rememberDetails = [NSString stringWithFormat:
          @"%@ has confirmed the offer! %@ will have %@ to sign the lease and "
          @"pay the remaining balance of %@, which you will receive in your "
          @"primary payout method's account.",
          userFirstName,
          userFirstName,
          [offer timelineStringForStudent],
          remainingBalanceAmount
        ];
      }
      else {
        rememberDetails = [NSString stringWithFormat:
          @"%@ has confirmed the offer! %@ will have %@ to sign the lease.",
          userFirstName,
          userFirstName,
          [offer timelineStringForStudent]
        ];
      }
    }
    else if (offer.rejected) {
      if ([offer isAboveThreshold]) {
        rememberDetails = [NSString stringWithFormat:
          @"%@ has rejected the offer. You have received a non-refundable "
          @"down payment of %@. However, you will not receive the "
          @"remaining balance of %@.",
          userFirstName,
          downPaymentAmount,
          remainingBalanceAmount
        ];
      }
      else {
        rememberDetails = [NSString stringWithFormat:
          @"%@ has rejected the offer.", userFirstName];
      }
    }
  }
  sizeForRememberDetails = [rememberDetails boundingRectWithSize:
    CGSizeMake(_offerTableView.frame.size.width - (OMBPadding * 2), 9999)
      font: [UIFont smallTextFont]].size;
}

- (void) showContact
{
  if ([self offerBelongsToCurrentUser]) {
    [self.navigationController pushViewController:
      [[OMBMessageDetailViewController alloc] initWithUser:
        offer.landlordUser] animated: YES];
  }
  else {
    [self.navigationController pushViewController:
      [[OMBMessageDetailViewController alloc] initWithUser: [self user]]
        animated: YES];
  }
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

- (void) showPayPalPayment
{
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    alertBlur.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    if (finished)
      alertBlur.hidden = YES;
  }];
  cameFromSettingUpPayoutMethods = YES;

  // Present the PayPalPaymentViewController.
  NSString *shortDescription = [NSString stringWithFormat:
    @"Remaining Balance for %@", [[self residence].address capitalizedString]];
  UINavigationController *nav = (UINavigationController *)
    [self payPalPaymentViewControllerWithAmount: [offer remainingBalanceAmount]
      intent: PayPalPaymentIntentSale shortDescription: shortDescription
        delegate: self];
  if (nav)
    [self presentViewController: nav animated: YES completion: nil];
}

- (void) timerFireMethod: (NSTimer *) timer
{
  // Student
  if ([self offerBelongsToCurrentUser]) {
    // Waiting on the landlord
    if ([offer statusForStudent] ==
        OMBOfferStatusForStudentWaitingForLandlordResponse) {

      if (![offer isExpiredForLandlord]) {
        countDownTimerLabel.text = [offer timeLeftStringForLandlord];
      }
    }
    // Waiting on the student
    else if ([offer statusForStudent] == OMBOfferStatusForStudentAccepted) {
      if (![offer isExpiredForStudent]) {
        countDownTimerLabel.text = [offer timeLeftStringForStudent];
      }
    }
  }
  // Landlord
  else {
    if ([offer isExpiredForLandlord])
      countDownTimerLabel.text = @"expired";
    else {
      // Waiting for the student
      if (offer.accepted && !offer.rejected && !offer.confirmed) {
        countDownTimerLabel.text = [offer timeLeftStringForStudent];
      }
      // Landlord response required
      else {
        countDownTimerLabel.text = [offer timeLeftStringForLandlord];
      }
    }
  }
}

- (OMBUser *) user
{
  return offer.user;
}

- (void) userAddedFirstPayoutMethod
{
  UINavigationController *vc = (UINavigationController *)
    [self appDelegate].container.payoutMethodsNavigationController;
  if (vc.presentingViewController)
    [vc dismissViewControllerAnimated: YES completion: nil];
}

- (OMBUser *)userAtIndexPath:(NSIndexPath *)indexPath
{
  return [[self objects] objectAtIndex:indexPath.row];
}

- (void) venmoAppSwitchCancelled: (NSNotification *) notification
{
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    alertBlur.alpha = 1.0f;
  }];
}

#pragma mark - Public

- (void) hideCountdownAndRespondButton
{
  countDownTimerLabel.alpha = 0.0f;
  respondView.alpha = 0.0f;
  _offerTableView.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectZero];
  _profileTableView.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectZero];
}

@end
