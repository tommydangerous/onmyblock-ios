//
//  OMBMyRenterProfileViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMyRenterProfileViewController.h"

#import "CustomLoading.h"
#import "NSString+OnMyBlock.h"
#import "LIALinkedInApplication.h"
#import "LIALinkedInHttpClient.h"
#import "OMBBecomeVerifiedViewController.h"
#import "OMBCenteredImageView.h"
#import "OMBEmploymentCell.h"
#import "OMBGradientView.h"
#import "OMBImageTwoTextFieldCell.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBLegalViewController.h"
#import "OMBManageListingsCell.h"
#import "OMBManageListingsConnection.h"
#import "OMBUserDetailViewController.h"
#import "OMBPickerViewCell.h"
#import "OMBRenterApplication.h"
#import "OMBRenterInfoSectionCosignersViewController.h"
#import "OMBRenterInfoSectionEmploymentViewController.h"
#import "OMBRenterInfoSectionPreviousRentalViewController.h"
#import "OMBRenterInfoSectionRoommateViewController.h"
#import "OMBRenterInfoSectionViewController.h"
#import "OMBRenterProfileUserInfoCell.h"
#import "OMBTwoLabelTextFieldCell.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Resize.h"

// Categories
#import "UIImageView+WebCache.h"

@implementation OMBMyRenterProfileViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.title = @"My Renter Profile";

  CGRect rect = [@"First name" boundingRectWithSize:
    CGSizeMake(9999, OMBStandardHeight) font: [UIFont normalTextFontBold]];
  sizeForLabelTextFieldCell = rect.size;

  [[NSNotificationCenter defaultCenter] addObserver:self
    selector: @selector(progressConnection:)
      name: @"progressConnection" object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [[CustomLoading getInstance] clearInstance];

  previewBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Preview"
      style: UIBarButtonItemStylePlain target: self action: @selector(preview)];
  self.navigationItem.rightBarButtonItem = previewBarButtonItem;

  CGRect screen        = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = OMBPadding;

  [super setupForTable];
  self.view.backgroundColor = [UIColor clearColor];
  self.table.backgroundColor = [UIColor clearColor];

  // Back view
  backViewOriginY = padding + OMBStandardHeight;
  backView = [UIView new];
  backView.frame = CGRectMake(0.0f, backViewOriginY,
    screenWidth, screenHeight * 0.4f);
  //[self.view insertSubview: backView belowSubview: self.table];
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

  // Name view
  CGFloat nameViewHeight = OMBStandardButtonHeight;
  nameViewHeight = OMBStandardHeight;
  nameViewOriginY = (backView.frame.origin.y + backView.frame.size.height) -
    (nameViewHeight + padding);
  nameView = [UIView new];
  // nameView.backgroundColor = [UIColor redColor];
  nameView.frame = CGRectMake(0.0f, nameViewOriginY,
    screenWidth, nameViewHeight);
  //[self.view insertSubview: nameView belowSubview: self.table];
  // User icon
  userIconView = [[OMBCenteredImageView alloc] init];
  // userIconView.frame = CGRectMake(padding, 0.0f,
  //   nameViewHeight, nameViewHeight);
  userIconView.frame = CGRectZero;
  userIconView.layer.cornerRadius = userIconView.frame.size.width * 0.5f;
  [nameView addSubview: userIconView];
  // Full name label
  fullNameLabel = [UILabel new];
  fullNameLabel.font = [UIFont largeTextFont];
  // fullNameLabel.frame = CGRectMake(
  //   userIconView.frame.origin.x + userIconView.frame.size.width + padding,
  //     0.0f, nameView.frame.size.width - (userIconView.frame.origin.x +
  //     userIconView.frame.size.width + padding + padding), nameViewHeight);
  fullNameLabel.frame = CGRectMake(padding, 0.0f,
    nameView.frame.size.width - (padding * 2), nameView.frame.size.height);
  fullNameLabel.textColor = [UIColor whiteColor];
  [nameView addSubview: fullNameLabel];

  CGFloat cameraSize = 26.0f;
  UIImageView *cameraImageView = [UIImageView new];
  cameraImageView.frame = CGRectMake(
    screenWidth - (cameraSize + padding),
      (nameView.frame.size.height - cameraSize) * 0.5f,
        cameraSize, cameraSize);
  cameraImageView.image = [UIImage image:
    [UIImage imageNamed: @"camera_icon.png"] size: cameraImageView.bounds.size];
  //[nameView addSubview: cameraImageView];

  // Table header view
  UIView *tableHeaderView = [UIView new];
  tableHeaderView.backgroundColor = [UIColor clearColor];
  tableHeaderView.frame = CGRectMake(0.0f, 0.0f, screenWidth,
    backViewOriginY + backView.frame.size.height);
  //self.table.tableHeaderView = tableHeaderView;

  /*UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget: self
      action: @selector(showUploadActionSheet)];
  [tableHeaderView addGestureRecognizer: tapGesture];*/

  // About text view
  aboutTextView = [UITextView new];
  aboutTextView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
  aboutTextView.delegate = self;
  aboutTextView.font = [UIFont normalTextFont];
  aboutTextView.frame = CGRectMake(padding, padding,
    screenWidth - (padding * 2), padding * 5); // 5 times the line height
  aboutTextView.textColor = [UIColor blueDark];

  // About text view placeholder
  aboutTextViewPlaceholder = [UILabel new];
  aboutTextViewPlaceholder.font = aboutTextView.font;
  aboutTextViewPlaceholder.frame = CGRectMake(5.0f, 8.0f,
    aboutTextView.frame.size.width, 20.0f);
  aboutTextViewPlaceholder.text = @"Share a little about you…";
  aboutTextViewPlaceholder.textColor = [UIColor grayMedium];
  [aboutTextView addSubview: aboutTextViewPlaceholder];

  // Spacing
  UIBarButtonItem *flexibleSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemFlexibleSpace target: nil action: nil];

	// Left padding
	UIBarButtonItem *leftPadding =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
	 UIBarButtonSystemItemFixedSpace target: nil action: nil];
	// iOS 7 toolbar spacing is 16px; 20px on iPad
	leftPadding.width = 4.0f;

	// Cancel
	UIBarButtonItem *cancelBarButtonItemForTextFieldToolbar =
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
									 style: UIBarButtonItemStylePlain target: self
									action: @selector(cancelFromInputAccessoryView)];

	// Done
  UIBarButtonItem *doneBarButtonItemForTextFieldToolbar =
    [[UIBarButtonItem alloc] initWithTitle: @"Done"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(saveFromInputAccessoryView)];

	// Right padding
  UIBarButtonItem *rightPadding =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemFixedSpace target: nil action: nil];
  // iOS 7 toolbar spacing is 16px; 20px on iPad
  rightPadding.width = 4.0f;

  textFieldToolbar = [UIToolbar new];
  textFieldToolbar.clipsToBounds = YES;
  textFieldToolbar.frame = CGRectMake(0.0f, 0.0f,
    screenWidth, OMBStandardHeight);
  textFieldToolbar.items = @[
    leftPadding,
    cancelBarButtonItemForTextFieldToolbar,
    flexibleSpace,
    doneBarButtonItemForTextFieldToolbar,
    rightPadding
  ];
  textFieldToolbar.tintColor = [UIColor blueDark];
  aboutTextView.inputAccessoryView = textFieldToolbar;
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  if (!user)
    user = [OMBUser currentUser];

  valueDictionary = [NSMutableDictionary dictionaryWithDictionary: @{
    @"about":     user.about ? user.about : @"",
    @"email":     user.email ? user.email : @"",
    @"firstName": user.firstName ? user.firstName: @"",
    @"lastName":  user.lastName ? user.lastName : @"",
    @"phone":     user.phone ? user.phone : @"",
    @"school":    user.school ? user.school : @""
  }];
  
  // If user is a subletter
  if ([user.landlordType isEqualToString: @"subletter"]) {
    OMBManageListingsConnection *conn =
      [[OMBManageListingsConnection alloc] init];
    conn.completionBlock = ^(NSError *error) {
      [self.table reloadData];
    };
    [conn start];
  }
  
  [self updateData];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];
  [self done];
  [self save];
}

