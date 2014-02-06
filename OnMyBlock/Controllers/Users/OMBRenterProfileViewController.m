//
//  OMBRenterProfileViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterProfileViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "OMBBecomeVerifiedViewController.h"
#import "OMBCenteredImageView.h"
#import "OMBEditProfileViewController.h"
#import "OMBEmploymentCell.h"
#import "OMBGradientView.h"
#import "OMBManageListingsCell.h"
#import "OMBMessageDetailViewController.h"
#import "OMBNavigationController.h"
#import "OMBRenterApplication.h"
#import "OMBRenterProfileUserInfoCell.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBUser.h"
#import "OMBViewControllerContainer.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"
#import "UIImage+NegativeImage.h"
#import "UIImage+Resize.h"

@implementation OMBRenterProfileViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Renter Profile View Controller";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  [self setupForTable];

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight   = screen.size.height;
  CGFloat screenWidth    = screen.size.width;
  CGFloat padding        = OMBPadding;
  CGFloat standardHeight = OMBStandardHeight;

  contactBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Contact"
    style: UIBarButtonItemStylePlain target: self action: @selector(contact)];
  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
    style: UIBarButtonItemStylePlain target: self action: @selector(done)];
  editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Edit"
    style: UIBarButtonItemStylePlain target: self action: @selector(edit)];

  self.view.backgroundColor = self.table.backgroundColor = [UIColor clearColor];

  // The background is white, 
  // use this to cover it when scrolling pass the bottom
  // UIView *bottomBackground = [UIView new];
  // bottomBackground.backgroundColor = [UIColor grayUltraLight];
  // bottomBackground.frame = CGRectMake(0.0f, screenHeight * 0.5f,
  //   screenWidth, screenHeight * 0.5f);
  // [self.view insertSubview: bottomBackground belowSubview: self.table];

  // Back view
  backViewOriginY = padding + standardHeight;
  backView = [UIView new];
  backView.frame = CGRectMake(0.0f, backViewOriginY, 
    screenWidth, screenHeight * 0.4f);
  [self.view insertSubview: backView belowSubview: self.table];
  // Back image view
  backImageView = [[OMBCenteredImageView alloc] init];
  backImageView.frame = backView.bounds;
  [backView addSubview: backImageView];
  // Gradient
  OMBGradientView *gradient = [[OMBGradientView alloc] init];
  gradient.colors = @[
    [UIColor colorWithWhite: 0.0f alpha: 0.0f],
    [UIColor colorWithWhite: 0.0f alpha: 0.5f]
  ];
  gradient.frame = backImageView.frame;
  [backView addSubview: gradient];

  // Name view
  CGFloat nameViewHeight = OMBStandardButtonHeight;
  nameViewOriginY = (backView.frame.origin.y + backView.frame.size.height) - 
    (nameViewHeight + padding);
  nameView = [UIView new];
  // nameView.backgroundColor = [UIColor redColor];
  nameView.frame = CGRectMake(0.0f, nameViewOriginY, 
    screenWidth, nameViewHeight);
  [self.view insertSubview: nameView belowSubview: self.table];
  // User icon
  userIconView = [[OMBCenteredImageView alloc] init];
  userIconView.frame = CGRectMake(padding, 0.0f, 
    nameViewHeight, nameViewHeight);
  userIconView.layer.cornerRadius = userIconView.frame.size.width * 0.5f;
  [nameView addSubview: userIconView];
  // Full name label
  fullNameLabel = [UILabel new];
  fullNameLabel.font = [UIFont largeTextFont];
  fullNameLabel.frame = CGRectMake(
    userIconView.frame.origin.x + userIconView.frame.size.width + padding, 
      0.0f, nameView.frame.size.width - (userIconView.frame.origin.x + 
      userIconView.frame.size.width + padding + padding), nameViewHeight);
  fullNameLabel.textColor = [UIColor whiteColor];
  [nameView addSubview: fullNameLabel];

  // Table header view
  UIView *tableHeaderView = [UIView new];
  tableHeaderView.backgroundColor = [UIColor clearColor];
  tableHeaderView.frame = CGRectMake(0.0f, 0.0f, screenWidth, 
    backViewOriginY + backView.frame.size.height);
  self.table.tableHeaderView = tableHeaderView;

  // Edit button
  editButtonView = [[AMBlurView alloc] init];
  editButtonView.blurTintColor = [UIColor blue];
  editButtonView.frame = CGRectMake(0.0f, screenHeight - OMBStandardHeight,
    screenWidth, OMBStandardHeight);
  [self.view addSubview: editButtonView];
  // Button
  editButton = [UIButton new];
  editButton.frame = editButtonView.bounds;
  editButton.titleLabel.font = [UIFont mediumTextFontBold];
  // [editButton addTarget: self action: @selector(edit)
  //   forControlEvents: UIControlEventTouchUpInside];
  [editButton addTarget: self action: @selector(showBecomeVerified)
    forControlEvents: UIControlEventTouchUpInside];
  [editButton setBackgroundImage: [UIImage imageWithColor: 
    [UIColor blueHighlighted]] forState: UIControlStateHighlighted];
  [editButton setTitle: @"Complete Your Renter Profile"
    forState: UIControlStateNormal];
  [editButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [editButtonView addSubview: editButton];

  // Contact bar button items
  // Left padding
  UIBarButtonItem *leftPadding = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemFixedSpace target: nil action: nil];
  // iOS 7 toolbar spacing is 16px; 20px on iPad
  leftPadding.width = 4.0f;
  // Send Message
  UIBarButtonItem *messageBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Send Message"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(sendMessage)];
  [messageBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: [UIFont normalTextFont],
    NSForegroundColorAttributeName: [UIColor blue]
  } forState: UIControlStateNormal];
  // Spacing
  UIBarButtonItem *flexibleSpace = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: 
      UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
  // Phone
  UIImage *phoneIcon = [UIImage image: [UIImage imageNamed: @"phone_icon.png"]
    size: CGSizeMake(22.0f, 22.0f)];
  phoneBarButtonItem = 
    [[UIBarButtonItem alloc] initWithImage: phoneIcon style:
      UIBarButtonItemStylePlain target: self action: @selector(phoneCallUser)];
  // Email
  UIImage *emailIcon = [UIImage image: [UIImage imageNamed: 
    @"messages_icon_white.png"] size: CGSizeMake(22.0f, 22.0f)];
  emailBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage: emailIcon style:
      UIBarButtonItemStylePlain target: self action: @selector(emailUser)];
  // Right padding
  UIBarButtonItem *rightPadding = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemFixedSpace target: nil action: nil];
  // iOS 7 toolbar spacing is 16px; 20px on iPad
  rightPadding.width = 4.0f;

  // Contact toolbar that drops down when you tap contact
  contactToolbar = [UIToolbar new];
  contactToolbar.clipsToBounds = YES;
  contactToolbar.frame = CGRectMake(0.0f, padding, 
    screenWidth, standardHeight);
  contactToolbar.hidden = YES;
  contactToolbar.items = @[leftPadding, messageBarButtonItem, flexibleSpace,
    phoneBarButtonItem, rightPadding, emailBarButtonItem];
  contactToolbar.tintColor = [UIColor blue];
  [self.view addSubview: contactToolbar];
  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.backgroundColor = [UIColor grayLight].CGColor;
  bottomBorder.frame = CGRectMake(0.0f, contactToolbar.frame.size.height - 0.5f,
    contactToolbar.frame.size.width, 0.5f);
  [contactToolbar.layer addSublayer: bottomBorder];
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];

  if (!contactToolbar.hidden)
    [self done];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // If the current user is looking at their own renter profile
  if ([user isCurrentUser] && ![user isLandlord]) {
    // Check to see if the edit button should be at the bottom
    [self updateEditButton];
  }
  else {
    editButtonView.hidden = YES;
    self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
  }

  // We only want to show the menu icon if its the root view controller
  if ([self.navigationController.viewControllers count] == 1) {
    [self setMenuBarButtonItem];
  }

  [self reloadData];

  // If user is the landlord
  if ([user isLandlord]) {
    // Fetch listings
    [user fetchListingsWithCompletion: ^(NSError *error) {
      [self.table reloadData];
      // [self.table reloadSections: 
      //   [NSIndexSet indexSetWithIndex: OMBRenterProfileSectionListings] 
      //     withRowAnimation: UITableViewRowAnimationFade];
    }];
  }
  else {
    // Fetch the information about the user, specifically the renter application
    [user fetchUserProfileWithCompletion: ^(NSError *error) {
      [self.table reloadData];
      // [self.table reloadSections: 
      //   [NSIndexSet indexSetWithIndex: OMBRenterProfileSectionRenterInfo] 
      //     withRowAnimation: UITableViewRowAnimationFade];
    }];
    // Fetch the employments
    [user fetchEmploymentsWithCompletion: ^(NSError *error) {
      [self.table reloadData];
      // [self.table reloadSections: 
      //   [NSIndexSet indexSetWithIndex: OMBRenterProfileSectionEmployment] 
      //     withRowAnimation: UITableViewRowAnimationFade];
    }];
  }

  // [self showBecomeVerified];
}

