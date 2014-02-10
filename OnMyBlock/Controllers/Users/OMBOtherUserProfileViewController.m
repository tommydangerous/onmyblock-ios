//
//  OMBOtherUserProfileViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOtherUserProfileViewController.h"

#import "NSString+Extensions.h"
#import "OMBCenteredImageView.h"
#import "OMBEmploymentCell.h"
#import "OMBGradientView.h"
#import "OMBManageListingsCell.h"
#import "OMBMessageDetailViewController.h"
#import "OMBOtherUserProfileCell.h"
#import "OMBRenterApplication.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"
#import "UIImage+NegativeImage.h"
#import "UIImage+Resize.h"

@implementation OMBOtherUserProfileViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user = object;

  self.title = [user fullName];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setupForTable];

  contactBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Contact"
    style: UIBarButtonItemStylePlain target: self action: @selector(contact)];
  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
    style: UIBarButtonItemStylePlain target: self action: @selector(done)];

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight   = screen.size.height;
  CGFloat screenWidth    = screen.size.width;
  CGFloat padding        = OMBPadding;
  CGFloat standardHeight = OMBStandardHeight;

  self.view.backgroundColor  = [UIColor grayUltraLight];
  self.table.backgroundColor = [UIColor clearColor];

  // Back view
  backViewOriginY = padding + standardHeight;
  backView = [UIView new];
  backView.frame = CGRectMake(0.0f, backViewOriginY, 
    screenWidth, screenHeight * 0.4f);
  [self.view insertSubview: backView belowSubview: self.table];
  // Scale back view
  scaleBackView = [UIView new];
  scaleBackView.frame = backView.bounds;
  [backView addSubview: scaleBackView];
  // Back image view
  backImageView = [[OMBCenteredImageView alloc] init];
  backImageView.clipsToBounds = NO;
  backImageView.frame = scaleBackView.bounds;
  [scaleBackView addSubview: backImageView];
  // Gradient
  gradient = [[OMBGradientView alloc] init];
  gradient.colors = @[
    [UIColor colorWithWhite: 0.0f alpha: 0.0f],
    [UIColor colorWithWhite: 0.0f alpha: 0.3f]
  ];
  gradient.frame = backImageView.bounds;
  [scaleBackView addSubview: gradient];

  // Table header view
  CGFloat userIconSize = backImageView.frame.size.width * 0.3f;
  CGFloat userViewHeight = (userIconSize * 0.5f) + 33.0f + 27.0f + padding;
  UIView *tableHeaderView = [UIView new];
  // tableHeaderView.backgroundColor = [UIColor blueAlpha: 0.5f];
  tableHeaderView.frame = CGRectMake(0.0f, 0.0f, screenWidth, 
    backViewOriginY + backView.frame.size.height + userViewHeight);
  self.table.tableHeaderView = tableHeaderView;

  // User view
  UIView *userView = [UIView new];
  userView.backgroundColor = [UIColor whiteColor];
  userView.frame = CGRectMake(0.0f, 
    tableHeaderView.frame.size.height - userViewHeight, screenWidth,  
      userViewHeight);
  [tableHeaderView addSubview: userView];

  // User icon image
  userIconImageView = [[OMBCenteredImageView alloc] init];
  userIconImageView.backgroundColor = [UIColor whiteColor];
  userIconImageView.frame = CGRectMake(
    (tableHeaderView.frame.size.width - userIconSize) * 0.5f, 
      -1 * (userIconSize * 0.5f), userIconSize, userIconSize);
  userIconImageView.layer.cornerRadius = 
    userIconImageView.frame.size.height * 0.5f;
  [userView addSubview: userIconImageView];

  // User name label
  userNameLabel = [UILabel new];
  userNameLabel.font = [UIFont mediumLargeTextFontBold];
  userNameLabel.frame = CGRectMake(0.0f, 
    userIconImageView.frame.origin.y + userIconImageView.frame.size.height, 
      userView.frame.size.width, 33.0f);
  userNameLabel.textAlignment = NSTextAlignmentCenter;
  userNameLabel.textColor = [UIColor textColor];
  [userView addSubview: userNameLabel];

  // User school label
  userSchoolLabel = [UILabel new];
  userSchoolLabel.font = [UIFont normalTextFont];
  userSchoolLabel.frame = CGRectMake(userNameLabel.frame.origin.x,
    userNameLabel.frame.origin.y + userNameLabel.frame.size.height, 
      userNameLabel.frame.size.width, 27.0f);
  userSchoolLabel.textAlignment = userNameLabel.textAlignment;
  userSchoolLabel.textColor = [UIColor grayMedium];
  [userView addSubview: userSchoolLabel];

  // Layout
  UICollectionViewFlowLayout *layout = 
    [[UICollectionViewFlowLayout alloc] init];

  // Collection view
  CGFloat userCollectionViewHeight = (padding * 4) + 
    ([OMBOtherUserProfileCell heightForCell] * 3);
  userCollectionView = [[UICollectionView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, screenWidth, userCollectionViewHeight) 
      collectionViewLayout: layout];
  userCollectionView.backgroundColor = [UIColor whiteColor];
  userCollectionView.dataSource = self;
  userCollectionView.delegate   = self;

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

