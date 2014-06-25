//
//  OMBApplyResidenceViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBApplyResidenceViewController.h"

#import "AMBlurView.h"
#import "CustomLoading.h"
#import "LEffectLabel.h"
#import "LIALinkedInApplication.h"
#import "LIALinkedInHttpClient.h"
#import "NSString+OnMyBlock.h"
#import "OMBAlertViewBlur.h"
#import "OMBBecomeVerifiedViewController.h"
#import "OMBCenteredImageView.h"
#import "OMBEmployment.h"
#import "OMBEmploymentCell.h"
#import "OMBGradientView.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBLegalQuestion.h"
#import "OMBLegalQuestionStore.h"
#import "OMBLegalViewController.h"
#import "OMBManageListingsCell.h"
#import "OMBManageListingsConnection.h"
#import "OMBUserDetailViewController.h"
#import "OMBPickerViewCell.h"
#import "OMBPreviousRental.h"
#import "OMBRenterApplication.h"
#import "OMBRenterInfoSectionCosignersViewController.h"
#import "OMBRenterInfoSectionEmploymentViewController.h"
#import "OMBRenterInfoSectionPreviousRentalViewController.h"
#import "OMBRenterInfoSectionRoommateViewController.h"
#import "OMBRenterInfoSectionViewController.h"
#import "OMBRenterProfileUserInfoCell.h"
#import "OMBRoommate.h"
#import "OMBTwoLabelTextFieldCell.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

@interface OMBApplyResidenceViewController ()
<UIActionSheetDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
{
  NSUInteger residenceUID;
}

@end

@implementation OMBApplyResidenceViewController

#pragma mark - Initializer

#pragma mark - Initializer