#pragma mark - Protocol

#pragma mark - Protocol MFMailComposeViewControllerDelegate

- (void) mailComposeController: (MFMailComposeViewController*) controller 
didFinishWithResult: (MFMailComposeResult) result error: (NSError*) error
{
  [controller dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGFloat y = scrollView.contentOffset.y;
  CGFloat adjustment = y / 3.0f;
  
  // Move up
  // Back view
  CGRect backViewRect = backView.frame;
  CGFloat newOriginY = backViewOriginY - adjustment;
  if (newOriginY > backViewOriginY)
    newOriginY = backViewOriginY;
  backViewRect.origin.y = newOriginY;
  backView.frame = backViewRect;

  // Name view
  CGRect nameViewRect = nameView.frame;
  CGFloat newNameViewOriginY = nameViewOriginY - y;
  if (newNameViewOriginY > nameViewOriginY)
    newNameViewOriginY = nameViewOriginY;
  nameViewRect.origin.y = newNameViewOriginY;
  nameView.frame = nameViewRect;

  // Scale
  // Back image view
  CGFloat newScale = 1 + ((y * -3) / backImageView.imageView.frame.size.height);
  if (newScale < 1)
    newScale = 1;
  backImageView.imageView.transform = CGAffineTransformScale(
    CGAffineTransformIdentity, newScale, newScale);
}

- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
  if (!contactToolbar.hidden)
    [self done];
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // User info
  // Rental info
  // Employment
  // Listings
  return 4;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat padding = OMBPadding;
  static NSString *EmptyCellID = @"EmptyCellID";
  UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:
    EmptyCellID];
  if (!emptyCell)
    emptyCell = [[UITableViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: EmptyCellID];
  // User info
  if (indexPath.section == OMBRenterProfileSectionUserInfo) {
    static NSString *UserInfoID = @"UserInfoID";
    OMBRenterProfileUserInfoCell *cell = 
      [tableView dequeueReusableCellWithIdentifier: UserInfoID];
    if (!cell)
      cell = [[OMBRenterProfileUserInfoCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: UserInfoID];
    [cell reset];
    UIView *bor = [cell.contentView viewWithTag: 9999];
    if (!bor) {
      bor = [UIView new];
      bor.backgroundColor = tableView.separatorColor;
      bor.tag = 9999;
    }
    CGSize imageSize = cell.iconImageView.bounds.size;
    // Name
    if (indexPath.row == OMBRenterProfileSectionUserInfoRowName) {
      cell.iconImageView.image = [UIImage image: 
        [UIImage imageNamed: @"user_icon.png"] size: imageSize];
      if ([[user fullName] length]) {
        cell.label.text = [user fullName];
        cell.label.textColor = [UIColor textColor];
      }
      else {
        cell.label.text = @"Full name";
        cell.label.textColor = [UIColor grayMedium];
      }
    }
    // School
    else if (indexPath.row == OMBRenterProfileSectionUserInfoRowSchool) {
      cell.iconImageView.image = [UIImage image: 
        [UIImage imageNamed: @"school_icon.png"] size: imageSize];
      if (user.school && [user.school length]) {
        cell.label.text = user.school;
        cell.label.textColor = [UIColor textColor];
      }
      else {
        if ([user isCurrentUser]) {
          cell.label.text = @"Your school";
        }
        else {
          cell.label.text = @"No school specified yet";
        }
        cell.label.textColor = [UIColor grayMedium];
      }
    }
    // Email
    else if (indexPath.row == OMBRenterProfileSectionUserInfoRowEmail) {
      cell.iconImageView.image = [UIImage image: 
        [UIImage imageNamed: @"messages_icon_dark.png"] size: imageSize];
      if (user.email && [user.email length]) {
        cell.label.text = [user.email lowercaseString];
        if ([user isCurrentUser]) {
          cell.label.textColor = [UIColor textColor];
        }
        else {
          cell.label.textColor = [UIColor blue];
        }
      }
      else {
        cell.label.text = @"Email";
        cell.label.textColor = [UIColor grayMedium];
      }
    }
    // Phone
    else if (indexPath.row == OMBRenterProfileSectionUserInfoRowPhone) {
      cell.iconImageView.image = [UIImage image: 
        [UIImage imageNamed: @"phone_icon.png"] size: imageSize];
      if (user.phone && [user.phone length]) {
        cell.label.text = [user phoneString];
        if ([user isCurrentUser]) {
          cell.label.textColor = [UIColor textColor];
        }
        else {
          cell.label.textColor = [UIColor blue];
        }
      }
      else {
        cell.label.text = @"Phone number";
        cell.label.textColor = [UIColor grayMedium];
      }
    }
    // About
    else if (indexPath.row == OMBRenterProfileSectionUserInfoRowAbout) {
      cell.iconImageView.image = [UIImage image: 
        [UIImage imageNamed: @"info_icon.png"] size: imageSize];
      [cell loadUserAbout: user];
      // bor.frame = CGRectMake(0.0f, (cell.label.frame.origin.y + 
      //   cell.label.frame.size.height + padding) - 0.5f, 
      //     tableView.frame.size.width, 0.5f);
      // [bor removeFromSuperview];
      // [cell.contentView addSubview: bor];
      cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
        0.0f, 0.0f);
    }
    return cell;
  }
  // Renter info
  else if (indexPath.section == OMBRenterProfileSectionRenterInfo) {
    // Rental Info Header
    if (indexPath.row == 
      OMBRenterProfileSectionRenterInfoRowPriorityRentalInfoHeader) {
      static NSString *RentalInfoHeaderCellID = @"RentalInfoHeaderCellID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        RentalInfoHeaderCellID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: RentalInfoHeaderCellID];
        cell.backgroundColor = [UIColor grayUltraLight];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 
          tableView.frame.size.width, 0.0f, 0.0f);
        // Priority Rental Info
        UILabel *headLabel = [UILabel new];
        headLabel.font = [UIFont mediumTextFont];
        headLabel.frame = CGRectMake(0.0f, padding, 
          tableView.frame.size.width, OMBStandardHeight);
        headLabel.text = @"Important Renter Verifications";
        headLabel.textAlignment = NSTextAlignmentCenter;
        headLabel.textColor = [UIColor grayMedium];
        [cell.contentView addSubview: headLabel];
        // Border top
        UIView *bor = [cell.contentView viewWithTag: 9999];
        if (!bor) {
          bor = [UIView new];
          bor.backgroundColor = tableView.separatorColor;
          bor.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 0.5f);
          bor.tag = 9999;
        }
        [cell.contentView addSubview: bor];
      }
      return cell;
    }
    // Rental Info Note
    else if (indexPath.row == 
      OMBRenterProfileSectionRenterInfoRowPriorityRentalInfoNote) {
      static NSString *RentalInfoNoteCellID = @"RentalInfoNoteCellID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        RentalInfoNoteCellID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: RentalInfoNoteCellID];
        cell.backgroundColor = [UIColor grayUltraLight];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 
          tableView.frame.size.width, 0.0f, 0.0f);
        // Note
        UILabel *label1 = [UILabel new];
        UILabel *label2 = [UILabel new];
        UILabel *label3 = [UILabel new];
        NSArray *array = @[label1, label2, label3];
        for (UILabel *label in array) {
          label.font = [UIFont normalTextFont];
          // label.frame = CGRectMake(padding, 
          //   padding + (22.0f * [array indexOfObject: label]), 
          //     tableView.frame.size.width - (padding * 2), 22.0f);
          label.frame = CGRectMake(padding, 
            22.0f * [array indexOfObject: label], 
              tableView.frame.size.width - (padding * 2), 22.0f);
          label.textAlignment = NSTextAlignmentCenter;
          label.textColor = [UIColor grayMedium];
          [cell.contentView addSubview: label];
        }
        // label1.text = @"Including this information in your";
        // label2.text = @"Renter Profile will give you a way better";
        // label3.text = @"chance at nabbing the best place.";
        label1.text = @"Becoming renter verified will";
        label2.text = @"give you a much better chance";
        label3.text = @"at securing the best places.";
      }
      return cell;
    }
    // Become Renter Verified
    else if (indexPath.row == 
      OMBRenterProfileSectionRenterInfoRowBecomeRenterVerified) {
      static NSString *BecomeCellID = @"BecomeCellID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        BecomeCellID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: BecomeCellID];
        cell.backgroundColor = [UIColor grayUltraLight];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 
          tableView.frame.size.width, 0.0f, 0.0f);
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor whiteColor];
        button.clipsToBounds = YES;
        button.frame = CGRectMake(padding, padding,
          tableView.frame.size.width - (padding * 2), OMBStandardButtonHeight);
        button.layer.borderColor = [UIColor blue].CGColor;
        button.layer.borderWidth = 1.0f;
        button.layer.cornerRadius = button.frame.size.height * 0.5f;
        button.titleLabel.font = [UIFont mediumTextFont];
        [button addTarget: self action: @selector(showBecomeVerified)
          forControlEvents: UIControlEventTouchUpInside];
        [button setBackgroundImage: [UIImage imageWithColor: [UIColor blue]]
          forState: UIControlStateHighlighted];
        [button setTitle: @"Become Renter Verified"
          forState: UIControlStateNormal];
        [button setTitleColor: [UIColor blue]
          forState: UIControlStateNormal];
        [button setTitleColor: [UIColor whiteColor]
          forState: UIControlStateHighlighted];
        [cell.contentView addSubview: button];
        UIView *bor = [cell.contentView viewWithTag: 9999];
        if (!bor) {
          bor = [UIView new];
          bor.backgroundColor = tableView.separatorColor;
          bor.frame = CGRectMake(0.0f, 
            padding + OMBStandardButtonHeight + padding - 0.5f, 
              tableView.frame.size.width, 0.5f);
          bor.tag = 9999;
        }
        [cell.contentView addSubview: bor];
      }
      return cell;
    }
    // Co-applicants, co-signer, facebook, linkedin
    else if (
      indexPath.row == OMBRenterProfileSectionRenterInfoRowCoapplicants ||
      indexPath.row == OMBRenterProfileSectionRenterInfoRowCosigner ||
      indexPath.row == OMBRenterProfileSectionRenterInfoRowFacebook ||
      indexPath.row == OMBRenterProfileSectionRenterInfoRowLinkedIn) {

      static NSString *RentalInfoID = @"RentalInfoID";
      OMBRenterProfileUserInfoCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: RentalInfoID];
      if (!cell)
        cell = [[OMBRenterProfileUserInfoCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: RentalInfoID];
      [cell reset];
      CGSize imageSize = cell.iconImageView.bounds.size;
      UIImage *image;
      NSString *string;
      NSString *valueString;
      // Co-applicants
      if (indexPath.row == OMBRenterProfileSectionRenterInfoRowCoapplicants) {
        image = [UIImage imageNamed: @"group_icon.png"];
        string = @"Co-applicants";
        valueString = [NSString stringWithFormat: @"%i",
          user.renterApplication.coapplicantCount];
      }
      // Co-signer
      else if (indexPath.row == OMBRenterProfileSectionRenterInfoRowCosigner) {
        image = [UIImage imageNamed: @"landlord_icon.png"];
        string = @"Co-signer";
        if (user.renterApplication.hasCosigner)
          valueString = @"Yes";
        else
          valueString = @"No";
      }
      // Facebook
      else if (indexPath.row == OMBRenterProfileSectionRenterInfoRowFacebook) {
        image  = [UIImage imageNamed: @"facebook_icon_blue.png"];
        string = @"Facebook";
        if (user.renterApplication.facebookAuthenticated) {
          cell.iconImageView.alpha = 1.0f;
          valueString = @"Verified";
        }
        else
          valueString = @"Unverified";
      }
      // LinkedIn
      else if (indexPath.row == OMBRenterProfileSectionRenterInfoRowLinkedIn) {
        image  = [UIImage imageNamed: @"linkedin_icon.png"];
        string = @"LinkedIn";
        if (user.renterApplication.linkedinAuthenticated) {
          cell.iconImageView.alpha = 1.0f;
          valueString = @"Verified";
        }
        else
          valueString = @"Unverified";
        // cell.separatorInset = UIEdgeInsetsMake(0.0f, 
        //   tableView.frame.size.width, 0.0f, 0.0f);
      }
      cell.iconImageView.image = [UIImage image: image size: imageSize];
      cell.label.text = string;
      cell.valueLabel.text = valueString;
      return cell;
    }
  }
  // Employment
  else if (indexPath.section == OMBRenterProfileSectionEmployment) {
    static NSString *EmploymentCellID = @"EmploymentCellID";
    OMBEmploymentCell *cell = [tableView dequeueReusableCellWithIdentifier:
      EmploymentCellID];
    if (!cell)
      cell = [[OMBEmploymentCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: EmploymentCellID];
    [cell loadData: 
      [[user.renterApplication employmentsSortedByStartDate] 
        objectAtIndex: indexPath.row]];
    return cell;
  }
  // Listings
  else if (indexPath.section == OMBRenterProfileSectionListings) {
    // Listings header
    if (indexPath.row == 
      OMBRenterProfileSectionListingsRowInfoHeader) {
      static NSString *ListingsHeaderCellID = @"ListingsHeaderCellID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        ListingsHeaderCellID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: ListingsHeaderCellID];
        cell.backgroundColor = [UIColor grayUltraLight];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 
          tableView.frame.size.width, 0.0f, 0.0f);
        // Priority Rental Info
        UILabel *headLabel = [UILabel new];
        headLabel.font = [UIFont mediumTextFont];
        headLabel.frame = CGRectMake(0.0f, padding, 
          tableView.frame.size.width, OMBStandardHeight);
        if ([user isCurrentUser])
          headLabel.text = @"My Listings";
        else
          headLabel.text = [NSString stringWithFormat: @"%@'s Listings",
            [user.firstName capitalizedString]];
        headLabel.textAlignment = NSTextAlignmentCenter;
        headLabel.textColor = [UIColor grayMedium];
        [cell.contentView addSubview: headLabel];
        // Border top
        UIView *bor = [cell.contentView viewWithTag: 9999];
        if (!bor) {
          bor = [UIView new];
          bor.backgroundColor = tableView.separatorColor;
          bor.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 0.5f);
          bor.tag = 9999;
        }
        [cell.contentView addSubview: bor];
      }
      return cell;
    }
    // Create listing
    else if (indexPath.row == OMBRenterProfileSectionListingsCreateListing) {
      static NSString *CreateListingID = @"CreateListingID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        CreateListingID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: CreateListingID];
        cell.backgroundColor = [UIColor grayUltraLight];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 
          tableView.frame.size.width, 0.0f, 0.0f);
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor whiteColor];
        button.clipsToBounds = YES;
        button.frame = CGRectMake(padding, 0.0f,
          tableView.frame.size.width - (padding * 2), OMBStandardButtonHeight);
        button.layer.borderColor = [UIColor blue].CGColor;
        button.layer.borderWidth = 1.0f;
        button.layer.cornerRadius = button.frame.size.height * 0.5f;
        button.titleLabel.font = [UIFont mediumTextFont];
        [button addTarget: self action: @selector(createListing)
          forControlEvents: UIControlEventTouchUpInside];
        [button setBackgroundImage: [UIImage imageWithColor: [UIColor blue]]
          forState: UIControlStateHighlighted];
        [button setTitle: @"Create Listing"
          forState: UIControlStateNormal];
        [button setTitleColor: [UIColor blue]
          forState: UIControlStateNormal];
        [button setTitleColor: [UIColor whiteColor]
          forState: UIControlStateHighlighted];
        [cell.contentView addSubview: button];
        UIView *bor = [cell.contentView viewWithTag: 9999];
        if (!bor) {
          bor = [UIView new];
          bor.backgroundColor = tableView.separatorColor;
          bor.frame = CGRectMake(0.0f, 
            OMBStandardButtonHeight + padding - 0.5f, 
              tableView.frame.size.width, 0.5f);
          bor.tag = 9999;
        }
        [cell.contentView addSubview: bor];
      }
      return cell;
    }
    // Listings
    else {
      static NSString *ListingsID = @"ListingsID";
      OMBManageListingsCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: ListingsID];
      if (!cell)
        cell = [[OMBManageListingsCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: ListingsID];
      // Minus 1 to account for the extra listings header
      [cell loadResidenceData: [[self listings] objectAtIndex: 
        indexPath.row - 2]];
      cell.statusLabel.hidden = YES;
      return cell;
    }
  }
  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // User info
  if (section == OMBRenterProfileSectionUserInfo) {
    // Name
    // School
    // Email
    // Phone
    // About
    return 5;
  }
  // Renter info
  else if (section == OMBRenterProfileSectionRenterInfo) {
    // Priority Rental Info Header
    // Co-applicants
    // Co-signer
    // Facebook
    // LinkedIn
    // Priority Rental Info Note
    // Become Renter Verified
    return 7;
  }
  // Employment
  else if (section == OMBRenterProfileSectionEmployment) {
    return [[user.renterApplication employmentsSortedByStartDate] count];
  }
  // Listings
  else if (section == OMBRenterProfileSectionListings) {
    // If the user has listings
    if ([[self listings] count]) {
      // Listings header, create listing, listings
      return 1 + 1 + [[self listings] count];
    }
    else {
      // Listings header, create listing
      return 1 + 1;
    }
  }
  return 0;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat padding = OMBPadding;
  // User info
  if (indexPath.section == OMBRenterProfileSectionUserInfo) {
    // Email
    if (indexPath.row == OMBRenterProfileSectionUserInfoRowEmail) {
      if (![user compareUser: [OMBUser currentUser]]) {
        return 0.0f;
      }
    }
    // School
    else if (indexPath.row == OMBRenterProfileSectionUserInfoRowSchool) {
      if (![user compareUser: [OMBUser currentUser]] && [user isLandlord]) {
        return 0.0f;
      }
    }
    // Phone
    else if (indexPath.row == OMBRenterProfileSectionUserInfoRowPhone) {
      if (![user compareUser: [OMBUser currentUser]]) {
        return 0.0f;
      }
    }
    // About
    else if (indexPath.row == OMBRenterProfileSectionUserInfoRowAbout) {
      CGFloat height = (padding * 0.5f) + [user heightForAboutTextWithWidth:
        [OMBRenterProfileUserInfoCell widthForLabel]] + padding;
      if (height < [OMBRenterProfileUserInfoCell heightForCell])
        height = [OMBRenterProfileUserInfoCell heightForCell];
      return height;
    }
    return [OMBRenterProfileUserInfoCell heightForCell];
  }
  else {
    if ([user isLandlord]) {
      // Listings
      if (indexPath.section == OMBRenterProfileSectionListings) {
        // My Listings
        if (indexPath.row == OMBRenterProfileSectionListingsRowInfoHeader) {
          return padding + OMBStandardHeight + padding;
        }
        // Create listings
        else if (indexPath.row == 
          OMBRenterProfileSectionListingsCreateListing) {
          if ([user isCurrentUser])
            return OMBStandardButtonHeight + padding; 
        }
        // Listings
        else {
          return [OMBManageListingsCell heightForCell];
        }
      }
    }
    else {
      // Renter info
      if (indexPath.section == OMBRenterProfileSectionRenterInfo) {
        // Rental Info Header
        if (indexPath.row == 
          OMBRenterProfileSectionRenterInfoRowPriorityRentalInfoHeader) {
          return padding + OMBStandardHeight + padding;
        }
        // Rental Info Note
        else if (indexPath.row ==
          OMBRenterProfileSectionRenterInfoRowPriorityRentalInfoNote) {
          if ([user isCurrentUser])
            return 22.0f * 3; // 22 is the line height for the label
          // return padding + (22.0f * 3) + padding;
        }
        // Become Renter Verified
        else if (indexPath.row == 
          OMBRenterProfileSectionRenterInfoRowBecomeRenterVerified) {
          if ([user isCurrentUser])
            return padding + OMBStandardButtonHeight + padding;
        }
        // Co-applicant count
        else if (indexPath.row ==
          OMBRenterProfileSectionRenterInfoRowCoapplicants) {
          return [OMBRenterProfileUserInfoCell heightForCell];
        }
        // Co-signer
        else if (indexPath.row == 
          OMBRenterProfileSectionRenterInfoRowCosigner) {
          return [OMBRenterProfileUserInfoCell heightForCell]; 
        }
        // Facebook
        else if (indexPath.row == 
          OMBRenterProfileSectionRenterInfoRowFacebook) {
          return [OMBRenterProfileUserInfoCell heightForCell]; 
        }
        // LinkedIn
        else if (indexPath.row == 
          OMBRenterProfileSectionRenterInfoRowLinkedIn) {
          return [OMBRenterProfileUserInfoCell heightForCell]; 
        }
      }
      // Employment
      else if (indexPath.section == OMBRenterProfileSectionEmployment) {
        return [OMBEmploymentCell heightForCell];
      }
    }
  }
  return 0.0f;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // If not the current user
  if (![user isCurrentUser]) {
    // User info
    if (indexPath.section == OMBRenterProfileSectionUserInfo) {
      // Email
      if (indexPath.row == OMBRenterProfileSectionUserInfoRowEmail) {
        [self emailUser];
      }
      // Phone
      else if (indexPath.row == OMBRenterProfileSectionUserInfoRowPhone) {
        [self phoneCallUser];
      }
    }
  }
  // Listings
  if (indexPath.section == OMBRenterProfileSectionListings) {
    // If not the first row
    if (indexPath.row != OMBRenterProfileSectionListingsRowInfoHeader) {
      [self.navigationController pushViewController:
        [[OMBResidenceDetailViewController alloc] initWithResidence:
          [[self listings] objectAtIndex: indexPath.row - 2]]
            animated: YES];
    }
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) contact
{
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem animated: YES];
  contactToolbar.hidden = NO;
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    CGRect rect = contactToolbar.frame;
    rect.origin.y = OMBPadding + OMBStandardHeight;
    contactToolbar.frame = rect;
  }];
}