#pragma mark - Protocol

#pragma mark - Protocol UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  // Image picker controller
  UIImagePickerController *imagePickerController =
    [[UIImagePickerController alloc] init];
  imagePickerController.allowsEditing = YES;
  imagePickerController.delegate = self;
  if (buttonIndex == 0) {
    if ([UIImagePickerController isSourceTypeAvailable:
      UIImagePickerControllerSourceTypeCamera]) {

      imagePickerController.sourceType =
        UIImagePickerControllerSourceTypeCamera;
      imagePickerController.cameraDevice =
        UIImagePickerControllerCameraDeviceFront;
    }
    else {
      imagePickerController.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
    }
  }
  else if (buttonIndex == 1) {
    imagePickerController.sourceType =
      UIImagePickerControllerSourceTypePhotoLibrary;
  }
  if (buttonIndex == 0 || buttonIndex == 1) {
    [self presentViewController: imagePickerController animated: YES
      completion: nil];
  }
}

#pragma mark - Protocol UIImagePickerControllerDelegate

- (void) imagePickerController: (UIImagePickerController *) picker
didFinishPickingMediaWithInfo: (NSDictionary *) info
{
  UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
  if (!image)
    image = [info objectForKey: UIImagePickerControllerOriginalImage];
  [[CustomLoading getInstance] setNumImages: 1];
  [[OMBUser currentUser] uploadImage: image withCompletion: ^(NSError *error) {
    if ([OMBUser currentUser].image && !error) {
      // [backgroundBlurView refreshWithImage: [OMBUser currentUser].image];
      // [userImageView setImage: [OMBUser currentUser].image];
    }
    else {
      [self showAlertViewWithError: error];
    }
    //[[self appDelegate].container stopSpinning];
  }];
  //[[self appDelegate].container startSpinning];
  [picker dismissViewControllerAnimated: YES completion: nil];
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
  CGFloat newScale = 1 + ((y * -3) / scaleBackView.frame.size.height);
  if (newScale < 1)
    newScale = 1;
  scaleBackView.transform = CGAffineTransformScale(
    CGAffineTransformIdentity, newScale, newScale);
}

