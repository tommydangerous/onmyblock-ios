//
//  OMBOfferInquiryViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOfferInquiryViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "OMBCenteredImageView.h"
#import "OMBCoapplicantCell.h"
#import "OMBCosigner.h"
#import "OMBCosignerCell.h"
#import "OMBEmploymentCell.h"
#import "OMBGradientView.h"
#import "OMBLegalQuestion.h"
#import "OMBLegalQuestionAndAnswerCell.h"
#import "OMBLegalQuestionStore.h"
#import "OMBMessageDetailViewController.h"
#import "OMBMessageStore.h"
#import "OMBOfferInquiryResidenceCell.h"
#import "OMBPayoutMethodsViewController.h"
#import "OMBPreviousRentalCell.h"
#import "OMBResidenceDetailViewController.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBOfferInquiryViewController

#pragma mark - Initializer

- (id) initWithOffer: (NSString *) object
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Offer Inquiry";
  self.title      = @"Edward's Offer";

  fakeAbout = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

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
  userImageView.image = [UIImage imageNamed: @"edward_d.jpg"];
  [backView addSubview: userImageView];

  OMBGradientView *gradient = [[OMBGradientView alloc] init];
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
  offerButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
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
  [profileButton setTitle: @"Profile" forState: UIControlStateNormal];
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
  _profileTableView.separatorInset = _offerTableView.separatorInset;
  _profileTableView.showsVerticalScrollIndicator = 
    _offerTableView.showsVerticalScrollIndicator;
  [self.view insertSubview: _profileTableView belowSubview: buttonsView];
  // Profile table header view
  UIView *profileHeader = [UIView new];
  profileHeader.frame = offerHeader.frame;
  _profileTableView.tableHeaderView = profileHeader;

  // Respond view
  respondView = [UIView new];
  respondView.backgroundColor = [UIColor blueAlpha: 0.95f];
  respondView.clipsToBounds = YES;
  respondView.frame = CGRectMake(0.0f, screenHeight - standardHeight,
    screenWidth, standardHeight);
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
  respondButton.titleLabel.font = 
    [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  [respondButton addTarget: self action: @selector(respond)
    forControlEvents: UIControlEventTouchUpInside];
  [respondButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueHighlighted]] 
      forState: UIControlStateHighlighted];
  [respondButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [respondView addSubview: respondButton];

  // Offer table footer view
  _offerTableView.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, 
      screenWidth, respondView.frame.size.height + padding)];
  // Profile table footer view
  _profileTableView.tableFooterView = [[UIView alloc] initWithFrame:
    _offerTableView.tableFooterView.frame];

  // Faded background
  fadedBackground = [UIView new];
  fadedBackground.alpha = 0.0f;
  fadedBackground.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.5f];
  fadedBackground.frame = screen;
  // [[[UIApplication sharedApplication] keyWindow] addSubview: fadedBackground];
  // Alert
  CGFloat alertHeight = screenHeight * 0.5f;
  CGFloat alertWidth  = screenWidth * 0.8f;
  alert = [[AMBlurView alloc] init];
  alert.frame = CGRectMake((screenWidth - alertWidth) * 0.5, 
    0.0f, alertWidth, 0.0f);
  alert.layer.cornerRadius = 5.0f;
  [fadedBackground addSubview: alert];
  // Alert title
  alertTitle = [UILabel new];
  alertTitle.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  alertTitle.frame = CGRectMake(padding, padding, 
    alert.frame.size.width - (padding * 2), 27.0f);
  alertTitle.text = @"Respond to Offer";
  alertTitle.textAlignment = NSTextAlignmentCenter;
  alertTitle.textColor = [UIColor textColor];
  [alert addSubview: alertTitle];
  // Alert message
  alertMessage = [UILabel new];
  alertMessage.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  alertMessage.numberOfLines = 0;
  alertMessage.text = @"Edward would like to rent this place from January 1,"
    @" 2014 through December 12, 2014 for $2,575 a month.";
  CGRect alertMessageRect = [alertMessage.text boundingRectWithSize:
    CGSizeMake(alertTitle.frame.size.width, 9999) font: alertMessage.font];
  alertMessage.frame = CGRectMake(alertTitle.frame.origin.x,
    alertTitle.frame.origin.y + alertTitle.frame.size.height + (padding * 0.5),
      alertTitle.frame.size.width, alertMessageRect.size.height);
  alertMessage.textAlignment = NSTextAlignmentCenter;
  alertMessage.textColor = [UIColor textColor];
  [alert addSubview: alertMessage];

  // Alert buttons view
  alertButtonsView = [UIView new];
  alertButtonsView.frame = CGRectMake(0.0f, 
    alertMessage.frame.origin.y + alertMessage.frame.size.height + padding,
      alert.frame.size.width, 44.0f);
  [alert addSubview: alertButtonsView];
  UIView *alertButtonsViewTopBorder = [UIView new];
  alertButtonsViewTopBorder.backgroundColor = [UIColor grayMedium];
  alertButtonsViewTopBorder.frame = CGRectMake(0.0f, 0.0f, 
    alertButtonsView.frame.size.width, 0.5f);
  [alertButtonsView addSubview: alertButtonsViewTopBorder];
  UIView *alertButtonsViewMiddleBorder = [UIView new];
  alertButtonsViewMiddleBorder.backgroundColor = 
    alertButtonsViewTopBorder.backgroundColor;
  alertButtonsViewMiddleBorder.frame = CGRectMake(
    (alertButtonsView.frame.size.width - 0.5f) * 0.5, 0.0f, 
      0.5f, alertButtonsView.frame.size.height);
  [alertButtonsView addSubview: alertButtonsViewMiddleBorder];

  CGFloat alertButtonWidth = alertButtonsView.frame.size.width * 0.5f;
  // Alert confirm
  alertConfirm = [UIButton new];
  alertConfirm.frame = CGRectMake(alertButtonWidth, 0.0f, alertButtonWidth,
    alertButtonsView.frame.size.height);
  alertConfirm.titleLabel.font = alertTitle.font;
  [alertConfirm addTarget: self action: @selector(alertConfirmSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [alertConfirm setTitle: @"Accept" forState: UIControlStateNormal];
  [alertConfirm setTitleColor: [UIColor blue] forState: UIControlStateNormal];
  [alertButtonsView addSubview: alertConfirm];
  // Alert cancel
  alertCancel = [UIButton new];
  alertCancel.frame = CGRectMake(0.0f, 0.0f, alertButtonWidth,
    alertButtonsView.frame.size.height);
  alertCancel.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 18];
  [alertCancel addTarget: self action: @selector(alertCancelSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [alertCancel setTitle: @"Cancel" forState: UIControlStateNormal];
  [alertCancel setTitleColor: [UIColor blue] forState: UIControlStateNormal];
  [alertButtonsView addSubview: alertCancel];

  // Resize alert height
  alertHeight = alertButtonsView.frame.origin.y + 
    alertButtonsView.frame.size.height;
  alert.frame = CGRectMake(alert.frame.origin.x, 
    (screenHeight - alertHeight) * 0.5f, alert.frame.size.width, alertHeight);

  selectedSegmentIndex = 0;
  [self changeTableView];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];

  _animator = [[UIDynamicAnimator alloc] initWithReferenceView: 
    fadedBackground];
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // Fetch questions
  [[OMBLegalQuestionStore sharedStore] fetchLegalQuestionsWithCompletion:
    ^(NSError *error) {
      legalQuestions = 
        [[OMBLegalQuestionStore sharedStore] questionsSortedByQuestion];
      [_profileTableView reloadSections: [NSIndexSet indexSetWithIndex: 6]
        withRowAnimation: UITableViewRowAnimationFade];
    }
  ];

  [respondButton setTitle: @"Respond to Edward's Offer"
    forState: UIControlStateNormal];
}

#pragma mark - Protocol

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
  // Offer
  if (tableView == _offerTableView) {
    return 1;
  }
  // Profile
  else if (tableView == _profileTableView) {
    // Name, school, about
    // Co-signers
    // Co-applicants
    // Pets
    // Rental history
    // Work history
    // Legal stuff
    return 7;
  }
  return 0;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat padding = 20.0f;
  CGFloat standardHeight = 44.0f;
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
    // Residence
    if (indexPath.row == 0) {
      static NSString *ResidenceCellIdentifier = @"ResidenceCellIdentifier";
      OMBOfferInquiryResidenceCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier: ResidenceCellIdentifier];
      if (!cell1)
        cell1 = [[OMBOfferInquiryResidenceCell alloc] initWithStyle: 
          UITableViewCellStyleDefault
            reuseIdentifier: ResidenceCellIdentifier];
      [cell1 loadResidenceData];
      return cell1;
    }
    // Offer
    else if (indexPath.row == 1) {
      cell.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
        size: 27];
      cell.detailTextLabel.text = @"$2,400";
      cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
        size: 27];
      cell.textLabel.text = @"Offer";
    }
    // Move-in Date
    else if (indexPath.row == 2) {
      cell.detailTextLabel.text = @"March 2, 2014";
      cell.textLabel.text = @"Move-in Date";
    }
    // Move-out Date
    else if (indexPath.row == 3) {
      cell.detailTextLabel.text = @"October 12, 2014";
      cell.textLabel.text = @"Move-out Date";
    }
  }
  // Profile
  else if (tableView == _profileTableView) {
    // Name, school, about
    if (indexPath.section == 0) {
      // Name and school
      if (indexPath.row == 0) {
        static NSString *NameCellIdentifier = @"NameCellIdentifier";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
          NameCellIdentifier];
        if (!cell1)
          cell1 = [[UITableViewCell alloc] initWithStyle: 
            UITableViewCellStyleSubtitle reuseIdentifier: NameCellIdentifier];
        cell1.detailTextLabel.font = 
          [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
        cell1.detailTextLabel.text = @"University of California - Berkeley";
        cell1.detailTextLabel.textColor = [UIColor grayMedium];
        cell1.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
          size: 18];
        cell1.textLabel.text = @"Edward Drake";
        cell1.textLabel.textColor = [UIColor blueDark];
        return cell1;
      }
      // About
      else if (indexPath.row == 1) {
        cell.textLabel.attributedText = 
          [fakeAbout attributedStringWithFont: cell.textLabel.font 
            lineHeight: 22.0f];
        cell.textLabel.numberOfLines = 0;
      }
    }
    // Co-signers
    else if (indexPath.section == 1) {
      static NSString *CosignerCellIdentifier = @"CosignerCellIdentifier";
      OMBCosignerCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier: CosignerCellIdentifier];
      if (!cell1)
        cell1 = [[OMBCosignerCell alloc] initWithStyle: 
          UITableViewCellStyleDefault
            reuseIdentifier: CosignerCellIdentifier];
      OMBCosigner *cosigner = [[OMBCosigner alloc] init];
      cosigner.email = @"drew@onmyblock.com";
      cosigner.firstName = @"Drew";
      cosigner.lastName = @"Houston";
      cosigner.phone = @"4088581234";
      cosigner.uid = indexPath.row;
      [cell1 loadData: cosigner];
      return cell1;
    }
    // Co-applicants
    else if (indexPath.section == 2) {
      static NSString *CoapplicantCellIdentifier = @"CoapplicantCellIdentifier";
      OMBCoapplicantCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier: 
          CoapplicantCellIdentifier];
      if (!cell1)
        cell1 = [[OMBCoapplicantCell alloc] initWithStyle: 
          UITableViewCellStyleDefault
            reuseIdentifier: CoapplicantCellIdentifier];
      if (indexPath.row % 2) {
        [cell1 loadUserData];
      }
      else {
        [cell1 loadUnregisteredUserData];
      }
      return cell1;
    }
    // Pets
    else if (indexPath.section == 3) {
      static NSString *PetCellIdentifier = @"PetCellIdentifier";
      UITableViewCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier: 
          PetCellIdentifier];
      if (!cell1) {
        cell1 = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleDefault
            reuseIdentifier: PetCellIdentifier];
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(padding, padding, 
          standardHeight, standardHeight);
        if (indexPath.row % 2) {
          imageView.image = [UIImage imageNamed: @"dogs_icon.png"];
        }
        else {
          imageView.image = [UIImage imageNamed: @"cats_icon.png"];
        }
        [cell1.contentView addSubview: imageView];
      }
      return cell1;
    }
    // Rental History
    else if (indexPath.section == 4) {
      static NSString *RentalCellIdentifier = @"RentalCellIdentifier";
      OMBPreviousRentalCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier: 
          RentalCellIdentifier];
      if (!cell1)
        cell1 = [[OMBPreviousRentalCell alloc] initWithStyle: 
          UITableViewCellStyleDefault
            reuseIdentifier: RentalCellIdentifier];
      if (indexPath.row % 2) {
        [cell1 loadFakeData1];
      }
      else {
        [cell1 loadFakeData2];
      }
      return cell1;
    }
    // Work History
    else if (indexPath.section == 5) {
      // View Linkedin Profile
      if (indexPath.row == 0) {
        static NSString *LinkedinCellIdentifier = @"LinkedinCellIdentifier";
        UITableViewCell *cell1 = 
          [tableView dequeueReusableCellWithIdentifier: 
            LinkedinCellIdentifier];
        if (!cell1) {
          cell1 = [[UITableViewCell alloc] initWithStyle: 
            UITableViewCellStyleDefault
              reuseIdentifier: LinkedinCellIdentifier];
          // Button
          UIButton *button = [UIButton new];
          button.backgroundColor = [UIColor linkedinBlue];
          button.frame = CGRectMake(padding, padding, 
            tableView.frame.size.width - (padding * 2), standardHeight);
          button.layer.cornerRadius = 5.0f;
          CGFloat imageSize = standardHeight - (padding * 0.5f);
          button.titleEdgeInsets = UIEdgeInsetsMake(0.0f, padding * 0.5f, 
            0.0f, 0.0f);
          button.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
            size: 15];
          [button setTitle: @"View Linkedin Profile"
            forState: UIControlStateNormal];
          [cell1.contentView addSubview: button];
          // Image
          UIImageView *imageView = [UIImageView new];
          imageView.frame = CGRectMake(padding * 0.5f, padding * 0.25f, 
            imageSize, imageSize);
          imageView.image = [UIImage imageNamed: @"linkedin_icon.png"];
          [button addSubview: imageView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
      }
      else {
        static NSString *EmploymentCellIdentifier = @"EmploymentCellIdentifier";
        OMBEmploymentCell *cell1 = 
          [tableView dequeueReusableCellWithIdentifier: 
            EmploymentCellIdentifier];
        if (!cell1)
          cell1 = [[OMBEmploymentCell alloc] initWithStyle: 
            UITableViewCellStyleDefault
              reuseIdentifier: EmploymentCellIdentifier];
        [cell1 loadFakeData];
        return cell1;
      }
    }
    // Legal Stuff
    else if (indexPath.section == 6) {
      static NSString *LegalCellIdentifier = @"LegalCellIdentifier";
      OMBLegalQuestionAndAnswerCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier: 
          LegalCellIdentifier];
      if (!cell1)
        cell1 = [[OMBLegalQuestionAndAnswerCell alloc] initWithStyle: 
          UITableViewCellStyleDefault
            reuseIdentifier: LegalCellIdentifier];
      [cell1 loadData: [legalQuestions objectAtIndex: indexPath.row] 
        atIndexPath: indexPath];
      return cell1;
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Offer
  if (tableView == _offerTableView) {
    return 4;
  }
  // Profile
  else if (tableView == _profileTableView) {
    // Name & school, about
    if (section == 0) {
      return 2;
    }
    // Co-signers
    else if (section == 1) {
      return 3;
    }
    // Co-applicants
    else if (section == 2) {
      return 2;
    }
    // Pets
    else if (section == 3) {
      return 2;
    }
    // Rental History
    else if (section == 4) {
      return 2;
    }
    // Work History
    else if (section == 5) {
      // View Linkedin Profile
      // Previous Employment
      return 1 + 3;
    }
    // Legal Stuff
    else if (section == 6) {
      return [legalQuestions count];
    }
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Offer
  if (tableView == _offerTableView) {
    // Residence
    if (indexPath.row == 0) {
      [self.navigationController pushViewController: 
        [[OMBResidenceDetailViewController alloc] initWithResidence: nil] 
          animated: YES];
    }
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
  CGFloat padding = 20.0f;
  CGFloat standardHeight = 44.0f;
  // Offer
  if (tableView == _offerTableView) {
    // Residence
    if (indexPath.row == 0) {
      return [OMBOfferInquiryResidenceCell heightForCell];
    }
    // Offer
    else if (indexPath.row == 1) {
      return padding + 36.0f + padding;
    }
    // Move-in Date
    else if (indexPath.row == 2) {
      return standardHeight;
    }
    // Move-out Date
    else if (indexPath.row == 3) {
      return standardHeight;
    }
  }
  // Profile
  else if (tableView == _profileTableView) {
    // Name & school, about
    if (indexPath.section == 0) {
      // Name & school
      if (indexPath.row == 0) {
        return padding + 23.0f + 20.0f + padding;
      }
      // About
      else if (indexPath.row == 1) {
        NSAttributedString *aString = [fakeAbout attributedStringWithFont: 
          [UIFont fontWithName: @"HelveticaNeue-Light" size: 15] 
            lineHeight: 22.0f];
        CGRect rect = [aString boundingRectWithSize: 
          CGSizeMake(tableView.frame.size.width - (padding * 2), 9999) 
            options: NSStringDrawingUsesLineFragmentOrigin context: nil];
        return padding + rect.size.height + padding;
      }
    }
    // Co-signers
    else if (indexPath.section == 1) {
      return [OMBCosignerCell heightForCell];
    }
    // Co-applicants
    else if (indexPath.section == 2) {
      return [OMBCoapplicantCell heightForCell];
    }
    // Pets
    else if (indexPath.section == 3) {
      return padding + standardHeight + padding;
    }
    // Rental History
    else if (indexPath.section == 4) {
      return [OMBPreviousRentalCell heightForCell];
    }
    // Work History
    else if (indexPath.section == 5) {
      // View Linkedin Profile
      if (indexPath.row == 0) {
        return padding + standardHeight + padding;
      }
      // Previous Employment
      else {
        return padding + (22.0f * 3) + padding;
      }
    }
    // Legal Stuff
    else if (indexPath.section == 6) {
      OMBLegalQuestion *legalQuestion = [legalQuestions objectAtIndex: 
        indexPath.row];
      CGRect rect = [legalQuestion.question boundingRectWithSize:
        CGSizeMake([OMBLegalQuestionAndAnswerCell widthForQuestionLabel], 9999)
          font: [OMBLegalQuestionAndAnswerCell fontForQuestionLabel]];
      return padding + rect.size.height + (padding * 0.5) + 22.0f + padding;
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
  label.textColor = [UIColor blueDark];
  [blurView addSubview: label];
  NSString *titleString = @"";
  // Profile
  if (tableView == _profileTableView) {
    // Co-signers
    if (section == 1) {
      titleString = @"Co-signers";
    }
    // Co-applicants
    else if (section == 2) {
      titleString = @"Co-applicants";
    }
    // Pets
    else if (section == 3) {
      titleString = @"Pets";
    }
    // Rental History
    else if (section == 4) {
      titleString = @"Rental History";
    }
    // Work History
    else if (section == 5) {
      titleString = @"Work History";
    }
    // Legal Stuff
    else if (section == 6) {
      titleString = @"Legal Stuff";
    }
  }
  label.text = titleString;
  return blurView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) alertCancelSelected
{
  [_animator removeBehavior: _snapBehavior];

  alert.alpha = 0.9f;
  alert.backgroundColor = [UIColor whiteColor];

  // _gravityBehavior = 
  //   [[UIGravityBehavior alloc] initWithItems: @[alert]];
  // _gravityBehavior.gravityDirection = CGVectorMake(0, 10);
  // [_animator addBehavior: _gravityBehavior];
 
  // _itemBehavior = 
  //   [[UIDynamicItemBehavior alloc] initWithItems: @[alert]];
  // CGFloat velocity = M_PI_2;
  // if (arc4random_uniform(100) % 2) {
  //   velocity *= -1;
  // }
  // [_itemBehavior addAngularVelocity: velocity forItem: alert];
  // [_animator addBehavior: _itemBehavior];

  [UIView animateWithDuration: 0.15f animations: ^{
    CGRect rect = alert.frame;
    rect.origin.y = fadedBackground.frame.size.height;
    alert.frame = rect;
  } completion: ^(BOOL finished) {
    [UIView animateWithDuration: 0.25f delay: 0.0f 
      options: UIViewAnimationOptionCurveLinear animations: ^{
        fadedBackground.alpha = 0.0f;
      } completion: ^(BOOL finished) {
        [fadedBackground removeFromSuperview];
      }
    ];
  }];

  accepted = NO;
  acceptedConfirmed = NO;
}

- (void) alertConfirmSelected
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;

  if (accepted && acceptedConfirmed) {
    [self.navigationController pushViewController:
      [[OMBPayoutMethodsViewController alloc] init] animated: YES];
    [self alertCancelSelected];
  }
  else {
    if (!accepted) {
      accepted = YES;
      // Alert title
      alertTitle.text = @"Are You Sure?";
      // Alert message
      alertMessage.text = @"Accepting Edward's offer will automatically "
        @"decline all other offers.";
      // Alert buttons
      [alertConfirm setTitle: @"Yes" forState: UIControlStateNormal];
      [alertCancel setTitle: @"No" forState: UIControlStateNormal];
    }
    else if (!acceptedConfirmed) {
      acceptedConfirmed = YES;
      // Alert title
      alertTitle.text = @"Offer Accepted";
      // Alert message
      alertMessage.text = @"Please set up a way to get paid.";
      [alertConfirm setTitle: @"Setup" forState: UIControlStateNormal];
      [alertCancel setTitle: @"Ok" forState: UIControlStateNormal];
    }
    CGRect alertMessageRect = [alertMessage.text boundingRectWithSize:
      CGSizeMake(alertTitle.frame.size.width, 9999) font: alertMessage.font];
    alertMessage.frame = CGRectMake(alertTitle.frame.origin.x,
      alertTitle.frame.origin.y + 
      alertTitle.frame.size.height + (padding * 0.5),
        alertTitle.frame.size.width, alertMessageRect.size.height);
    // Alert buttons
    alertButtonsView.frame = CGRectMake(0.0f, 
      alertMessage.frame.origin.y + alertMessage.frame.size.height + padding,
        alert.frame.size.width, 44.0f);
    // Resize alert height
    CGFloat alertHeight = alertButtonsView.frame.origin.y + 
      alertButtonsView.frame.size.height;
    alert.frame = CGRectMake(alert.frame.origin.x, 
      (screen.size.height - alertHeight) * 0.5f, 
        alert.frame.size.width, alertHeight);
    [UIView animateWithDuration: 0.1f animations: ^{
      alert.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    } completion: ^(BOOL finished) {
      [UIView animateWithDuration: 0.1f animations: ^{
        alert.transform = CGAffineTransformIdentity;
      }];
    }];

  }
}

- (void) changeTableView
{
  CGFloat padding = 20.0f;
  if (selectedSegmentIndex == 0) {
    offerButton.backgroundColor   = [UIColor colorWithWhite: 1.0f alpha: 0.5f];
    profileButton.backgroundColor = [UIColor clearColor];
    contactButton.backgroundColor = [UIColor clearColor];

    _offerTableView.hidden   = NO;
    _profileTableView.hidden = YES;

    // Change the content offset of activity table view 
    // if payments table view is not scrolled pass the threshold
    CGFloat threshold = backView.frame.size.height - 
      (padding + buttonsView.frame.size.height + padding);
    if (_profileTableView.contentOffset.y < threshold) {
      _offerTableView.contentOffset = _profileTableView.contentOffset;
    }
    // If activity table view content offset is less than threshold
    else if (_offerTableView.contentOffset.y < threshold) {
      _offerTableView.contentOffset = CGPointMake(
        _offerTableView.contentOffset.x, threshold);
    }
  }
  else if (selectedSegmentIndex == 1) {  
    offerButton.backgroundColor   = [UIColor clearColor];
    profileButton.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.5f];
    contactButton.backgroundColor = [UIColor clearColor];

    _offerTableView.hidden   = YES;
    _profileTableView.hidden = NO;

    // Change the content offset of payments table view 
    // if activity table view is not scrolled pass the threshold
    CGFloat threshold = backView.frame.size.height -
      (padding + buttonsView.frame.size.height + padding);
    if (_offerTableView.contentOffset.y < threshold) {
      _profileTableView.contentOffset = _offerTableView.contentOffset;
    }
    // If payments table view content offset is less than threshold
    else if (_profileTableView.contentOffset.y < threshold) {
      _profileTableView.contentOffset = CGPointMake(
        _profileTableView.contentOffset.x, threshold);
    }
  }
  else if (selectedSegmentIndex == 2) {
    [[OMBMessageStore sharedStore] createFakeMessages];
    [self.navigationController pushViewController: 
      [[OMBMessageDetailViewController alloc] initWithUser: [OMBUser fakeUser]]
        animated: YES];
  }
}

- (void) respond
{
  [_animator removeBehavior: _gravityBehavior];
  [_animator removeBehavior: _itemBehavior];

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;

  // Reset the alert view
  alert.alpha = 1.0f;
  alert.backgroundColor = [UIColor clearColor];
  alert.transform = CGAffineTransformIdentity;
  alert.frame = CGRectMake((screen.size.width - alert.frame.size.width) * 0.5,
    screen.size.height, alert.frame.size.width, alert.frame.size.height);

  // Re-add the faded background
  [[[UIApplication sharedApplication] keyWindow] addSubview: fadedBackground];
  [UIView animateWithDuration: 0.15f animations: ^{
    fadedBackground.alpha = 1.0f;
  } completion: ^(BOOL finished) {
    [UIView animateWithDuration: 0.15f animations: ^{
      CGRect rect = alert.frame;
      rect.origin.y = (screen.size.height - alert.frame.size.height) * 0.5f;
      alert.frame = rect;
    }];
    // Snap the button in the middle
    // _snapBehavior = [[UISnapBehavior alloc] initWithItem: 
    //   alert snapToPoint: [self appDelegate].window.center];
    // // We decrease the damping so the view has a little less spring.
    // _snapBehavior.damping = 0.8f;
    // [_animator addBehavior: _snapBehavior];
  }];

  // Alert title
  alertTitle.text = @"Respond to Offer";
  // Alert message
  alertMessage.text = @"Edward would like to rent this place from January 1,"
    @" 2014 through December 12, 2014 for $2,575 a month.";
  CGRect alertMessageRect = [alertMessage.text boundingRectWithSize:
    CGSizeMake(alertTitle.frame.size.width, 9999) font: alertMessage.font];
  alertMessage.frame = CGRectMake(alertTitle.frame.origin.x,
    alertTitle.frame.origin.y + alertTitle.frame.size.height + (padding * 0.5),
      alertTitle.frame.size.width, alertMessageRect.size.height);
  // Alert buttons
  alertButtonsView.frame = CGRectMake(0.0f, 
    alertMessage.frame.origin.y + alertMessage.frame.size.height + padding,
      alert.frame.size.width, 44.0f);
  // Resize alert height
  CGFloat alertHeight = alertButtonsView.frame.origin.y + 
    alertButtonsView.frame.size.height;
  alert.frame = CGRectMake(alert.frame.origin.x, 
    (screen.size.height - alertHeight) * 0.5f, 
      alert.frame.size.width, alertHeight);
  // Alert buttons
  [alertConfirm setTitle: @"Accept" forState: UIControlStateNormal];
  [alertCancel setTitle: @"Decline" forState: UIControlStateNormal];
}

- (void) segmentButtonSelected: (UIButton *) button
{
  selectedSegmentIndex = button.tag;
  [self changeTableView];
}

@end