- (void) createListing
{
  [[self appDelegate].container showCreateListing];
}

- (void) done
{
  [self.navigationItem setRightBarButtonItem: contactBarButtonItem 
    animated: YES];
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    CGRect rect = contactToolbar.frame;
    rect.origin.y = OMBPadding;
    contactToolbar.frame = rect;
  } completion: ^(BOOL finished) {
    if (finished)
      contactToolbar.hidden = YES;
  }];
}

- (void) edit
{
  [[self appDelegate].container presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController:
      editProfileViewController] animated: YES completion: nil];
}

- (void) emailUser
{
  if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *mailer = 
      [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    // Subject
    [mailer setSubject: @"Hello"];
    // Recipients
    NSArray *toRecipients = @[user.email];
    [mailer setToRecipients: toRecipients];
    // Body
    NSString *emailBody = @"";
    [mailer setMessageBody: emailBody isHTML: NO];
    [self presentViewController: mailer animated: YES completion: nil];
  }
}

- (NSArray *) listings
{
  // return [user residencesSortedWithKey: @"createdAt" ascending: NO];
  return [user residencesActive: YES sortedWithKey: @"createdAt" ascending: NO];
}

- (void) loadUser: (OMBUser *) object
{
  user = object;
  editProfileViewController = 
    [[OMBEditProfileViewController alloc] initWithUser: user];
  // If this is the current user's renter profile
  if (user.uid == [OMBUser currentUser].uid) {
    self.title = @"My Renter Profile";
  }
  else {
    self.title = [user.firstName capitalizedString];
  }
  [self reloadData];
}