- (void) viewDidLoad
{
  [super viewDidLoad];

  [userCollectionView registerClass: [OMBOtherUserProfileCell class]
    forCellWithReuseIdentifier: [OMBOtherUserProfileCell reuseIdentifier]];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  if (![user isCurrentUser]) {
    self.navigationItem.rightBarButtonItem = contactBarButtonItem;
  }

  [self updateData];

  // Resize collection view
  CGFloat padding = OMBPadding;
  CGFloat userCollectionViewHeight = (padding * 4) + 
    ([OMBOtherUserProfileCell heightForCell] * 3);
  if ([user isLandlord]) {
    userCollectionViewHeight = (padding * 3) + 
      ([OMBOtherUserProfileCell heightForCell] * 2);
  }
  CGRect collectionViewRect = userCollectionView.frame;
  collectionViewRect.size.height = userCollectionViewHeight;
  userCollectionView.frame = collectionViewRect;

  // If user is the landlord
  if ([user isLandlord]) {
    // Fetch listings
    [user fetchListingsWithCompletion: ^(NSError *error) {
      [self updateData];
    }];
  }
  else {
    // Fetch the information about the user, specifically the renter application
    [user fetchUserProfileWithCompletion: ^(NSError *error) {
      [self updateData];
    }];
    // Fetch the employments
    [user fetchEmploymentsWithCompletion: ^(NSError *error) {
      [self updateData];
    }];
  }
}

#pragma mark - Protocol

#pragma mark - Protocol MFMailComposeViewControllerDelegate

