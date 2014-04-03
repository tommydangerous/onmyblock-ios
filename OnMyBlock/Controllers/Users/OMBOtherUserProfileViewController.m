//
//  OMBOtherUserProfileViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOtherUserProfileViewController.h"

#import "NSString+Extensions.h"
#import "NSString+PhoneNumber.h"
#import "OMBCenteredImageView.h"
#import "OMBCosigner.h"
#import "OMBCosignerCell.h"
#import "OMBEmployment.h"
#import "OMBEmploymentCell.h"
#import "OMBGradientView.h"
#import "OMBManageListingsCell.h"
#import "OMBMessageDetailViewController.h"
#import "OMBMyRenterProfileViewController.h"
#import "OMBLegalAnswer.h"
#import "OMBLegalAnswerListConnection.h"
#import "OMBLegalQuestion.h"
#import "OMBLegalQuestionCell.h"
#import "OMBLegalQuestionStore.h"
#import "OMBOtherUserProfileCell.h"
#import "OMBOtherUserProfileHeaderCell.h"
#import "OMBPreviousRental.h"
#import "OMBPreviousRentalCell.h"
#import "OMBRenterApplication.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBRoommate.h"
#import "OMBRoommateCell.h"
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

  backViewImageArray = @[
    @"neighborhood_downtown.jpg",
    // @"neighborhood_hillcrest.jpg",
    @"neighborhood_la_jolla.jpg",
    @"neighborhood_mission_beach.jpg",
    @"neighborhood_mission_valley.jpg",
    @"neighborhood_ocean_beach.jpg",
    @"neighborhood_pacific_beach.jpg",
    @"neighborhood_university_towne_center.jpg",
  ];

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
  editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Edit"
    style: UIBarButtonItemStylePlain target: self action: @selector(edit)];
  UIFont *boldFont = [UIFont mediumTextFontBold];
  [editBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
      } forState: UIControlStateNormal];
  
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
    [UIColor colorWithWhite: 0.0f alpha: 0.8f]
  ];
  gradient.frame = CGRectMake(backImageView.frame.origin.x,
    backImageView.frame.origin.y, backImageView.frame.size.width,
      backImageView.frame.size.height * 1.5f);
  [scaleBackView addSubview: gradient];

  // Table header view
  CGFloat userIconSize = backImageView.frame.size.width * 0.3f;
  CGFloat userViewHeight = (userIconSize * 0.5f) + 33.0f + 27.0f + padding;
  userViewHeight = padding + 33.0f + 27.0f + padding;
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
  // [userView addSubview: userIconImageView];

  // User name label
  userNameLabel = [UILabel new];
  userNameLabel.font = [UIFont mediumLargeTextFontBold];
  // userNameLabel.frame = CGRectMake(0.0f, 
  //   userIconImageView.frame.origin.y + userIconImageView.frame.size.height, 
  //     userView.frame.size.width, 33.0f);
  userNameLabel.frame = CGRectMake(0.0f, padding, 
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
  CGFloat userCollectionViewHeight = (padding * 3) + 
    ([OMBOtherUserProfileCell heightForCell] * 2);
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
  }else{
    self.navigationItem.rightBarButtonItem = editBarButtonItem;
  }
  
  legalAnswers = [NSMutableDictionary dictionary];
  
  [self updateData];

  // Resize collection view
  CGFloat padding = OMBPadding;
  // Use the padding for inset top, bottom and spacing in between each row
  CGFloat userCollectionViewHeight = (padding * 3) +
    [OMBOtherUserProfileCell heightForCell] * 2;
  if ([user isLandlord]) {
    userCollectionViewHeight = (padding * 2) + 
      ([OMBOtherUserProfileCell heightForCell] * 1);
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
    
    // Fetch coapplicants
    [self fetchObjectsForResourceName:[OMBRoommate resourceName]];
    
    // Fetch cosigners
    [[self renterApplication] fetchCosignersForUserUID: user.uid
      delegate: self completion: ^(NSError *error) {
        [self updateData];
    }];
    
    // Fetch rental history
    [self fetchObjectsForResourceName:[OMBPreviousRental resourceName]];
    
    // Fetch work history
    [self fetchObjectsForResourceName:[OMBEmployment resourceName]];
    
    // Fetch legal questions
    [[OMBLegalQuestionStore sharedStore] fetchLegalQuestionsWithCompletion:
      ^(NSError *error) {
        OMBLegalAnswerListConnection *connection =
        [[OMBLegalAnswerListConnection alloc] initWithUser: user];
        connection.completionBlock = ^(NSError *error) {
          legalAnswers = [NSMutableDictionary dictionaryWithDictionary:
            user.renterApplication.legalAnswers];
          [self.table reloadData];
        };
        [connection start];
        [self.table reloadData];
     }
    ];
  }
}

