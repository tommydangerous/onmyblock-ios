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
#import "OMBGradientView.h"
#import "OMBNavigationController.h"
#import "OMBRenterApplication.h"
#import "OMBRenterProfileUserInfoCell.h"
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
  self.title      = @"Renter Profile";

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

  editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Edit"
    style: UIBarButtonItemStylePlain target: self action: @selector(edit)];
  self.navigationItem.rightBarButtonItem = editBarButtonItem;

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
  [editButton addTarget: self action: @selector(edit)
    forControlEvents: UIControlEventTouchUpInside];
  [editButton setBackgroundImage: [UIImage imageWithColor: 
    [UIColor blueHighlighted]] forState: UIControlStateHighlighted];
  [editButton setTitle: @"Complete Renter Profile"
    forState: UIControlStateNormal];
  [editButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [editButtonView addSubview: editButton];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // If the current user is looking at their own renter profile
  if (user.uid == [OMBUser currentUser].uid) {
    // Check to see if the edit button should be at the bottom
    [self updateEditButton];
  }

  // We only want to show the menu icon if its the root view controller
  if ([self.navigationController.viewControllers count] == 1) {
    [self setMenuBarButtonItem];
  }

  [self reloadData];

  // [self showBecomeVerified];
}

#pragma mark - Protocol

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

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return 2;
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
    // School
    if (indexPath.row == OMBRenterProfileSectionUserInfoRowSchool) {
      cell.iconImageView.image = [UIImage image: 
        [UIImage imageNamed: @"school_icon.png"] size: imageSize];
      cell.label.text = user.school;
    }
    // Email
    else if (indexPath.row == OMBRenterProfileSectionUserInfoRowEmail) {
      cell.iconImageView.image = [UIImage image: 
        [UIImage imageNamed: @"messages_icon_dark.png"] size: imageSize];
      cell.label.text = [user.email lowercaseString];
    }
    // Phone
    else if (indexPath.row == OMBRenterProfileSectionUserInfoRowPhone) {
      cell.iconImageView.image = [UIImage image: 
        [UIImage imageNamed: @"phone_icon.png"] size: imageSize];
      cell.label.text = [user phoneString];
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
        headLabel.text = @"Priority Rental Info";
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
        label1.text = @"Including this information in your";
        label2.text = @"Renter Profile will give you a way better";
        label3.text = @"chance at nabbing the best place.";
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
        cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
          0.0f, 0.0f);
      }
      cell.iconImageView.image = [UIImage image: image size: imageSize];
      cell.label.text = string;
      cell.valueLabel.text = valueString;
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
    // School
    // Email
    // Phone
    // About
    return 4;
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
  return 0;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat padding = OMBPadding;
  // User info
  if (indexPath.section == OMBRenterProfileSectionUserInfo) {
    // About
    if (indexPath.row == OMBRenterProfileSectionUserInfoRowAbout) {
      CGFloat height = (padding * 0.5f) + [user heightForAboutTextWithWidth:
        [OMBRenterProfileUserInfoCell widthForLabel]] + padding;
      if (height < [OMBRenterProfileUserInfoCell heightForCell])
        height = [OMBRenterProfileUserInfoCell heightForCell];
      return height;
    }
    return [OMBRenterProfileUserInfoCell heightForCell];
  }
  // Renter info
  else if (indexPath.section == OMBRenterProfileSectionRenterInfo) {
    // Rental Info Header
    if (indexPath.row == 
      OMBRenterProfileSectionRenterInfoRowPriorityRentalInfoHeader) {
      return padding + OMBStandardHeight + padding;
    }
    // Rental Info Note
    else if (indexPath.row ==
      OMBRenterProfileSectionRenterInfoRowPriorityRentalInfoNote) {
      return 22.0f * 3; // 22 is the line height for the label
      // return padding + (22.0f * 3) + padding;
    }
    // Become Renter Verified
    else if (indexPath.row == 
      OMBRenterProfileSectionRenterInfoRowBecomeRenterVerified) {
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
  return 0.0f;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{

}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) edit
{
  [[self appDelegate].container presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController:
      editProfileViewController] animated: YES completion: nil];
}

- (void) loadUser: (OMBUser *) object
{
  user = object;
  editProfileViewController = 
    [[OMBEditProfileViewController alloc] initWithUser: user];
  [self reloadData];
}

- (void) reloadData
{
  // Image
  backImageView.image = user.image;
  // User icon
  userIconView.image = user.image;
  // Full name
  fullNameLabel.text = [user fullName];
  [self.table reloadData];
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