// - (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
// {
//   if (isEditing)
//     [self done];
// }

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // User info
  // Renter info
  // Listings
  // Spacing
  return 4;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;

  CGFloat padding  = OMBPadding;
  CGRect tableRect = tableView.frame;

  UIEdgeInsets maxInsets = UIEdgeInsetsMake(0.0f, tableRect.size.width,
    0.0f, 0.0f);

  static NSString *EmptyCellID = @"EmptyCellID";
  UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:
    EmptyCellID];
  if (!emptyCell)
    emptyCell = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleDefault reuseIdentifier: EmptyCellID];

  // User info
  if (section == OMBMyRenterProfileSectionUserInfo) {
    // Image (NOT BEING USED)!!!
    if (row == OMBMyRenterProfileSectionUserInfoRowImage + 99) {
      static NSString *ImageID = @"ImageID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        ImageID];
      NSInteger imageViewTag = 9999;
      NSInteger labelTag     = 9998;
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: ImageID];
        // Image
        OMBCenteredImageView *imageView = [[OMBCenteredImageView alloc] init];
        imageView.frame = CGRectMake(padding, padding, OMBStandardButtonHeight,
          OMBStandardButtonHeight);
        imageView.layer.cornerRadius = imageView.frame.size.width * 0.5f;
        imageView.tag = imageViewTag;
        [cell.contentView addSubview: imageView];
        // Name
        CGFloat originX =
          imageView.frame.origin.x + imageView.frame.size.width + padding;
        UILabel *label = [UILabel new];
        label.font = [UIFont mediumLargeTextFontBold];
        label.frame = CGRectMake(originX, imageView.frame.origin.y,
          tableRect.size.width - (originX + padding),
            imageView.frame.size.height);
        label.tag = labelTag;
        label.textColor = [UIColor textColor];
        [cell.contentView addSubview: label];
      }
      // Image view
      if ([cell viewWithTag: imageViewTag]) {
        OMBCenteredImageView *imageView =
          (OMBCenteredImageView *) [cell viewWithTag: imageViewTag];
        imageView.image = user.image;
      }
      // Name label
      if ([cell viewWithTag: labelTag]) {
        UILabel *label = (UILabel *) [cell viewWithTag: labelTag];
        label.text = [user shortName];
      }
      cell.clipsToBounds = YES;
      return cell;
    }
    // Image, First name and Last Name
    else if(row == OMBMyRenterProfileSectionUserInfoRowImageFirstName){
      
      static NSString *imageTextFieldID = @"imageTextFieldID";
      OMBImageTwoTextFieldCell *cell = [tableView
        dequeueReusableCellWithIdentifier:imageTextFieldID];
      
      if(!cell){
        cell = [[OMBImageTwoTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:imageTextFieldID];
        // Setup frames
        [cell setupWithImage:user.image];
        
        // Upload Photo Recognizer
        UITapGestureRecognizer *tapGesture =
          [[UITapGestureRecognizer alloc] initWithTarget: self
            action: @selector(showUploadActionSheet)];
        [cell addGestureToImage: tapGesture];
        
        // Setup textfield
        NSString *imageName = @"user_icon.png";
        cell.firstIconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
          size: cell.firstIconImageView.frame.size];
        cell.firstTextField.delegate  = self;
        cell.firstTextField.indexPath = indexPath;
        cell.firstTextField.placeholder = @"First name";
        cell.firstTextField.textColor = [UIColor blueDark];
        [cell.firstTextField addTarget: self action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
        
        cell.secondIconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
          size: cell.secondIconImageView.frame.size];
        cell.secondTextField.delegate  = self;
        cell.secondTextField.indexPath =
          [NSIndexPath indexPathForRow:OMBMyRenterProfileSectionUserInfoRowImageLastName
            inSection:indexPath.section] ;
        cell.secondTextField.placeholder = @"Last name";
        cell.secondTextField.textColor = cell.firstTextField.textColor;
        [cell.secondTextField addTarget: self action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      }
      
      cell.clipsToBounds = YES;
      cell.firstTextField.text = [[valueDictionary objectForKey: @"firstName"] capitalizedString];
      cell.secondTextField.text = [[valueDictionary objectForKey: @"lastName"] capitalizedString];
      // Load image
      cell.userImage.image = user.image;
      
      return cell;
      
    }
    // About
    else if (row == OMBMyRenterProfileSectionUserInfoRowAbout) {
      static NSString *AboutCellID = @"AboutCellID";
      UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier: AboutCellID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: AboutCellID];
        [aboutTextView removeFromSuperview];
        [cell.contentView addSubview: aboutTextView];
      }
      aboutTextView.text = [valueDictionary objectForKey: @"about"];
      if ([[aboutTextView.text stripWhiteSpace] length]) {
        aboutTextViewPlaceholder.hidden = YES;
      }
      else {
        aboutTextViewPlaceholder.hidden = NO;
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.separatorInset = maxInsets;
      cell.clipsToBounds = YES;
      return cell;
    }
    // Everything else
    else {
      static NSString *LabelTextCellID = @"LabelTextCellID";
      OMBLabelTextFieldCell *cell =
        [tableView dequeueReusableCellWithIdentifier: LabelTextCellID];
      if (!cell) {
        cell = [[OMBLabelTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: LabelTextCellID];
        // [cell setFrameUsingSize: sizeForLabelTextFieldCell];
        [cell setFrameUsingIconImageView];
      }
      // cell.backgroundColor = transparentWhite;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.textField.font = [UIFont normalTextFont];
      cell.textField.textColor = [UIColor blueDark];
      cell.textFieldLabel.font = [UIFont normalTextFont];
      NSString *imageName = @"user_icon.png";
      NSString *key;
      NSString *labelString;
      // School
      if (row == OMBMyRenterProfileSectionUserInfoRowSchool) {
        imageName = @"school_icon.png";
        key         = @"school";
        labelString = @"School";
        cell.textField.keyboardType = UIKeyboardTypeDefault;
      }
      // Email
      else if (row == OMBMyRenterProfileSectionUserInfoRowEmail) {
        imageName = @"messages_icon_dark.png";
        key         = @"email";
        labelString = @"Email";
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
      }
      // Phone
      else if (row == OMBMyRenterProfileSectionUserInfoRowPhone) {
        imageName = @"phone_icon.png";
        key         = @"phone";
        labelString = @"Phone";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
      }
      cell.iconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
        size: cell.iconImageView.frame.size];
      cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.textField.delegate  = self;
      cell.textField.indexPath = indexPath;
      cell.textField.placeholder = [labelString capitalizedString];
      cell.textField.text = [valueDictionary objectForKey: key];
      cell.textFieldLabel.text = labelString;
      [cell.textField addTarget: self action: @selector(textFieldDidChange:)
        forControlEvents: UIControlEventEditingChanged];
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  // Renter info
  else if (section == OMBMyRenterProfileSectionRenterInfo) {
    if (row == OMBMyRenterProfileSectionRenterInfoTopSpacing) {
      emptyCell.backgroundColor = [UIColor backgroundColor];
      emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
      emptyCell.separatorInset = maxInsets;
    }
    else {
      static NSString *RenterID = @"RenterID";
      OMBRenterProfileUserInfoCell *cell =
        [tableView dequeueReusableCellWithIdentifier: RenterID];
      if (!cell)
        cell = [[OMBRenterProfileUserInfoCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: RenterID];
      cell.selectionStyle = UITableViewCellSelectionStyleDefault;
      [cell resetWithCheckmark];
      NSString *iconImageName;
      NSString *key = @"";
      NSString *string;
      // Co-applicants
      if (row == OMBMyRenterProfileSectionRenterInfoRowCoapplicants) {
        iconImageName = @"group_icon.png";
        key = OMBUserDefaultsRenterApplicationCheckedCoapplicants;
        string = @"Co-applicants";
      }
      else if (row == OMBMyRenterProfileSectionRenterInfoRowCosigners) {
        iconImageName = @"landlord_icon.png";
        key = OMBUserDefaultsRenterApplicationCheckedCosigners;
        string = @"Co-signer";
      }
      else if (row == OMBMyRenterProfileSectionRenterInfoRowRentalHistory) {
        iconImageName = @"house_icon.png";
        key = OMBUserDefaultsRenterApplicationCheckedRentalHistory;
        string = @"Rental History";
      }
      else if (row == OMBMyRenterProfileSectionRenterInfoRowWorkHistory) {
        iconImageName = @"papers_icon_black.png";
        key = OMBUserDefaultsRenterApplicationCheckedWorkHistory;
        string = @"Work & School History";
      }
      else if (row == OMBMyRenterProfileSectionRenterInfoRowLegalQuestions) {
        iconImageName = @"law_icon_black.png";
        key = OMBUserDefaultsRenterApplicationCheckedLegalQuestions;
        string = @"Legal Questions";
      }
      cell.iconImageView.image = [UIImage image:
        [UIImage imageNamed: iconImageName]
          size: cell.iconImageView.bounds.size];
      cell.label.text = string;
      if ([[[self renterapplicationUserDefaults] objectForKey: key] boolValue])
        [cell fillCheckmark];
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  // Listings
  else if (indexPath.section == OMBMyRenterProfileSectionListings) {
    // Listings header
    if (indexPath.row ==
        OMBMyRenterProfileSectionListingsRowInfoHeader) {
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
        headLabel.text = @"My Listings";
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
    // Listings
    else{
      static NSString *ListingsID = @"ListingsID";
      OMBManageListingsCell *cell =
        [tableView dequeueReusableCellWithIdentifier: ListingsID];
      if (!cell)
        cell = [[OMBManageListingsCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: ListingsID];
      [cell loadResidenceData: [[self listings] objectAtIndex: 
        indexPath.row - 1]];
      cell.statusLabel.hidden = YES;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      return cell;
    }
  }
  
  emptyCell.clipsToBounds = YES;
  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // User info
  if (section == OMBMyRenterProfileSectionUserInfo) {
    return 7;
  }
  // Renter info
  else if (section == OMBMyRenterProfileSectionRenterInfo) {
    // Top spacing
    // Co-applicants
    // Co-signers
    // Rental history
    // Work history
    // Legal questions
    return 6;
  }
  // Listings
  else if (section == OMBMyRenterProfileSectionListings) {
    if ([[self listings] count] && ![user isStudent]) {
      return 1 + [[self listings] count];
    }
  }
  // Spacing
  else if (section == OMBMyRenterProfileSectionSpacing) {
    return 1;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;

  // User info
  if (section == OMBMyRenterProfileSectionUserInfo) {
    // Image
    if (row == OMBMyRenterProfileSectionUserInfoRowImage) {
      [self showUploadActionSheet];
    }
  }
  // Renter info
  else if (section == OMBMyRenterProfileSectionRenterInfo) {
    id vc;
    NSString *key = @"";
    // Co-applicants
    if (row == OMBMyRenterProfileSectionRenterInfoRowCoapplicants) {
      key = OMBUserDefaultsRenterApplicationCheckedCoapplicants;
      vc  = [[OMBRenterInfoSectionRoommateViewController alloc] initWithUser:
        user];
    }
    // Co-signers
    else if (row == OMBMyRenterProfileSectionRenterInfoRowCosigners) {
      key = OMBUserDefaultsRenterApplicationCheckedCosigners;
      vc  = [[OMBRenterInfoSectionCosignersViewController alloc] initWithUser:
        user];
    }
    // Rental History
    else if (row == OMBMyRenterProfileSectionRenterInfoRowRentalHistory) {
      key = OMBUserDefaultsRenterApplicationCheckedRentalHistory;
      vc  = [[OMBRenterInfoSectionPreviousRentalViewController alloc]
        initWithUser: user];
    }
    // Work History
    else if (row == OMBMyRenterProfileSectionRenterInfoRowWorkHistory) {
      key = OMBUserDefaultsRenterApplicationCheckedWorkHistory;
      vc  = [[OMBRenterInfoSectionEmploymentViewController alloc] initWithUser:
        user];
    }
    // Legal Questions
    else if (row == OMBMyRenterProfileSectionRenterInfoRowLegalQuestions) {
      key = OMBUserDefaultsRenterApplicationCheckedLegalQuestions;
      vc  = [[OMBLegalViewController alloc] initWithUser: user];
    }
    if (vc) {
      [self.navigationController pushViewController: vc animated: YES];
    }
  }

  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;

  // User info
  if (section == OMBMyRenterProfileSectionUserInfo) {
    // Image (NOT BEING USED)!!!
    if (row == OMBMyRenterProfileSectionUserInfoRowImage) {
      return 0.0f;
      // return OMBPadding + OMBStandardButtonHeight + OMBPadding;
    }
    // Image, First and Last Name
    else if (row == OMBMyRenterProfileSectionUserInfoRowImageFirstName)
      return [OMBImageTwoTextFieldCell heightForCell];
    // Last Name
    else if (row == OMBMyRenterProfileSectionUserInfoRowImageLastName)
      return 0.0f;
    // School
    else if (row == OMBMyRenterProfileSectionUserInfoRowSchool) {
      if([user.landlordType isEqualToString:@"subletter"])
        return [OMBLabelTextFieldCell heightForCellWithIconImageView];
      
      if ([user isLandlord]) {
        return 0.0f;
      }
    }
    // About
    else if (row == OMBMyRenterProfileSectionUserInfoRowAbout) {
      return OMBPadding + (22.0f * 5) + OMBPadding;
    }
    return [OMBLabelTextFieldCell heightForCellWithIconImageView];
    // return [OMBLabelTextFieldCell heightForCell];
  }
  // Renter info
  else if (section == OMBMyRenterProfileSectionRenterInfo) {
    if ([user isLandlord] && ![user isStudent]) {
      return 0.f;
    }
    // Top spacing
    if (row == OMBMyRenterProfileSectionRenterInfoTopSpacing) {
      return OMBStandardHeight;
    }
    return OMBStandardButtonHeight;
  }
  // Listing
  else if (section == OMBMyRenterProfileSectionListings) {
    // My Listings
    if (row == OMBMyRenterProfileSectionListingsRowInfoHeader) {
      return OMBPadding + OMBStandardHeight + OMBPadding;
    }
    // Listings
    else {
      return [OMBManageListingsCell heightForCell];
    }
  }
  // Spacing
  else if (section == OMBMyRenterProfileSectionSpacing) {
    if (editingTextView || editingTextField) {
      return textFieldToolbar.frame.size.height + OMBKeyboardHeight;
    }
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (TextFieldPadding *) textField
{
  textField.inputAccessoryView = textFieldToolbar;

	editingTextField = textField;
	savedTextString  = textField.text;
  [self.table beginUpdates];
  [self.table endUpdates];

  if (textField.indexPath.row == OMBMyRenterProfileSectionUserInfoRowImageLastName)
    [self scrollToRectAtIndexPath:
      [NSIndexPath indexPathForRow:
        OMBMyRenterProfileSectionUserInfoRowImageFirstName
          inSection:textField.indexPath.section]];
  else
    [self scrollToRectAtIndexPath: textField.indexPath];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [self done];
  return YES;
}

#pragma mark - Protocol UITextViewDelegate

- (void) textViewDidBeginEditing: (UITextView *) textView
{
  textView.inputAccessoryView = textFieldToolbar;

	editingTextView = textView;
	savedTextString = textView.text;
  [self.table beginUpdates];
  [self.table endUpdates];

  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:
    OMBMyRenterProfileSectionUserInfoRowAbout
      inSection: OMBMyRenterProfileSectionUserInfo];
  [self scrollToRectAtIndexPath: indexPath];
}

- (void) textViewDidChange: (UITextView *) textView
{
  if ([[textView.text stripWhiteSpace] length]) {
    aboutTextViewPlaceholder.hidden = YES;
  }
  else {
    aboutTextViewPlaceholder.hidden = NO;
  }
  [valueDictionary setObject: textView.text forKey: @"about"];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancelFromInputAccessoryView
{
  if (editingTextField)
    editingTextField.text = savedTextString;

  if (editingTextView)
    editingTextView.text = savedTextString;

  [self done];
}

- (NSMutableDictionary *) renterapplicationUserDefaults
{
  NSMutableDictionary *dictionary =
    [[NSUserDefaults standardUserDefaults] objectForKey:
      OMBUserDefaultsRenterApplication];
  if (!dictionary)
    dictionary = [NSMutableDictionary dictionary];
  return dictionary;
}

- (void) done
{
  [self.view endEditing: YES];
	editingTextView = nil;
	editingTextField = nil;
	savedTextString = nil;
  [self.table beginUpdates];
  [self.table endUpdates];
}

- (void) linkedInButtonSelected
{
  LIALinkedInApplication *app =
    [LIALinkedInApplication applicationWithRedirectURL: @"https://onmyblock.com"
      clientId: @"75zr1yumwx0wld" clientSecret: @"XNY3VsMzvdhyR1ej"
        state: @"DCEEFWF45453sdffef424" grantedAccess: @[@"r_fullprofile"]];
  linkedInClient = [LIALinkedInHttpClient clientForApplication: app
    presentingViewController: self];
  [linkedInClient getAuthorizationCode: ^(NSString *code) {
    [linkedInClient getAccessToken: code success:
      ^(NSDictionary *accessTokenData) {
        NSString *accessToken = [accessTokenData objectForKey: @"access_token"];
        [user createAuthenticationForLinkedInWithAccessToken:
          accessToken completion: ^(NSError *error) {
            if (!error) {
              user.renterApplication.linkedinAuthenticated = YES;
              [self updateData];
              // Fetch the employments
              [user fetchEmploymentsWithCompletion: ^(NSError *error) {
                [self updateData];
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
    failure: ^(NSError *error) {
      [self showAlertViewWithError: error];
    }];
  } cancel: ^{
    NSLog(@"LINKEDIN CANCELED");
  } failure: ^(NSError *error) {
    [self showAlertViewWithError: error];
  }];
}

- (NSArray *) listings
{
  return [user residencesSortedWithKey:@"createdAt" ascending:NO];
}

- (void) loadUser: (OMBUser *) object
{
  user = object;

  if ([user isLandlord])
    self.title = @"My Profile";
  else
    self.title = @"My Renter Profile";
}

- (void) preview
{
  [self.navigationController pushViewController:
    [[OMBUserDetailViewController alloc] initWithUser: user]
      animated: YES];
}

- (void) progressConnection: (NSNotification *) notification
{
  float value = ([[notification object] floatValue]);

  CustomLoading *custom = [CustomLoading getInstance];

  if (value == 1.0) {
    custom.numImages--;
    [custom stopAnimatingWithView: self.view];
  }
  else {
    [custom startAnimatingWithProgress: (int)(value * 25) withView: self.view];
  }
}

- (void) save
{
  [[OMBUser currentUser] updateWithDictionary: valueDictionary
    completion: ^(NSError *error) {
      if (!error) {
        // Clear this because they updated their about
        // so the sizes need to change
        [[OMBUser currentUser].heightForAboutTextDictionary removeAllObjects];
        [self updateData];
        [[NSNotificationCenter defaultCenter] postNotificationName:
         OMBCurrentUserUploadedImage object: nil];
      }
      else {
        [self showAlertViewWithError: error];
      }
    }
  ];
}

- (void) saveFromInputAccessoryView
{
  [self save];
  [self done];
}

- (void) scrollToRectAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect rect = [self.table rectForRowAtIndexPath: indexPath];
  rect.origin.y -= (OMBPadding + textFieldToolbar.frame.size.height);
  [self.table setContentOffset: rect.origin animated: YES];
}

- (void) scrollToRowAtIndexPath: (NSIndexPath *) indexPath
{
  [self.table scrollToRowAtIndexPath: indexPath
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void)showUploadActionSheet
{
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil 
    delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
      otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
  [sheet showInView:self.view];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  NSInteger row = textField.indexPath.row;
  if (row == OMBMyRenterProfileSectionUserInfoRowImageFirstName) {
    if ([textField.text length])
      [valueDictionary setObject: textField.text forKey: @"firstName"];
  }
  else if (row == OMBMyRenterProfileSectionUserInfoRowImageLastName) {
    if ([textField.text length])
      [valueDictionary setObject: textField.text forKey: @"lastName"];
  }
  else if (row == OMBMyRenterProfileSectionUserInfoRowSchool) {
    [valueDictionary setObject: textField.text forKey: @"school"];
  }
  else if (row == OMBMyRenterProfileSectionUserInfoRowEmail) {
    [valueDictionary setObject: textField.text forKey: @"email"];
  }
  else if (row == OMBMyRenterProfileSectionUserInfoRowPhone) {
    [valueDictionary setObject: textField.text forKey: @"phone"];
  }
}

- (void) updateData
{
  // Image
  backImageView.image = user.image;
  // User icon
  userIconView.image = user.image;
  // Full name
  if ([[user shortName] length])
    fullNameLabel.text = [user shortName];

  [self.table reloadData];
}

@end
