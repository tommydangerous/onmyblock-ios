//
//  OMBResidenceBookItConfirmDetailsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceBookItConfirmDetailsViewController.h"

#import "DRNRealTimeBlurView.h"
#import "OMBCenteredImageView.h"
#import "OMBOffer.h"
#import "OMBOfferCreateConnection.h"
#import "OMBRenterApplicationViewController.h"
#import "OMBResidence.h"
#import "OMBResidenceAddPersonalNoteViewController.h"
#import "OMBResidenceConfirmDetailsBuyerCell.h"
#import "OMBResidenceConfirmDetailsDatesCell.h"
#import "OMBResidenceConfirmDetailsPlaceOfferCell.h"
#import "OMBResidenceLeaseAgreementViewController.h"
#import "OMBResidenceMonthlyPaymentScheduleViewController.h"
#import "OMBViewControllerContainer.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBResidenceBookItConfirmDetailsViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  deposit   = 1000;
  residence = object;
  offer     = [[OMBOffer alloc] init];
  offer.residence = residence;

  self.screenName = self.title = @"Confirm Details";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setupForTable];

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth = screen.size.width;

  CGFloat height = screenHeight * 0.4f;
  CGFloat padding = 20.0f;

  // reviewBarButton = [[UIBarButtonItem alloc] initWithTitle: @"Review" 
  //   style: UIBarButtonItemStylePlain target: self action: @selector(review)];
  // self.navigationItem.rightBarButtonItem = reviewBarButton;

  UIView *footerView = [[UIView alloc] init];
  footerView.frame = CGRectMake(0.0f, 0.0f, screenWidth, 216.0f);
  self.table.tableFooterView = footerView;
  // Submit offer button
  submitOfferButton = [UIButton new];
  submitOfferButton.alpha = 0.0f;
  submitOfferButton.backgroundColor = [UIColor blue];
  submitOfferButton.clipsToBounds = YES;
  // submitOfferButton.frame = CGRectMake(padding, (216.0f - 58.0f) * 0.5,
  //   screenWidth - (padding * 2), padding + 18.0f + padding);
  submitOfferButton.frame = CGRectMake(0.0f, 
    screenHeight - (padding + 18.0f + padding),
      screenWidth, padding + 18.0f + padding);
  // submitOfferButton.layer.cornerRadius = 2.0f;
  submitOfferButton.titleLabel.font = 
    [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  [submitOfferButton addTarget: self action: @selector(submitOffer)
    forControlEvents: UIControlEventTouchUpInside];
  [submitOfferButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueDark]] 
      forState: UIControlStateHighlighted];
  [submitOfferButton setTitle: @"Submit Offer" forState: UIControlStateNormal];
  [submitOfferButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [self.view addSubview: submitOfferButton];
  // [footerView addSubview: submitOfferButton];

  UIView *headerView = [[UIView alloc] init];
  headerView.frame = CGRectMake(0.0f, 0.0f, screenWidth, height);
  self.table.tableHeaderView = headerView;

  // Image of residence
  residenceImageView = [[OMBCenteredImageView alloc] init];
  residenceImageView.frame = headerView.frame;
  residenceImageView.image = [UIImage imageNamed: 
    @"intro_still_image_slide_2_background.jpg"];
  [headerView addSubview: residenceImageView];

  DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] init];
  blurView.blurRadius = 0.3f;
  blurView.frame = residenceImageView.frame;
  blurView.renderStatic = YES;
  [headerView addSubview: blurView];

  // Timer
  daysLabel    = [UILabel new];
  hoursLabel   = [UILabel new];
  minutesLabel = [UILabel new];
  secondsLabel = [UILabel new];

  NSArray *array = @[
    daysLabel,
    hoursLabel,
    minutesLabel,
    secondsLabel
  ];
  CGFloat labelSize = 58.0f;
  CGFloat spacing = (screenWidth - (labelSize * [array count])) / 
    ([array count] + 1);
  for (UILabel *label in array) {
    int index = [array indexOfObject: label];
    label.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.8f];
    label.clipsToBounds = YES;
    label.font = [UIFont fontWithName: @"DBLCDTempBlack" size: 27.0f];
    label.frame = CGRectMake(spacing + ((labelSize + spacing) * index), 
      (height - labelSize) * 0.5, labelSize, labelSize);
    label.layer.cornerRadius = 5.0f;
    label.textColor = [UIColor whiteColor];
    [headerView addSubview: label]; 
  }

  [self setString: @"02" forTimeUnit: @"days"];
  [self setString: @"13" forTimeUnit: @"hours"];
  [self setString: @"49" forTimeUnit: @"minutes"];
  [self setString: @"34" forTimeUnit: @"seconds"];

  // Current offer
  currentOfferLabel = [[UILabel alloc] init];
  currentOfferLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
    size: 15];
  CGFloat currentOfferLabelSpacing = ((headerView.frame.size.height - 
    (daysLabel.frame.origin.y + daysLabel.frame.size.height)) - 44.0f) * 0.5;
  currentOfferLabel.frame = CGRectMake(0.0f, 
    headerView.frame.size.height - (currentOfferLabelSpacing + 44.0f), 
      screenWidth, 44.0f);
  currentOfferLabel.text = @"Current offer: $4,500";
  currentOfferLabel.textAlignment = NSTextAlignmentCenter;
  currentOfferLabel.textColor = [UIColor whiteColor];
  [headerView addSubview: currentOfferLabel];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];

  if (!hasOfferValue) {
    [self scrollToPlaceOffer];
  }
}