- (void) mailComposeController: (MFMailComposeViewController*) controller 
didFinishWithResult: (MFMailComposeResult) result error: (NSError*) error
{
  [controller dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Protocol UICollectionViewDataSource

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView 
cellForItemAtIndexPath: (NSIndexPath *) indexPath
{
  OMBOtherUserProfileCell *cell = 
    [collectionView dequeueReusableCellWithReuseIdentifier: 
      [OMBOtherUserProfileCell reuseIdentifier] forIndexPath: indexPath];

  NSInteger row = indexPath.row;

  if ([user isLandlord]) {
    if (row > 1) {
      row += 2;
    }
  }

  NSDictionary *dictionary = [userAttributes objectAtIndex: row];
  UIImage *image = [UIImage image: [UIImage imageNamed: 
    [dictionary objectForKey: @"imageName"]] size: cell.imageView.frame.size];
  cell.imageView.image = image;
  cell.label.text = [dictionary objectForKey: @"name"];
  cell.valueLabel.text = [dictionary objectForKey: @"value"];
  if (row == 4 && user.renterApplication.facebookAuthenticated)
    cell.imageView.alpha = 1.0f;
  else if (row == 5 && user.renterApplication.linkedinAuthenticated)
    cell.imageView.alpha = 1.0f;

  return cell;
}

- (NSInteger) collectionView: (UICollectionView *) collectionView 
numberOfItemsInSection: (NSInteger) section
{
  if ([user isLandlord])
    return 4;
  return 6;
}

- (NSInteger) numberOfSectionsInCollectionView: 
(UICollectionView *) collectionView
{
  return 1;
}

#pragma mark - Protocol UICollectionViewDelegateFlowLayout

- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
insetForSectionAtIndex: (NSInteger) section
{
  return UIEdgeInsetsMake(OMBPadding, OMBPadding, OMBPadding, OMBPadding);
}

- (CGFloat) collectionView: (UICollectionView *) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
minimumInteritemSpacingForSectionAtIndex: (NSInteger) section
{
  return OMBPadding;
}

- (CGFloat) collectionView: (UICollectionView *) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
minimumLineSpacingForSectionAtIndex: (NSInteger) section
{
  return OMBPadding;
}

- (CGSize) collectionView: (UICollectionView * ) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
sizeForItemAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat width = (collectionView.frame.size.width - (OMBPadding * 3)) * 0.5f;
  return CGSizeMake(width, [OMBOtherUserProfileCell heightForCell]);
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

  // Scale
  // Back image view
  CGFloat newScale = 1 + ((y * -3) / scaleBackView.frame.size.height);
  if (newScale < 1)
    newScale = 1;
  scaleBackView.transform = CGAffineTransformScale(
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
  // About
  // Stats
  // Employment
  // Listings
  return 4;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;

  CGFloat padding = OMBPadding;
  CGFloat width   = tableView.frame.size.width;

  UIEdgeInsets maxInsets = UIEdgeInsetsMake(0.0f, width, 0.0f, 0.0f);

  static NSString *EmptyCellID = @"EmptyCellID";
  UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:
    EmptyCellID];
  if (!emptyCell)
    emptyCell = [[UITableViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: EmptyCellID];
  // About
  if (section == OMBOtherUserProfileSectionAbout) {
    // About
    if (row == OMBOtherUserProfileSectionAboutRowAbout) {
      static NSString *AboutID = @"AboutID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        AboutID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: AboutID];
        UILabel *label = [UILabel new];
        NSString *text = @"Nothing about me yet.";
        if (user.about && [user.about length])
          text = user.about;
        label.attributedText = [text attributedStringWithFont:
          [UIFont normalTextFont] lineHeight: 22.0f];
        CGFloat height = 
          [user heightForAboutTextWithWidth: width - (padding * 2)];
        if (height < 22.0f)
          height = 22.0f;
        label.frame = CGRectMake(padding, padding, width - (padding * 2), 
          height);
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor textColor];
        [cell.contentView addSubview: label];
      }
      cell.backgroundColor = [UIColor grayUltraLight];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.separatorInset  = maxInsets;
      return cell;
    }
  }
  // Stats
  else if (section == OMBOtherUserProfileSectionStats) {
    // Collection view
    if (row == OMBOtherUserProfileSectionStatsRowCollectionView) {
      static NSString *AboutID = @"AboutID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        AboutID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: AboutID];
        [cell.contentView addSubview: userCollectionView];
      }
      cell.backgroundColor = [UIColor grayUltraLight];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.separatorInset  = maxInsets;
      return cell;
    }
  }
  // Employment
  else if (section == OMBOtherUserProfileSectionEmployment) {
    // Header
    if (row == OMBOtherUserProfileSectionEmploymentRowHeader) {
      static NSString *EmploymentHeaderID = @"EmploymentHeaderID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        EmploymentHeaderID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: EmploymentHeaderID];
        
        CGFloat labelHeight = OMBStandardHeight;
        // Image
        CGFloat imageSize = labelHeight * 0.5f;
        UIImageView *imageView = [UIImageView new];
        imageView.alpha = 0.3f;
        imageView.frame = CGRectMake(padding, 
          padding + ((labelHeight - imageSize) * 0.5f), imageSize, imageSize);
        imageView.image = [UIImage image: 
          [UIImage imageNamed: @"document_icon_black.png"] 
            size: imageView.bounds.size];
        [cell.contentView addSubview: imageView];

        // Label
        CGFloat originX = imageView.frame.origin.x + 
          imageView.frame.size.width + (padding * 0.5f);
        UILabel *headLabel = [UILabel new];
        headLabel.font = [UIFont mediumTextFont];
        headLabel.frame = CGRectMake(originX, padding, 
          width - (originX + (padding * 0.5f)), labelHeight);
        headLabel.text = @"Experience";
        headLabel.textColor = [UIColor grayMedium];
        [cell.contentView addSubview: headLabel];
      }
      cell.backgroundColor = [UIColor grayUltraLight];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.separatorInset = UIEdgeInsetsMake(0.0f, 
        tableView.frame.size.width, 0.0f, 0.0f);
      return cell;
    }
    else {
      static NSString *EmploymentCellID = @"EmploymentCellID";
      OMBEmploymentCell *cell = [tableView dequeueReusableCellWithIdentifier:
        EmploymentCellID];
      if (!cell)
        cell = [[OMBEmploymentCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: EmploymentCellID];
      [cell loadData: 
        [[user.renterApplication employmentsSortedByStartDate] 
          objectAtIndex: row - 1]];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      return cell;
    }
  }
  // Listings
  else if (section == OMBOtherUserProfileSectionListings) {
    // Listings header
    if (row == OMBOtherUserProfileSectionListingsRowHeader) {
      static NSString *ListingsHeaderID = @"ListingsHeaderID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        ListingsHeaderID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: ListingsHeaderID];
        
        CGFloat labelHeight = OMBStandardHeight;
        // Image
        CGFloat imageSize = labelHeight * 0.5f;
        UIImageView *imageView = [UIImageView new];
        imageView.alpha = 0.3f;
        imageView.frame = CGRectMake(padding, 
          padding + ((labelHeight - imageSize) * 0.5f), imageSize, imageSize);
        imageView.image = [UIImage image: 
          [UIImage imageNamed: @"house_icon.png"] 
            size: imageView.bounds.size];
        [cell.contentView addSubview: imageView];

        // Label
        CGFloat originX = imageView.frame.origin.x + 
          imageView.frame.size.width + (padding * 0.5f);
        UILabel *headLabel = [UILabel new];
        headLabel.font = [UIFont mediumTextFont];
        headLabel.frame = CGRectMake(originX, padding, 
          width - (originX + (padding * 0.5f)), labelHeight);
        headLabel.text = @"Listings";
        headLabel.textColor = [UIColor grayMedium];
        [cell.contentView addSubview: headLabel];
      }
      cell.backgroundColor = [UIColor grayUltraLight];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.separatorInset = UIEdgeInsetsMake(0.0f, 
        tableView.frame.size.width, 0.0f, 0.0f);
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
        indexPath.row - 1]];
      cell.separatorInset = UIEdgeInsetsZero;
      cell.statusLabel.hidden = YES;
      return cell;
    }
  }
  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // About
  if (section == OMBOtherUserProfileSectionAbout) {
    // About
    return 1;
  }
  // Stats
  else if (section == OMBOtherUserProfileSectionStats) {
    return 1;
  }
  // Employment
  else if (section == OMBOtherUserProfileSectionEmployment) {
    if ([user.renterApplication.employments count]) {
      return 1 + [[user.renterApplication employmentsSortedByStartDate] count];
    }
  }
  // Listings
  else if (section == OMBOtherUserProfileSectionListings) {
    // If the user has listings
    if ([[self listings] count]) {
      // Listings header, create listing, listings
      return 1 + [[self listings] count];
    }
  }
  return 0;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;

  CGFloat padding = OMBPadding;
  CGFloat width   = tableView.frame.size.width;
  
  // About
  if (section == OMBOtherUserProfileSectionAbout) {
    // About
    if (row == OMBOtherUserProfileSectionAboutRowAbout) {
      CGFloat height = 
        [user heightForAboutTextWithWidth: width - (padding * 2)];
      if (height < 22.0f)
        height = 22.0f;
      return padding + height + padding + OMBStandardHeight;
    }
  }
  // Stats
  else if (section == OMBOtherUserProfileSectionStats) {
    // Collection view
    if (row == OMBOtherUserProfileSectionStatsRowCollectionView) {
      return userCollectionView.frame.size.height + OMBStandardHeight;
    }
  }
  // Employment
  else if (section == OMBOtherUserProfileSectionEmployment) {
    if (![user isLandlord]) {
      if (row == OMBOtherUserProfileSectionEmploymentRowHeader) {
        return padding + OMBStandardHeight + padding;
      }
      else {
        return [OMBEmploymentCell heightForCell];
      }
    }
  }
  // Listings
  else if (section == OMBOtherUserProfileSectionListings) {
    if ([user isLandlord]) {
      // Header
      if (row == OMBOtherUserProfileSectionListingsRowHeader) {
        return padding + OMBStandardHeight + padding;
      }
      // Listings
      else {
        return [OMBManageListingsCell heightForCell];
      }
    }
  }
  return 0.0f;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;

  // Listings
  if (section == OMBOtherUserProfileSectionListings) {
    if (row > OMBOtherUserProfileSectionListingsRowHeader) {
      [self.navigationController pushViewController:
        [[OMBResidenceDetailViewController alloc] initWithResidence:
          [[self listings] objectAtIndex: indexPath.row - 1]]
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
  return [user residencesActive: YES sortedWithKey: @"createdAt" ascending: NO];
}

- (void) phoneCallUser
{
  if ([user.phone length]) {
    NSString *string = [@"telprompt:" stringByAppendingString: user.phone];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: string]];
  }
}