- (id) initWithResidenceUID: (NSUInteger) uid
{
  if (!(self = [super init])) return nil;
  
  residenceUID = uid;
  self.title   = @"Renter Application";
  
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
  
  // Name view
  CGFloat nameViewHeight = OMBStandardButtonHeight;
  nameViewHeight = OMBStandardHeight;
  nameViewOriginY = (backView.frame.origin.y + backView.frame.size.height) -
  (nameViewHeight + padding);
  nameView = [UIView new];
  // nameView.backgroundColor = [UIColor redColor];
  nameView.frame = CGRectMake(0.0f, nameViewOriginY,
                              screenWidth, nameViewHeight);
  [self.view insertSubview: nameView belowSubview: self.table];
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
  [nameView addSubview: cameraImageView];
  
  // Table header view
  UIView *tableHeaderView = [UIView new];
  tableHeaderView.backgroundColor = [UIColor clearColor];
  tableHeaderView.frame = CGRectMake(0.0f, 0.0f, screenWidth,
    backViewOriginY + backView.frame.size.height);
  self.table.tableHeaderView = tableHeaderView;
  
  UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget: self
      action: @selector(showUploadActionSheet)];
  [tableHeaderView addGestureRecognizer: tapGesture];
  
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
  
  // Action sheet
  uploadActionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self
    cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil
      otherButtonTitles: @"Take Photo", @"Choose Existing", nil];
  [self.view addSubview: uploadActionSheet];
  
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
  
  //
  CGFloat submitHeight = OMBStandardHeight;
  submitHeight = OMBStandardButtonHeight;
  // Table footer view
  UIView *footerView = [[UIView alloc] init];
  footerView.frame = CGRectMake(0.0f, 0.0f, screenWidth, submitHeight);
  self.table.tableFooterView = footerView;
  
  // Submit offer view
  AMBlurView *submitView = [[AMBlurView alloc] init];
  submitView.blurTintColor = [UIColor blue];
  submitView.frame = CGRectMake(0.0f, screenHeight - submitHeight,
    screenWidth, submitHeight);
  [self.view addSubview: submitView];
  
  submitOfferButton = [UIButton new];
  submitOfferButton.frame = submitView.bounds;
  [submitOfferButton addTarget: self
    action: @selector(shouldSubmitApplication)
      forControlEvents: UIControlEventTouchUpInside];
  [submitOfferButton setBackgroundImage:
   [UIImage imageWithColor: [UIColor blueHighlightedAlpha: 0.3f]]
                               forState: UIControlStateHighlighted];
  [submitView addSubview: submitOfferButton];
  
  // Effect label
  effectLabel = [[LEffectLabel alloc] init];
  effectLabel.effectColor = [UIColor grayMedium];
  effectLabel.effectDirection = EffectDirectionLeftToRight;
  effectLabel.font = [UIFont mediumTextFontBold];
  effectLabel.frame = submitOfferButton.frame;
  effectLabel.sizeToFit = NO;
  effectLabel.text = @"Submit Application";
  effectLabel.textColor = [UIColor whiteColor];
  effectLabel.textAlignment = NSTextAlignmentCenter;
  [submitView insertSubview: effectLabel
    belowSubview: submitOfferButton];
  
  alertBlur = [[OMBAlertViewBlur alloc] init];
  
  _nextSection = 0;
  
  //sections = @[@1,@2,@3,@4,@5];
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
  
  [effectLabel performEffectAnimation];
  
  [self updateData];

  // Download renter info if it's first time
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  id downloadedInfo = [defaults objectForKey: OMBUserDefaultsRenterApplicationCreated];
  
  if (!downloadedInfo) {
    [defaults setObject: [NSNumber numberWithBool: NO]
      forKey: OMBUserDefaultsRenterApplicationCreated];
  }
  
  NSNumber *number = [defaults objectForKey: OMBUserDefaultsRenterApplicationCreated];
  if (![number boolValue]) {
    
    // Download all the user's renter application info that is required
    // for submitting an applications
    
    // Fetch coapplicants
    [self fetchObjectsForResourceName: [OMBRoommate resourceName]];
    
    // Fetch cosigners
    [[self renterApplication] fetchCosignersForUserUID: [OMBUser currentUser].uid
      delegate: self completion: ^(NSError *error) {
        [self reloadTable];
      }];
    
    // Previous Rental
    [self fetchObjectsForResourceName: [OMBPreviousRental resourceName]];
    // Employments
    [self fetchObjectsForResourceName: [OMBEmployment resourceName]];
    // Legal questions
    [user fetchLegalAnswersWithCompletion: ^(NSError *error){
      
      BOOL allAnswered = YES;
      
      NSMutableDictionary *legalAnswers =
      [NSMutableDictionary dictionaryWithDictionary:
       user.renterApplication.legalAnswers];
      
      for(OMBLegalQuestion *legalQuestion in
          [[OMBLegalQuestionStore sharedStore] questionsSortedByQuestion]){
        
        if(![legalAnswers objectForKey:
             [NSNumber numberWithInt: legalQuestion.uid]]){
          allAnswered = NO;
        }
      }
      
      [self saveKeyUserDefaults: allAnswered
        forKey: OMBUserDefaultsRenterApplicationCheckedLegalQuestions];
      // Set YES if all questions have been answered
      //[self saveKeyUserDefaults: allAnswered];
      [self.table reloadData];
      
    }];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:
     [NSNumber numberWithBool: YES] forKey: OMBUserDefaultsRenterApplicationCreated];
    [defaults synchronize];
  }
  
  if (_nextSection)
    [self showNextSection];
}