- (void) phoneCallUser
{
  if ([user.phone length]) {
    NSString *string = [@"telprompt:" stringByAppendingString: user.phone];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: string]];
  }
}

- (void) reloadData
{
  // If this is the current user's renter profile
  if ([user compareUser: [OMBUser currentUser]]) {
    self.navigationItem.rightBarButtonItem = editBarButtonItem;
  }
  else {
    self.navigationItem.rightBarButtonItem = contactBarButtonItem;
    // If no phone number
    if (user.phone && [[user phoneString] length]) {
      phoneBarButtonItem.enabled = YES;
    }
    else {
      phoneBarButtonItem.enabled = NO;
    }
    // Email
    if ([user emailContactPermission])
      emailBarButtonItem.enabled = YES;
    else
      emailBarButtonItem.enabled = NO;
  }
  // Image
  backImageView.image = user.image;
  // User icon
  userIconView.image = user.image;
  // Full name
  if ([[user shortName] length])
    fullNameLabel.text = [user shortName];

  [self.table reloadData];
}

- (void) sendMessage
{
  if ([user isCurrentUser])
    return;
  [self.navigationController pushViewController:
    [[OMBMessageDetailViewController alloc] initWithUser: user] animated: YES];
}

- (void) showBecomeVerified
{
  OMBBecomeVerifiedViewController *vc = 
    [[OMBBecomeVerifiedViewController alloc] initWithUser: user];
  [[self appDelegate].container presentViewController:
    [[OMBNavigationController alloc] initWithRootViewController: vc]
      animated: YES completion: nil];
}