#pragma mark - Protocol

#pragma mark - Protocol MFMailComposeViewControllerDelegate

- (void) mailComposeController: (MFMailComposeViewController*) controller 
didFinishWithResult: (MFMailComposeResult) result error: (NSError*) error
{
  [controller dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary forResourceName:(NSString *)resourceName
{
  if([resourceName isEqualToString:[OMBRoommate resourceName]]){
    [[self renterApplication] readFromDictionary: dictionary
      forModelName: [OMBRoommate modelName]];
    [self reloadTable];
  }
  if([resourceName isEqualToString:[OMBPreviousRental resourceName]]){
    [[self renterApplication] readFromDictionary: dictionary
      forModelName: [OMBPreviousRental modelName]];
    [self reloadTable];
  }
  if([resourceName isEqualToString:[OMBEmployment resourceName]]){
    [[self renterApplication] readFromDictionary: dictionary
      forModelName: [OMBEmployment modelName]];
    [self reloadTable];
  }
}

#pragma mark - Protocol UICollectionViewDataSource

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView 
cellForItemAtIndexPath: (NSIndexPath *) indexPath
{
  OMBOtherUserProfileCell *cell = 
    [collectionView dequeueReusableCellWithReuseIdentifier: 
      [OMBOtherUserProfileCell reuseIdentifier] forIndexPath: indexPath];

  NSInteger row = indexPath.row;

  /*if ([user isLandlord]) {
    if (row > 1) {
      row += 2;
    }
  }*/

  NSDictionary *dictionary = [userAttributes objectAtIndex: row];
  UIImage *image = [UIImage image: [UIImage imageNamed: 
    [dictionary objectForKey: @"imageName"]] size: cell.imageView.frame.size];
  cell.imageView.image = image;
  cell.label.text = [dictionary objectForKey: @"name"];
  cell.valueLabel.text = [dictionary objectForKey: @"value"];
  if (row == 2 && user.renterApplication.facebookAuthenticated)
    cell.imageView.alpha = 1.0f;
  else if (row == 3 && user.renterApplication.linkedinAuthenticated)
    cell.imageView.alpha = 1.0f;
  cell.clipsToBounds = YES;
  return cell;
}

- (NSInteger) collectionView: (UICollectionView *) collectionView 
numberOfItemsInSection: (NSInteger) section
{
  if ([user isLandlord])
    return 2;
  return 4;
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
  //return 4;
  if([user isLandlord])
    return 9;
  else
    return 8;
    
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
      cell.clipsToBounds = YES;
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
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  // Coapplicants
  else if (section == OMBOtherUserProfileSectionCoapplicants) {
    // Header
    if (row == OMBOtherUserProfileSectionCoapplicantsRowHeader) {
      static NSString *CoapplicantsHeaderID = @"CoapplicantsHeaderID";
      OMBOtherUserProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:
         CoapplicantsHeaderID];
      
      if (!cell) {
        cell = [[OMBOtherUserProfileHeaderCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: CoapplicantsHeaderID];
      }
      cell.iconView.image = [UIImage image:
        [UIImage imageNamed: @"group_icon.png"]
          size: cell.iconView.bounds.size];
      cell.headLabel.text = @"Co-Applicants";
      cell.clipsToBounds = YES;
      return cell;
    }
    else{
      static NSString *RoommateID = @"RoommateID";
      OMBRoommateCell *cell = [tableView dequeueReusableCellWithIdentifier:
        RoommateID];
      if (!cell)
        cell = [[OMBRoommateCell alloc] initWithStyle: UITableViewCellStyleDefault
          reuseIdentifier: RoommateID];
      [cell loadData: [[self objectsFromRoommates] objectAtIndex: row - 1]];
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  // Cosigners
  else if (section == OMBOtherUserProfileSectionCosigners) {
    if(row == OMBOtherUserProfileSectionCosignersRowHeader){
      static NSString *CosignerHeaderID = @"CosignerHeaderID";
      OMBOtherUserProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:
        CosignerHeaderID];
      
      if (!cell) {
        cell = [[OMBOtherUserProfileHeaderCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: CosignerHeaderID];
      }
      cell.iconView.image = [UIImage image:
        [UIImage imageNamed: @"landlord_icon.png"]
          size: cell.iconView.bounds.size];
      cell.headLabel.text = @"Co-Signer";
      cell.clipsToBounds = YES;
      return cell;
    }
    else{
      static NSString *CosignerID = @"CosignerID";
      OMBCosignerCell *cell = [tableView dequeueReusableCellWithIdentifier:
        CosignerID];
      if (!cell)
        cell = [[OMBCosignerCell alloc] initWithStyle: UITableViewCellStyleDefault
          reuseIdentifier: CosignerID];
      [cell loadData: [[self cosigners] objectAtIndex: row - 1]];
      cell.emailButton.tag = row - 1;
      [cell.emailButton addTarget:self
        action:@selector(emailCosigner:)
          forControlEvents:UIControlEventTouchUpInside];
      
      cell.phoneButton.tag = row - 1;
      [cell.phoneButton addTarget:self
        action:@selector(phoneCallCosigner:)
          forControlEvents:UIControlEventTouchUpInside];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  // Pets
  else if (section == OMBOtherUserProfileSectionPets) {
    // Header
    if (row == OMBOtherUserProfileSectionPetRowHeader) {
      static NSString *PetsHeaderID = @"PetsHeaderID";
      
      OMBOtherUserProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:
        PetsHeaderID];
      if (!cell) {
        cell = [[OMBOtherUserProfileHeaderCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: PetsHeaderID];
      }
      cell.headLabel.text = @"Pets";
      cell.iconView.image = [UIImage image:
        [UIImage imageNamed: @"dogs_icon.png"]
          size: cell.iconView.bounds.size];
      cell.clipsToBounds = YES;
      return cell;
    }
    else{
      static NSString *PetsID = @"PetsID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        PetsID];
      if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
          reuseIdentifier: PetsID];
      cell.accessoryType = UITableViewCellAccessoryNone;
      cell.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
        size: 15];
      cell.detailTextLabel.text = @"";
      cell.detailTextLabel.textColor = [UIColor grayMedium];
      cell.textLabel.font = [UIFont normalTextFont];
      cell.textLabel.textColor = [UIColor textColor];
      
      // NSString *string = @"";
      if (row == OMBOtherUserProfileSectionPetRowHeader + 1) {
        if ([self renterApplication].dogs)
          cell.textLabel.text = @"I do have a dog";
        else
          cell.textLabel.text = @"I do not have a dog";
      }
      else {
        if ([self renterApplication].cats)
          cell.textLabel.text = @"I do have a cat";
        else
          cell.textLabel.text = @"I do not have a cat";
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  // Previous Rental
  else if (section == OMBOtherUserProfileSectionPreviousRental) {
    // Header
    if (row == OMBOtherUserProfileSectionPreviousRentalRowHeader) {
      static NSString *PreviousRentalHeaderID = @"PreviousRentalHeaderID";
      OMBOtherUserProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:
        PreviousRentalHeaderID];
      
      if (!cell) {
        cell = [[OMBOtherUserProfileHeaderCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: PreviousRentalHeaderID];
      }
      cell.iconView.image = [UIImage image:
        [UIImage imageNamed: @"house_icon.png"]
          size: cell.iconView.bounds.size];
      cell.headLabel.text = @"Rental History";
      cell.clipsToBounds = YES;
      return cell;
    }
    else{
      static NSString *PreviousRentalID = @"PreviousRentalID";
      OMBPreviousRentalCell *cell = [tableView dequeueReusableCellWithIdentifier:
        PreviousRentalID];
      if (!cell)
        cell = [[OMBPreviousRentalCell alloc] initWithStyle: UITableViewCellStyleDefault
          reuseIdentifier: PreviousRentalID];
      [cell loadData2: [[self objectsFromPreviousRental] objectAtIndex: row - 1]];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  // Employment
  else if (section == OMBOtherUserProfileSectionEmployment) {
    // Header
    if (row == OMBOtherUserProfileSectionEmploymentRowHeader) {
      static NSString *EmploymentHeaderID = @"EmploymentHeaderID";
      OMBOtherUserProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:
        EmploymentHeaderID];
      
      if (!cell) {
        cell = [[OMBOtherUserProfileHeaderCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: EmploymentHeaderID];
      }
      cell.iconView.image = [UIImage image:
        [UIImage imageNamed: @"document_icon_black.png"]
          size: cell.iconView.bounds.size];
      cell.headLabel.text = @"Work & School History";
      cell.clipsToBounds = YES;
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
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  // Legal Questions
  else if (section == OMBOtherUserProfileSectionLegalQuestion) {
    // Header
    if (row == OMBOtherUserProfileSectionEmploymentRowHeader) {
      static NSString *LegalQuestionsHeaderID = @"LegalQuestionsHeaderID";
      OMBOtherUserProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:
         LegalQuestionsHeaderID];
      
      if (!cell) {
        cell = [[OMBOtherUserProfileHeaderCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: LegalQuestionsHeaderID];
      }
      cell.iconView.image = [UIImage image:
        [UIImage imageNamed: @"law_icon_black.png"]
          size: cell.iconView.bounds.size];
      cell.headLabel.text = @"Legal Questions";
      cell.clipsToBounds = YES;
      return cell;
    }
    else{
      static NSString *OMBLegalQuestionID = @"OMBLegalQuestionID";
      OMBLegalQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:
        OMBLegalQuestionID];
      if (!cell)
        cell = [[OMBLegalQuestionCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: OMBLegalQuestionID];
      
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      OMBLegalQuestion *legalQuestion = [[[OMBLegalQuestionStore sharedStore]
        questionsSortedByQuestion] objectAtIndex: row - 1];
      // Load the question
      [cell loadData: legalQuestion atIndexPathForOtherUser:
        [NSIndexPath indexPathForRow: row - 1  inSection:section]];
      // Load the answer
      OMBLegalAnswer *legalAnswer = [legalAnswers objectForKey:
        [NSNumber numberWithInt: legalQuestion.uid]];
      [cell loadLegalAnswerForOtherUser: legalAnswer];
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  // Listings
  else if (section == OMBOtherUserProfileSectionListings) {
    // Listings header
    if (row == OMBOtherUserProfileSectionListingsRowHeader) {
      static NSString *ListingsHeaderID = @"ListingsHeaderID";
      OMBOtherUserProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:
        ListingsHeaderID];
      
      if (!cell) {
        cell = [[OMBOtherUserProfileHeaderCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: ListingsHeaderID];
      }
      cell.iconView.image = [UIImage image:
        [UIImage imageNamed: @"house_icon.png"]
          size: cell.iconView.bounds.size];
      cell.headLabel.text = @"Listings";
      cell.clipsToBounds = YES;
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
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  emptyCell.clipsToBounds = YES;
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
  // Coapplicants
  else if (section == OMBOtherUserProfileSectionCoapplicants) {
    if([self objectsFromRoommates].count){
      return 1 + [self objectsFromRoommates].count;
    }
  }
  // Cosigners
  else if (section == OMBOtherUserProfileSectionCosigners) {
    if([[self renterApplication] cosignersSortedByFirstName].count){
      return 1 + [[[self renterApplication] cosignersSortedByFirstName] count];
    }
  }
  // Pets
  else if (section == OMBOtherUserProfileSectionPets) {
    if([self renterApplication].cats || [self renterApplication].dogs){
      return
        1 + (([self renterApplication].cats && [self renterApplication].dogs) ? 2 : 1);
    }
  }
  // Previous Rental
  else if (section == OMBOtherUserProfileSectionPreviousRental) {
    if([self objectsFromPreviousRental].count){
      return 1 + [self objectsFromPreviousRental].count;
    }
  }
  // Employment
  else if (section == OMBOtherUserProfileSectionEmployment) {
    if([self objectsFromEmployments].count){
      return 1 + [self objectsFromEmployments].count;
    }
  }
  // Legal Question
  else if (section == OMBOtherUserProfileSectionLegalQuestion) {
    return 1 + [[[OMBLegalQuestionStore sharedStore]
      questionsSortedByQuestion] count];
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
      return padding + height + padding;
    }
  }
  // Stats
  else if (section == OMBOtherUserProfileSectionStats) {
    // Collection view
    if (row == OMBOtherUserProfileSectionStatsRowCollectionView) {
      return userCollectionView.frame.size.height;
    }
  }
  // Coapplicants
  else if (section == OMBOtherUserProfileSectionCoapplicants) {
    if (![user isLandlord]) {
      if (row == OMBOtherUserProfileSectionCoapplicantsRowHeader)
        return [OMBOtherUserProfileHeaderCell heightForCell];
      else
        return [OMBRoommateCell heightForCell];
    }
  }
  // Cosigners
  else if (section == OMBOtherUserProfileSectionCosigners) {
    if (![user isLandlord]) {
      if (row == OMBOtherUserProfileSectionCosignersRowHeader)
        return [OMBOtherUserProfileHeaderCell heightForCell];
      else
        return [OMBCosignerCell heightForCell];
    }
  }
  // Pets
  else if (section == OMBOtherUserProfileSectionPets) {
    // if (![user isLandlord]) {
    //   if (row == OMBOtherUserProfileSectionPetRowHeader)
    //     return [OMBOtherUserProfileHeaderCell heightForCell];
    //   else
    //     return 58.0f;
    // }
    return 0.0f;
  }
  // Rental History
  else if (section == OMBOtherUserProfileSectionPreviousRental) {
    if (![user isLandlord]) {
      if (row == OMBOtherUserProfileSectionPreviousRentalRowHeader)
        return [OMBOtherUserProfileHeaderCell heightForCell];
      else{
        CGFloat adjusment = 0.0;
        OMBPreviousRental *previousRental =
          [[self objectsFromPreviousRental] objectAtIndex: row - 1];
        if([previousRental.landlordName length] > 0)
          adjusment += 22.0f;
        if([previousRental.landlordEmail length] > 0)
          adjusment += 22.0f;
        if([[previousRental.landlordPhone phoneNumberString] length] > 0)
          adjusment += 22.0f;
        
        if(adjusment > 0.0)
          adjusment += padding;
        return [OMBPreviousRentalCell heightForCell2] + adjusment;
      }
    }
  }
  // Employment
  else if (section == OMBOtherUserProfileSectionEmployment) {
    if (![user isLandlord]) {
      if (row == OMBOtherUserProfileSectionEmploymentRowHeader)
        return [OMBOtherUserProfileHeaderCell heightForCell];
      else
        return [OMBEmploymentCell heightForCell];
    }
  }
  // Legal Question
  else if (section == OMBOtherUserProfileSectionLegalQuestion) {
    if (![user isLandlord]) {
      if (row == OMBOtherUserProfileSectionLegalQuestionsRowHeader)
        return [OMBOtherUserProfileHeaderCell heightForCell];
      else{
        OMBLegalQuestion *legalQuestion = [[[OMBLegalQuestionStore sharedStore]
          questionsSortedByQuestion] objectAtIndex: row - 1];
        NSString *text = [NSString stringWithFormat: @"%i. %@",
          indexPath.row + 1, legalQuestion.question];
        CGRect rect = [text boundingRectWithSize:
          CGSizeMake([OMBLegalQuestionCell widthForQuestionLabel], 9999)
            options: NSStringDrawingUsesLineFragmentOrigin
              attributes: @{ NSFontAttributeName:
                [OMBLegalQuestionCell fontForQuestionLabelForOtherUser] }
                  context: nil];
        CGFloat padding = OMBPadding;
        // float height  = padding + rect.size.height + padding +
        // [OMBLegalQuestionCell buttonSize] + padding;
        CGFloat height = padding + rect.size.height + 
          (padding * 0.5) + 22.0f + padding;
        // If the answer is yes, show explain
        OMBLegalAnswer *legalAnswer = [legalAnswers objectForKey:
          [NSNumber numberWithInt: legalQuestion.uid]];
        if (legalAnswer && legalAnswer.answer && [legalAnswer.explanation stripWhiteSpace].length){
          height += [OMBLegalQuestionCell textViewHeight];
        }
        return height;
      }
    }
  }
  // Listings
  else if (section == OMBOtherUserProfileSectionListings) {
    if ([user isLandlord]) {
      if (row == OMBOtherUserProfileSectionListingsRowHeader)
        return [OMBOtherUserProfileHeaderCell heightForCell];
      else
        return [OMBManageListingsCell heightForCell];
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

  // Coapplicants
  if (section == OMBOtherUserProfileSectionCoapplicants){
    OMBUser *userRoommate =
      ((OMBRoommate *)[[self objectsFromRoommates]
        objectAtIndex: row - 1]).roommate;
    // If is an OMB user
    if(userRoommate){
      [self.navigationController pushViewController:
       [[OMBOtherUserProfileViewController alloc] initWithUser: userRoommate] animated:YES];
    }
  }
  
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

- (NSArray *) cosigners
{
  return [[self renterApplication] cosignersSortedByFirstName];
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
  [self.navigationController pushViewController:
    [[OMBMyRenterProfileViewController alloc] init] animated:YES];
}

- (void) email: (NSArray *)toRecipients
{
  if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *mailer =
    [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    // Subject
    [mailer setSubject: @"Hello"];
    // Recipients
    [mailer setToRecipients: toRecipients];
    // Body
    NSString *emailBody = @"";
    [mailer setMessageBody: emailBody isHTML: NO];
    if(mailer)
      [self presentViewController: mailer animated: YES completion: nil];
  }
}

- (void) emailUser
{
  [self email:@[user.email]];
}

- (void) emailCosigner:(id)sender
{
  OMBCosigner *cosigner = [[self cosigners]
    objectAtIndex:((UIButton *)sender).tag];
  [self email:@[cosigner.email]];
}

- (void) fetchObjectsForResourceName: (NSString *) resourceName
{
  [[self renterApplication] fetchListForResourceName: resourceName
    userUID: user.uid delegate: self completion: ^(NSError *error) {
      [self updateData];
  }];
}

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  [[self renterApplication] readFromCosignerDictionary: dictionary];
  [self reloadTable];
}

- (NSArray *) listings
{
  return [user residencesActive: YES sortedWithKey: @"createdAt" ascending: NO];
}

// Employments
- (NSArray *) objectsFromEmployments
{
  return [[self renterApplication] objectsWithModelName:
    [OMBEmployment modelName] sortedWithKey: @"startDate" ascending: NO];
}

// Previous rentals
- (NSArray *) objectsFromPreviousRental
{
  return [[self renterApplication] objectsWithModelName:
    [OMBPreviousRental modelName] sortedWithKey: @"moveInDate" ascending: NO];
}

// Roommates
- (NSArray *) objectsFromRoommates
{
  return [[self renterApplication] objectsWithModelName:
    [OMBRoommate modelName] sortedWithKey: @"firstName" ascending: YES];
}

- (void) phoneCall:(NSString *)phone
{
  if ([phone length]) {
    NSString *string = [@"telprompt:" stringByAppendingString: phone];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: string]];
  }
}

- (void) phoneCallCosigner:(id)sender
{
  OMBCosigner *cosigner =[[self cosigners]
    objectAtIndex:((UIButton *)sender).tag];
  [self phoneCall: cosigner.phone];
}

- (void) phoneCallUser
{
  [self phoneCall: user.phone];
}

- (OMBRenterApplication *) renterApplication
{
  return user.renterApplication;
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
  backImageView.image = user.image;
  // NSInteger index = user.uid % [backViewImageArray count];
  // backImageView.image = [UIImage imageNamed: 
  //   [backViewImageArray objectAtIndex: index]];
  // userIconImageView.image = user.image;
  // User name
  userNameLabel.text = [user fullName];
  // User scrool
  if ([user isLandlord]) {
    //userSchoolLabel.text = [user.landlordType capitalizedString];
    userSchoolLabel.text = @"Property Owner";
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
    /*@{
      @"imageName": @"group_icon.png",
      @"name":      @"Co-applicants",
      @"value": [NSString stringWithFormat: @"%i",
        user.renterApplication.coapplicantCount],
    },
    @{
      @"imageName": @"landlord_icon.png",
      @"name":      @"Co-signers",
      @"value": user.renterApplication.hasCosigner ? @"Yes" : @"No",
    },*/
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