- (void) fetchObjectsForResourceName: (NSString *) resourceName
{
  [[self renterApplication] fetchListForResourceName: resourceName
    userUID: [OMBUser currentUser].uid delegate: self 
      completion: ^(NSError *error) {
        
       // Rental History
       if([resourceName isEqualToString:[OMBPreviousRental resourceName]]){
         
          BOOL saved = [[[self renterApplication] objectsWithModelName: [OMBPreviousRental modelName]
            sortedWithKey:@"moveInDate" ascending:NO] count];
          
          [self saveKeyUserDefaults: saved
            forKey:OMBUserDefaultsRenterApplicationCheckedRentalHistory];
        }
        // Work History
        else if([resourceName isEqualToString:[OMBEmployment resourceName]]){
         
          BOOL saved = [[[self  renterApplication] employmentsSortedByStartDate] count];
          
          [self saveKeyUserDefaults:saved
            forKey:OMBUserDefaultsRenterApplicationCheckedWorkHistory];
        }
        // Roommate
        else if([resourceName isEqualToString:[OMBRoommate resourceName]]){
          
          BOOL saved = [[[self  renterApplication] roommatesSort] count];
          
          [self saveKeyUserDefaults:saved
            forKey:OMBUserDefaultsRenterApplicationCheckedCoapplicants];
        }
        
        [self reloadTable];
        
      }];
}

- (OMBRenterApplication *) renterApplication
{
  return [OMBUser currentUser].renterApplication;
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];
  [self done];
  [self save];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *)dictionary
{
  
  [[self renterApplication] readFromCosignerDictionary:dictionary];
  
  [self saveKeyUserDefaults: [[[self renterApplication] cosignersSortedByFirstName] count]
    forKey: OMBUserDefaultsRenterApplicationCheckedCosigners];
  
}