#pragma mark - Protocol

#pragma mark - Protocol UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
  if (hasOfferValue) {
    [self.view endEditing: YES];
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Place offer
  // Move in and move out dates
  // Price breakdown
  // Monthly schedule, lease agreement
  // Buyer
  return 5;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *EmptyCellIdentifier = @"EmptyCellIdentifier";
  UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:
    EmptyCellIdentifier];
  if (!emptyCell)
    emptyCell = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleValue1 reuseIdentifier: EmptyCellIdentifier];
  emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
  UIView *bottomBorder = [emptyCell.contentView viewWithTag: 9999];
  if (bottomBorder)
    [bottomBorder removeFromSuperview];
  else {
    bottomBorder = [UIView new];
    bottomBorder.backgroundColor = [UIColor grayLight];
    bottomBorder.tag = 9999;
  }
  // Place offer
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      static NSString *PlaceOfferIdentifier = @"PlaceOfferIdentifier";
      OMBResidenceConfirmDetailsPlaceOfferCell *cell =
        [tableView dequeueReusableCellWithIdentifier: PlaceOfferIdentifier];
      if (!cell)
        cell = [[OMBResidenceConfirmDetailsPlaceOfferCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: PlaceOfferIdentifier];
      [cell.nextStepButton addTarget: self action: @selector(review)
        forControlEvents: UIControlEventTouchUpInside];
      cell.yourOfferTextField.delegate = self;
      [cell.yourOfferTextField addTarget: self 
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      return cell;
    }
  }
  // Move in and move out dates
  else if (indexPath.section == 1) {
    if (indexPath.row == 1) {
      static NSString *DateIdentifier = @"DateIdentifier";
      OMBResidenceConfirmDetailsDatesCell *cell =
        [tableView dequeueReusableCellWithIdentifier: DateIdentifier];
      if (!cell)
        cell = [[OMBResidenceConfirmDetailsDatesCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: DateIdentifier];
      return cell;
    }
  }
  // Price breakdown
  else if (indexPath.section == 2) {
    emptyCell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 1 || indexPath.row == 2) {
      emptyCell.backgroundColor = [UIColor whiteColor];
      emptyCell.detailTextLabel.font = emptyCell.textLabel.font = 
        [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
      emptyCell.detailTextLabel.textColor = 
        emptyCell.textLabel.textColor = [UIColor textColor];
      if (indexPath.row == 1) {
        emptyCell.detailTextLabel.text = [NSString numberToCurrencyString:
          deposit];
        emptyCell.textLabel.text = @"Deposit";
      }
      else if (indexPath.row == 2) {
        emptyCell.detailTextLabel.text = [NSString numberToCurrencyString:
          offer.amount];
        emptyCell.textLabel.text = @"1st Month's Rent";
      }
    }
    else if (indexPath.row == 3) {
      emptyCell.backgroundColor = [UIColor whiteColor];
      emptyCell.detailTextLabel.font = 
        [UIFont fontWithName: @"HelveticaNeue-Medium" size: 27];
      CGFloat total = deposit + offer.amount;
      emptyCell.detailTextLabel.text = [NSString numberToCurrencyString:
        total];
      emptyCell.detailTextLabel.textColor = [UIColor blueDark];
      emptyCell.textLabel.font = 
        [UIFont fontWithName: @"HelveticaNeue-Light" size: 27];
      emptyCell.textLabel.text = @"Total";
      emptyCell.textLabel.textColor = [UIColor textColor];
      // Bottom border
      bottomBorder.frame = CGRectMake(0.0f, (20 + 36.0f + 20) - 0.5f,
        tableView.frame.size.width, 0.5f);
      [emptyCell.contentView addSubview: bottomBorder];
    }
    else if (indexPath.row == 4) {
      static NSString *PriceBreakdownIdentifier = @"PriceBreakdownIdentifier";
      UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier: PriceBreakdownIdentifier];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:
          UITableViewCellStyleDefault 
            reuseIdentifier: PriceBreakdownIdentifier];
        // Border
        UIView *bottomBorder2 = [UIView new];
        bottomBorder2.backgroundColor = tableView.separatorColor;
        bottomBorder2.frame = CGRectMake(0.0f, 44.0f - 0.5f, 
          tableView.frame.size.width, 0.5f);
        [cell.contentView addSubview: bottomBorder2];
        // Sort arrow
        CGFloat padding = 20.0f;
        CGFloat sortArrowSize = 20.0f;
        UIImageView *sortArrow = [[UIImageView alloc] init];
        sortArrow.alpha = 0.5f;
        sortArrow.frame = CGRectMake(tableView.frame.size.width - 
          (sortArrowSize + padding), (44.0f - sortArrowSize) * 0.5, 
            sortArrowSize, sortArrowSize);
        sortArrow.image = [UIImage imageNamed: @"arrow_left.png"];
        sortArrow.transform = CGAffineTransformMakeRotation(
          -90 * M_PI / 180.0f);
        [cell.contentView addSubview: sortArrow];
      }
      cell.textLabel.font = 
        [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
      cell.textLabel.text = @"Price Breakdown";
      cell.textLabel.textColor = [UIColor grayMedium];
      return cell;
    }
  }
  // Monthly schedule, lease agreement
  else if (indexPath.section == 3) {
    if (indexPath.row == 1 || indexPath.row == 2) {
      emptyCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      emptyCell.backgroundColor = [UIColor whiteColor];
      emptyCell.detailTextLabel.text = @"";
      emptyCell.selectionStyle = UITableViewCellSelectionStyleDefault;
      emptyCell.textLabel.font = 
        [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
      emptyCell.textLabel.textColor = [UIColor textColor];
      // Monthly schedule
      if (indexPath.row == 1) {
        emptyCell.textLabel.text = @"Monthly Payment Schedule";
      }
      // Lease agreement
      else if (indexPath.row == 2) {
        emptyCell.textLabel.text = @"Lease Agreement";
        // Bottom border
        bottomBorder.frame = CGRectMake(0.0f, 44.0f - 0.5f,
          tableView.frame.size.width, 0.5f);
        [emptyCell.contentView addSubview: bottomBorder];
      }
    }
  }
  // Buyer
  else if (indexPath.section == 4) {
    if (indexPath.row == 1) {
      static NSString *BuyerCellIdentifier = @"BuyerCellIdentifier";
      OMBResidenceConfirmDetailsBuyerCell *cell =
        [tableView dequeueReusableCellWithIdentifier: BuyerCellIdentifier];
      if (!cell)
        cell = [[OMBResidenceConfirmDetailsBuyerCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: BuyerCellIdentifier];
      return cell;
    }
    else if (indexPath.row == 2 || indexPath.row == 3) {
      emptyCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      emptyCell.backgroundColor = [UIColor whiteColor];
      emptyCell.detailTextLabel.font = emptyCell.textLabel.font = 
        [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
      emptyCell.selectionStyle = UITableViewCellSelectionStyleDefault;
      emptyCell.textLabel.textColor = [UIColor textColor];
      if (indexPath.row == 2) {
        emptyCell.detailTextLabel.text = @"50% complete";
        emptyCell.detailTextLabel.textColor = [UIColor red];
        emptyCell.textLabel.text = @"Renter Application";
      }
      else if (indexPath.row == 3) {
        emptyCell.detailTextLabel.text = @"";
        emptyCell.textLabel.text = @"Add a personal note";
        bottomBorder.frame = CGRectMake(0.0f, 44.0f - 0.5f,
          tableView.frame.size.width, 0.5f);
        [emptyCell.contentView addSubview: bottomBorder];
      }
    }
  }
  // Bottom border on the first row with the gray spacing
  if (indexPath.section != 0) {
    if (indexPath.row == 0) {
      emptyCell.accessoryType = UITableViewCellAccessoryNone;
      emptyCell.backgroundColor = tableView.backgroundColor;
      emptyCell.detailTextLabel.text = emptyCell.textLabel.text = @"";
      emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
      // Bottom border
      bottomBorder.frame = CGRectMake(0.0f, 44.0f - 0.5f,
        tableView.frame.size.width, 0.5f);
      [emptyCell.contentView addSubview: bottomBorder];
    }
  }
  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Place offer
  if (section == 0) {
    return 1;
  }
  // Dates
  else if (section == 1) {
    return 1 + 1;
  }
  // Price Breakdown
  else if (section == 2) {
    return 1 + 4;
  }
  // Monthly schedule, lease agreement
  else if (section == 3) {
    return 1 + 2;
  }
  // Buyer
  else if (section == 4) {
    return 1 + 3;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Price breakdown
  if (indexPath.section == 2) {
    // Price breakdown
    if (indexPath.row == 4) {
      isShowingPriceBreakdown = YES;
      [tableView reloadSections: [NSIndexSet indexSetWithIndex: 2]
        withRowAnimation: UITableViewRowAnimationFade];
    }
  }
  // Monthly schedule, lease agreement
  else if (indexPath.section == 3) {
    if (indexPath.row == 1) {
      [self.navigationController pushViewController:
        [[OMBResidenceMonthlyPaymentScheduleViewController alloc] 
          initWithResidence: residence] animated: YES];
    }
    else if (indexPath.row == 2) {
      [self.navigationController pushViewController:
        [[OMBResidenceLeaseAgreementViewController alloc] init] animated: YES];
    }
  }
  // Buyer
  else if (indexPath.section == 4) {
    // Renter application
    if (indexPath.row == 2) {
      [self.navigationController pushViewController:
        [[OMBRenterApplicationViewController alloc] initWithUser: 
          [OMBUser currentUser]] animated: YES];
    }
    // Add a personal note
    else if (indexPath.row == 3) {
      [self.navigationController pushViewController:
        [[OMBResidenceAddPersonalNoteViewController alloc] init] animated: YES];
    }
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat padding = 20.0f;
  CGFloat spacing = 44.0f;
  // Place offer
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      return [OMBResidenceConfirmDetailsPlaceOfferCell heightForCell];
    }
  }
  else if (!hasOfferValue) {
    return 0.0f;
  }
  // Dates
  else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      return spacing;
    }
    else if (indexPath.row == 1) {
      return [OMBResidenceConfirmDetailsDatesCell heightForCell];
    }
  }
  // Price breakdown
  else if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      return spacing;
    }
    else if (indexPath.row == 1 || indexPath.row == 2) {
      if (isShowingPriceBreakdown)
        return spacing;
    }
    else if (indexPath.row == 3) {
      return padding + 36.0f + padding;
    }
    else if (indexPath.row == 4) {
      if (!isShowingPriceBreakdown)
        return spacing;
    }
  }
  // Monthly schedule, lease agreement
  else if (indexPath.section == 3) {
    return spacing;
  }
  // Buyer
  else if (indexPath.section == 4) {
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
      return spacing;
    }
    else if (indexPath.row == 1) {
      return [OMBResidenceConfirmDetailsBuyerCell heightForCell];
    }
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  if (textField == [self yourOfferTextField]) {
    [self scrollToPlaceOffer];
    [self.navigationItem setRightBarButtonItem: reviewBarButton animated: YES];
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) review
{  
  if ([[[self yourOfferTextField].text stripWhiteSpace] length]) {
    hasOfferValue = YES;
    [self.view endEditing: YES];
    [UIView animateWithDuration: 0.15 animations: ^{
      submitOfferButton.alpha = 1.0f;
    }];
    [self.navigationItem setRightBarButtonItem: nil animated: YES];
  }
  else {
    hasOfferValue = NO;
    [UIView animateWithDuration: 0.15 animations: ^{
      submitOfferButton.alpha = 0.0f;
    }];
  }
  [self.table beginUpdates];
  [self.table endUpdates];
}