- (void) sendMessage
{
  if ([user isCurrentUser])
    return;
  [self.navigationController pushViewController:
    [[OMBMessageDetailViewController alloc] initWithUser: user] animated: YES];
}

- (void) updateData
{
  // If this is the current user's renter profile
  if ([user compareUser: [OMBUser currentUser]]) {
    // self.navigationItem.rightBarButtonItem = editBarButtonItem;
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

  // User images
  backImageView.image     = user.image;
  userIconImageView.image = user.image;
  // User name
  userNameLabel.text = [user fullName];
  // User scrool
  if ([user isLandlord]) {
    userSchoolLabel.text = [user.landlordType capitalizedString];
  }
  else {
    if (user.school && [user.school length])
      userSchoolLabel.text = user.school;
    else
      userSchoolLabel.text = @"No school specified";
  }

  userAttributes = @[
    @{
      @"imageName": @"phone_icon.png",
      @"name":      @"Phone",
      @"value": [user.phone length] ? @"Verified" : @"Not verified",
    },
    @{
      @"imageName": @"messages_icon_dark.png",
      @"name":      @"Email",
      @"value": [user.email length] ? @"Verified" : @"Not verified",
    },
    @{
      @"imageName": @"group_icon.png",
      @"name":      @"Co-applicants",
      @"value": [NSString stringWithFormat: @"%i",
        user.renterApplication.coapplicantCount],
    },
    @{
      @"imageName": @"landlord_icon.png",
      @"name":      @"Co-signers",
      @"value": user.renterApplication.hasCosigner ? @"Yes" : @"No",
    },
    @{
      @"imageName": @"facebook_icon_blue.png",
      @"name":      @"Facebook",
      @"value": user.renterApplication.facebookAuthenticated ? 
        @"Verified" : @"Not verified",
    },
    @{
      @"imageName": @"linkedin_icon.png",
      @"name": @"LinkedIn",
      @"value": user.renterApplication.linkedinAuthenticated ? 
        @"Verified" : @"Not verified",
    },
  ];

  [self.table reloadData];
}

@end