- (void) JSONDictionary: (NSDictionary *) dictionary
forResourceName: (NSString *) resourceName
{
  // Employment
  if ([resourceName isEqualToString: [OMBEmployment resourceName]]) {
    [[self renterApplication] readFromDictionary: dictionary
      forModelName: [OMBEmployment modelName]];
  }
  // Previous Rental
  else if ([resourceName isEqualToString: [OMBPreviousRental resourceName]]) {
    [[self renterApplication] readFromDictionary: dictionary
      forModelName: [OMBPreviousRental modelName]];
  }
  // Roommate
  else if ([resourceName isEqualToString: [OMBRoommate resourceName]]) {
    [[self renterApplication] readFromDictionary: dictionary
      forModelName: [OMBRoommate modelName]];
  }
  //[self reloadTable];
}

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
      // First name & Last Name
      if (row == OMBMyRenterProfileSectionUserInfoRowFirstName) {
        imageName = @"user_icon.png";
        NSString *nameLabelString = @"First name";
        NSString *lastNameLabelString = @"Last name";
        
        static NSString *LabelTextCellID = @"TwoLabelTextCellID";
        OMBTwoLabelTextFieldCell *cell =
        [tableView dequeueReusableCellWithIdentifier: LabelTextCellID];
        if (!cell) {
          cell = [[OMBTwoLabelTextFieldCell alloc] initWithStyle:
                  UITableViewCellStyleDefault reuseIdentifier: LabelTextCellID];
          [cell setFrameUsingIconImageView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.firstTextField.font = [UIFont normalTextFont];
        cell.firstTextField.textColor = [UIColor blueDark];
        cell.firstTextFieldLabel.font = [UIFont normalTextFont];
        cell.firstIconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
                                                  size: cell.firstIconImageView.frame.size];
        cell.firstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.firstTextField.delegate  = self;
        cell.firstTextField.indexPath = indexPath;
        cell.firstTextField.keyboardType = UIKeyboardTypeDefault;
        cell.firstTextField.placeholder = [nameLabelString capitalizedString];
        cell.firstTextField.text = [valueDictionary objectForKey: @"firstName"];
        cell.firstTextField.text = [cell.firstTextField.text capitalizedString];
        cell.firstTextFieldLabel.text = nameLabelString;
        [cell.firstTextField addTarget: self action: @selector(textFieldDidChange:)
                      forControlEvents: UIControlEventEditingChanged];
        
        cell.secondTextField.font = cell.firstTextField.font;
        cell.secondTextField.textColor = cell.firstTextField.textColor;
        cell.secondTextFieldLabel.font = cell.firstTextFieldLabel.font;
        cell.secondIconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
                                                   size: cell.secondIconImageView.frame.size];
        cell.secondTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.secondTextField.delegate  = self;
        cell.secondTextField.indexPath =
        [NSIndexPath indexPathForRow:OMBMyRenterProfileSectionUserInfoRowLastName
                           inSection:indexPath.section] ;
        cell.secondTextField.keyboardType = UIKeyboardTypeDefault;
        cell.secondTextField.placeholder = [lastNameLabelString capitalizedString];
        cell.secondTextField.text = [valueDictionary objectForKey: @"lastName"];
        cell.secondTextField.text = [cell.secondTextField.text capitalizedString];
        cell.secondTextFieldLabel.text = lastNameLabelString;
        [cell.secondTextField addTarget: self action: @selector(textFieldDidChange:)
                       forControlEvents: UIControlEventEditingChanged];
        cell.clipsToBounds = YES;
        return cell;
      }
      // School
      else if (row == OMBMyRenterProfileSectionUserInfoRowSchool) {
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
    NSString *key = @"";
    // Co-applicants
    if (row == OMBMyRenterProfileSectionRenterInfoRowCoapplicants) {
      key = OMBUserDefaultsRenterApplicationCheckedCoapplicants;
      OMBRenterInfoSectionRoommateViewController *vc  =
      [[OMBRenterInfoSectionRoommateViewController alloc] initWithUser:
       user];
      vc.delegate = self;
      [self.navigationController pushViewController: vc animated: YES];
    }
    // Co-signers
    else if (row == OMBMyRenterProfileSectionRenterInfoRowCosigners) {
      key = OMBUserDefaultsRenterApplicationCheckedCosigners;
      OMBRenterInfoSectionCosignersViewController *vc  =
      [[OMBRenterInfoSectionCosignersViewController alloc] initWithUser:
       user];
      vc.delegate = self;
      [self.navigationController pushViewController: vc animated: YES];
    }
    // Rental History
    else if (row == OMBMyRenterProfileSectionRenterInfoRowRentalHistory) {
      key = OMBUserDefaultsRenterApplicationCheckedRentalHistory;
      OMBRenterInfoSectionPreviousRentalViewController *vc  =
      [[OMBRenterInfoSectionPreviousRentalViewController alloc] initWithUser: user];
      vc.delegate = self;
      [self.navigationController pushViewController: vc animated: YES];
    }
    // Work History
    else if (row == OMBMyRenterProfileSectionRenterInfoRowWorkHistory) {
      key = OMBUserDefaultsRenterApplicationCheckedWorkHistory;
      OMBRenterInfoSectionEmploymentViewController *vc  =
      [[OMBRenterInfoSectionEmploymentViewController alloc] initWithUser:  user];
      vc.delegate = self;
      [self.navigationController pushViewController: vc animated: YES];
    }
    // Legal Questions
    else if (row == OMBMyRenterProfileSectionRenterInfoRowLegalQuestions) {
      key = OMBUserDefaultsRenterApplicationCheckedLegalQuestions;
      OMBLegalViewController *vc  = [[OMBLegalViewController alloc] initWithUser: user];
      //vc.delegate = self;
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
    // Last Name
    else if (row == OMBMyRenterProfileSectionUserInfoRowLastName)
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
    
    if([user isLandlord] && ![user.landlordType isEqualToString:@"subletter"])
      return 0.0;
    
    // Top spacing
    if (row == OMBMyRenterProfileSectionRenterInfoTopSpacing) {
      return OMBStandardHeight;
    }
    return OMBStandardButtonHeight;
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
  
  if (textField.indexPath.row == OMBMyRenterProfileSectionUserInfoRowLastName)
    [self scrollToRectAtIndexPath:
      [NSIndexPath indexPathForRow:
        OMBMyRenterProfileSectionUserInfoRowFirstName
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

- (void) saveKeyUserDefaults: (BOOL)save forKey:(NSString *)key
{
  NSMutableDictionary *dictionary =
    [NSMutableDictionary dictionaryWithDictionary:
      [self renterapplicationUserDefaults]];
  [dictionary setObject:
    [NSNumber numberWithBool: save] forKey: key];
  [[NSUserDefaults standardUserDefaults] setObject: dictionary
    forKey: OMBUserDefaultsRenterApplication];
  [[NSUserDefaults standardUserDefaults] synchronize];
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

- (void) showUploadActionSheet
{
  [uploadActionSheet showInView: self.view];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  NSInteger row = textField.indexPath.row;
  if (row == OMBMyRenterProfileSectionUserInfoRowFirstName) {
    if ([textField.text length])
      [valueDictionary setObject: textField.text forKey: @"firstName"];
  }
  else if (row == OMBMyRenterProfileSectionUserInfoRowLastName) {
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

// Above methods are from MyRenterProfile

// Real Methods

- (NSString *) incompleteFieldString
{
  NSString *string = @"";
  
  NSArray *keyArray = @[@"firstName", @"lastName", @"school", @"email", @"phone"];
  
  for(NSString *key in keyArray)
  {
    if(![[valueDictionary objectForKey:key] length]){
      if([key isEqualToString:@"firstName"])
        string = @"First Name";
      else if([key isEqualToString:@"lastName"])
          string = @"Last Name";
      else if([key isEqualToString:@"school"])
          string = @"School";
      else if([key isEqualToString:@"email"])
          string = @"Email";
      else if([key isEqualToString:@"phone"])
          string = @"Phone";
      break;
    }
  }
  
  return string;
}

- (void) showNextSection
{
  NSLog(@"next");
  BOOL animated = NO;
  
  int i;
  // If is the last, set the first section to search
  //if(_nextSection == sections.count)
  //  i = 1;
  //else
  i = _nextSection + 1;
  
  switch (i) {
    case 2:
      {OMBRenterInfoSectionCosignersViewController *vc  =
      [[OMBRenterInfoSectionCosignersViewController alloc] initWithUser: user];
      vc.delegate = self;
      [self.navigationController pushViewController:vc animated:animated];}
      return;
      break;
    case 3:
      {OMBRenterInfoSectionPreviousRentalViewController *vc  =
      [[OMBRenterInfoSectionPreviousRentalViewController alloc] initWithUser: user];
      vc.delegate = self;
      [self.navigationController pushViewController:vc animated:animated];}
      return;
      break;
    case 4:
      {OMBRenterInfoSectionEmploymentViewController *vc  =
      [[OMBRenterInfoSectionEmploymentViewController alloc] initWithUser: user];
      vc.delegate = self;
      [self.navigationController pushViewController:vc animated:animated];}
      return;
      break;
    case 5:
      _nextSection = 0;
      {OMBLegalViewController *vc  = [[OMBLegalViewController alloc] initWithUser: user];
      //vc.delegate = self;
      [self.navigationController pushViewController:vc animated:animated];}
      return;
  }
  
  
  
  // It iterates 1 cicle searching for any section incomplete
  /*while(i != _nextSection){
    // 'Casue is the next incomplete section
    switch (i) {
      case 1:// First section(Co-applicants) is not required
        break;
      case 2:
        if (![[[self renterapplicationUserDefaults] objectForKey:
               OMBUserDefaultsRenterApplicationCheckedCosigners] boolValue]){
          OMBRenterInfoSectionCosignersViewController *vc  =
          [[OMBRenterInfoSectionCosignersViewController alloc] initWithUser: user];
          vc.delegate = self;
          [self.navigationController pushViewController:vc animated:animated];
          return;
        }
        break;
      case 3:
        if (![[[self renterapplicationUserDefaults] objectForKey:
               OMBUserDefaultsRenterApplicationCheckedRentalHistory] boolValue]){
          OMBRenterInfoSectionPreviousRentalViewController *vc  =
          [[OMBRenterInfoSectionPreviousRentalViewController alloc] initWithUser: user];
          vc.delegate = self;
          [self.navigationController pushViewController:vc animated:animated];
          return;
        }
        break;
      case 4:
        if (![[[self renterapplicationUserDefaults] objectForKey:
               OMBUserDefaultsRenterApplicationCheckedWorkHistory] boolValue]){
          OMBRenterInfoSectionEmploymentViewController *vc  =
          [[OMBRenterInfoSectionEmploymentViewController alloc] initWithUser: user];
          vc.delegate = self;
          [self.navigationController pushViewController:vc animated:animated];
          return;
        }
        break;
      case 5:
        if (![[[self renterapplicationUserDefaults] objectForKey:
               OMBUserDefaultsRenterApplicationCheckedLegalQuestions] boolValue]){
          OMBLegalViewController *vc  = [[OMBLegalViewController alloc] initWithUser: user];
          vc.delegate = self;
          [self.navigationController pushViewController:vc animated:animated];
          return;
        }
    }
    
    // Jump from the last section to the first or
    // go to the next section
    // For check is there is an incomplete section
    if(i == sections.count)
      i = 1;
    else
      i++;
    
  }*/
  
}

- (void) showHomebaseRenter
{
  [alertBlur close];
  [[self appDelegate].container showHomebaseRenter];
  [self.navigationController popViewControllerAnimated: NO];
}

- (void) shouldSubmitApplication
{
  BOOL shouldSubmit = YES;
  NSString *message = @"";
  NSString *title = @"Almost Finished";
  
  NSArray *keyArray = @[@"firstName", @"lastName",
    @"school", @"email", @"phone"];
  
  // Search missing field
  for(NSString *key in keyArray){
    
    if(![[valueDictionary objectForKey:key] length]){
      shouldSubmit = NO;
      // Set correct message
      message = [[self incompleteFieldString] stringByAppendingString:
        @" is required to submit an application"];
      break;
    }
  }
  
  // If all fields are completed then search for possible sections missing
  // This is just for set the correct message
  
  if (shouldSubmit) {
    // Require
    // Previous rentals
    // Employments
    // Legal answers
    for (NSString *modelName in @[
      [OMBPreviousRental modelName], [OMBEmployment modelName]]) {
      if ([[[self renterApplication] objectsWithModelName: modelName
        sortedWithKey: @"uid" ascending: NO] count] == 0) {
        // Previous Rental
        if ([modelName isEqualToString: [OMBPreviousRental modelName]]) {
          message = @"Rental history";
        }
        // Employments
        else if ([modelName isEqualToString: [OMBEmployment modelName]]) {
          message = @"Work & School History";
        }
        shouldSubmit = NO;
        break;
      }
    }
    // Legal answers
    if (shouldSubmit) {
      if ([[self renterApplication].legalAnswers count] != 
        [[OMBLegalQuestionStore sharedStore] legalQuestionsCount]) {
        message = @"Legal Questions";
        shouldSubmit = NO;
      }
    }
    message = [message stringByAppendingString: 
      @" section is required to submit an application."];
  }
  
  // Submit Application ?
  if(!shouldSubmit){
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
       message: message delegate: nil
        cancelButtonTitle: @"Continue" otherButtonTitles: nil];
    [alertView show];
  }
  else{
    [self submitApplication];
  }
}

- (void) submitApplication
{
  [[self renterApplication] createSentApplicationForResidenceUID: residenceUID
    completion: ^(NSError *error) {
      if (error) {
        [self showAlertViewWithError: error];
      }
      else {
        [alertBlur setTitle: @"Application Submitted!"];
        [alertBlur setMessage: 
          @"The landlord will review your application and make a decision. "
          @"If you have applied with co-applicants make sure they have "
          @"completed applications as well. Feel free to message the "
          @"landlord for more information about the property "
          @"or to schedule a viewing."];
        [alertBlur setConfirmButtonTitle: @"Okay"];
        [alertBlur addTargetForConfirmButton: self
          action: @selector(showHomebaseRenter)];
        [alertBlur showInView: self.view withDetails: NO];

        [alertBlur hideCloseButton];
        [alertBlur hideQuestionButton];
        [alertBlur showOnlyConfirmButton];
      }
      [self containerStopSpinningFullScreen];
    }];
  [self containerStartSpinningFullScreen];
}

@end