- (void) updateEditButton
{
  // Image
  // First name
  // Last name
  // School
  // Email
  // Phone
  // About
  NSInteger totalSteps = 7;
  // Image
  if (user.image && user.imageURL) {
    NSRegularExpression *regex =
      [NSRegularExpression regularExpressionWithPattern: @"default_user_image"
        options: 0 error: nil];
    NSArray *matches = [regex matchesInString: user.imageURL.absoluteString
      options: 0 range: NSMakeRange(0, [user.imageURL.absoluteString length])];
    if (![matches count])
      totalSteps -= 1;
  }
  // First name
  if (user.firstName && [user.firstName length])
    totalSteps -= 1;
  // Last name
  if (user.lastName && [user.lastName length])
    totalSteps -= 1;
  // School
  if (user.school && [user.school length])
    totalSteps -= 1;
  // Email
  if (user.email && [user.email length])
    totalSteps -= 1;
  // Phone
  if (user.phone && [user.phone length])
    totalSteps -= 1;
  // About
  if (user.about && [user.about length])
    totalSteps -= 1;

  if (totalSteps == 0) {
    editButtonView.hidden = YES;
    self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
  }
  else {
    editButtonView.hidden = NO;
    self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectMake(
      0.0f, 0.0f, self.table.frame.size.width, 
        editButtonView.frame.size.height)];
  }
}

@end