- (void) scrollToPlaceOffer
{
  OMBResidenceConfirmDetailsPlaceOfferCell *cell = 
    (OMBResidenceConfirmDetailsPlaceOfferCell *)
      [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow: 0 
        inSection: 0]];
  [cell.yourOfferTextField becomeFirstResponder];
  CGFloat statusNavigationHeight = 20.0f + 44.0f;
  CGFloat contentOffsetY = 
    (self.table.tableHeaderView.frame.size.height + 
      [OMBResidenceConfirmDetailsPlaceOfferCell heightForCell]) -
    ((self.table.frame.size.height - statusNavigationHeight) - 
      self.table.tableFooterView.frame.size.height);
  contentOffsetY -= statusNavigationHeight;
  [self.table setContentOffset: CGPointMake(0.0f, contentOffsetY) 
    animated: YES];
}

- (void) setString: (NSString *) string forTimeUnit: (NSString *) unit
{
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.maximumLineHeight = 32.0f;
  style.minimumLineHeight = 32.0f;
  NSMutableAttributedString *text = 
    [[NSMutableAttributedString alloc] initWithString: string attributes: @{
      NSParagraphStyleAttributeName: style
    }
  ];
  if ([unit isEqualToString: @"days"]) {
    daysLabel.attributedText = text;
    daysLabel.textAlignment  = NSTextAlignmentCenter;
  }
  else if ([unit isEqualToString: @"hours"]) {
    hoursLabel.attributedText = text;
    hoursLabel.textAlignment  = NSTextAlignmentCenter;
  }
  else if ([unit isEqualToString: @"minutes"]) {
    minutesLabel.attributedText = text;
    minutesLabel.textAlignment  = NSTextAlignmentCenter;
  }
  else if ([unit isEqualToString: @"seconds"]) {
    secondsLabel.attributedText = text;
    secondsLabel.textAlignment  = NSTextAlignmentCenter;
  }
}

- (void) submitOffer
{
  OMBOfferCreateConnection *conn = 
    [[OMBOfferCreateConnection alloc] initWithOffer: offer];
  conn.completionBlock = ^(NSError *error) {
    UIAlertView *alertView;
    if (offer.uid && !error) {
      alertView = [[UIAlertView alloc] initWithTitle: @"Offer submitted!"
        message: @"You will receive a response in your homebase" delegate: self 
          cancelButtonTitle: @"OK" otherButtonTitles: nil];
    }
    else {
      NSString *message = @"Offer was not submitted, please try again.";
      if (error)
        message = error.localizedDescription;
      alertView = [[UIAlertView alloc] initWithTitle: 
        @"Please try again" message: message delegate: nil 
          cancelButtonTitle: @"Try again"
            otherButtonTitles: nil];
    }
    [alertView show];
    [[self appDelegate].container stopSpinning];
  };
  [conn start];
  [[self appDelegate].container startSpinning]; 
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  offer.amount = [textField.text floatValue];
  OMBResidenceConfirmDetailsPlaceOfferCell *cell = 
    (OMBResidenceConfirmDetailsPlaceOfferCell *)
      [self.table cellForRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 0 inSection: 0]];
  if (offer.amount > 0) {
    [cell enableNextStepButton];
  }
  else {
    [cell disableNextStepButton];
  }
}

- (TextFieldPadding *) yourOfferTextField
{
  OMBResidenceConfirmDetailsPlaceOfferCell *cell = 
    (OMBResidenceConfirmDetailsPlaceOfferCell *)
      [self.table cellForRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 0 inSection: 0]];
  return cell.yourOfferTextField;
}

@end
