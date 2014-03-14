//
//  OMBMyRenterProfileViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMyRenterProfileViewController.h"

#import "CustomLoading.h"
#import "LIALinkedInApplication.h"
#import "LIALinkedInHttpClient.h"
#import "OMBBecomeVerifiedViewController.h"
#import "OMBCenteredImageView.h"
#import "OMBEmploymentCell.h"
#import "OMBGradientView.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBOtherUserProfileViewController.h"
#import "OMBPickerViewCell.h"
#import "OMBRenterApplication.h"
#import "OMBRenterProfileUserInfoCell.h"
#import "OMBTwoLabelTextFieldCell.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Resize.h"

@implementation OMBMyRenterProfileViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.title = @"My Renter Profile";

  CGRect rect = [@"First name" boundingRectWithSize:
    CGSizeMake(9999, OMBStandardHeight) font: [UIFont normalTextFontBold]];
  sizeForLabelTextFieldCell = rect.size;

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillShow:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillHide:)
      name: UIKeyboardWillHideNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
    selector: @selector(progressConnection:)
      name: @"progressConnection" object:nil];

  // After coming back from Facebook upon verifying
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(facebookAuthenticationFinished:)
      name: OMBUserCreateAuthenticationForFacebookNotification object: nil];

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
  textFieldToolbar.items = @[leftPadding,
							 cancelBarButtonItemForTextFieldToolbar,
							 flexibleSpace,
							 doneBarButtonItemForTextFieldToolbar,
							 rightPadding];
  textFieldToolbar.tintColor = [UIColor blue];
  aboutTextView.inputAccessoryView = textFieldToolbar;
  
  // faded background
  fadedBackground = [[UIView alloc] init];
  fadedBackground.alpha = 0.0f;
  fadedBackground.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.8f];
  fadedBackground.frame = screen;
  [self.view addSubview: fadedBackground];
  UITapGestureRecognizer *tapGesture2 =
  [[UITapGestureRecognizer alloc] initWithTarget: self
                                          action: @selector(hidePickerView)];
  [fadedBackground addGestureRecognizer: tapGesture2];
  
  // Co-applicants picker view
  // Picker view container
  pickerViewContainer = [UIView new];
  [self.view addSubview: pickerViewContainer];
  
  // Header for picker view with cancel and done button
  UIView *pickerViewHeader = [[UIView alloc] init];
  pickerViewHeader.backgroundColor = [UIColor grayUltraLight];
  pickerViewHeader.frame = CGRectMake(0.0f, 0.0f,
                                      screen.size.width, 44.0f);
  [pickerViewContainer addSubview: pickerViewHeader];
  
  pickerViewHeaderLabel = [[UILabel alloc] init];
  pickerViewHeaderLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  pickerViewHeaderLabel.frame = pickerViewHeader.frame;
  pickerViewHeaderLabel.text = @"";
  pickerViewHeaderLabel.textAlignment = NSTextAlignmentCenter;
  pickerViewHeaderLabel.textColor = [UIColor textColor];
  [pickerViewHeader addSubview: pickerViewHeaderLabel];
  
  // Cancel button
  UIButton *cancelButton = [UIButton new];
  cancelButton.titleLabel.font = [UIFont fontWithName:
    @"HelveticaNeue-Medium" size: 15];
  CGRect cancelButtonRect = [@"Cancel" boundingRectWithSize:
     CGSizeMake(pickerViewHeader.frame.size.width, pickerViewHeader.frame.size.height)
        font: cancelButton.titleLabel.font];
  cancelButton.frame = CGRectMake(padding, 0.0f,
    cancelButtonRect.size.width, pickerViewHeader.frame.size.height);
  [cancelButton addTarget: self
    action: @selector(cancelPicker)
      forControlEvents: UIControlEventTouchUpInside];
  [cancelButton setTitle: @"Cancel" forState: UIControlStateNormal];
  [cancelButton setTitleColor: [UIColor blueDark]
    forState: UIControlStateNormal];
  [pickerViewHeader addSubview: cancelButton];
  
  // Done button
  UIButton *doneButton = [UIButton new];
  doneButton.titleLabel.font = cancelButton.titleLabel.font;
  CGRect doneButtonRect = [@"Done" boundingRectWithSize:
    CGSizeMake(pickerViewHeader.frame.size.width,
      pickerViewHeader.frame.size.height)
        font: doneButton.titleLabel.font];
  doneButton.frame = CGRectMake(pickerViewHeader.frame.size.width -
    (padding + doneButtonRect.size.width), 0.0f,
       doneButtonRect.size.width, pickerViewHeader.frame.size.height);
  [doneButton addTarget: self
    action: @selector(donePicker)
      forControlEvents: UIControlEventTouchUpInside];
  [doneButton setTitle: @"Done" forState: UIControlStateNormal];
  [doneButton setTitleColor: [UIColor blueDark]
     forState: UIControlStateNormal];
  [pickerViewHeader addSubview: doneButton];
  
  // co-applicant picker
  coapplicantPickerView = [[UIPickerView alloc] init];
  coapplicantPickerView.backgroundColor = [UIColor whiteColor];
  coapplicantPickerView.dataSource = self;
  coapplicantPickerView.delegate   = self;
  coapplicantPickerView.frame = CGRectMake(0.0f,
    pickerViewHeader.frame.origin.y + pickerViewHeader.frame.size.height,
      coapplicantPickerView.frame.size.width, coapplicantPickerView.frame.size.height);
  
  // co-signer picker
  cosignerPickerView = [[UIPickerView alloc] init];
  cosignerPickerView.backgroundColor = coapplicantPickerView.backgroundColor;
  cosignerPickerView.dataSource = self;
  cosignerPickerView.delegate   = self;
  cosignerPickerView.frame = CGRectMake(0.0f,
    pickerViewHeader.frame.origin.y + pickerViewHeader.frame.size.height,
      cosignerPickerView.frame.size.width, cosignerPickerView.frame.size.height);
  
  pickerViewContainer.frame = CGRectMake(0.0f, self.view.frame.size.height,
    coapplicantPickerView.frame.size.width,
      pickerViewHeader.frame.size.height +
        coapplicantPickerView.frame.size.height);
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];
  // #warning REMOVE THIS
  // [self.navigationController pushViewController:
  //   [[OMBBecomeVerifiedViewController alloc] initWithUser: user]
  //     animated: YES];
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];
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
    @"school":    user.school ? user.school : @"",

    @"coapplicantCount": [NSNumber numberWithInt: 
      user.renterApplication.coapplicantCount],
    @"hasCosigner": [NSNumber numberWithBool: 
      user.renterApplication.hasCosigner]
  }];

  [self updateData];

  // If user is the landlord
  if ([user isLandlord]) {
    self.title = @"My Profile";
    // Fetch listings
    [user fetchListingsWithCompletion: ^(NSError *error) {
      [self updateData];
    }];
  }
  else {
    self.title = @"My Renter Profile";
    // Fetch the information about the user, specifically the renter application
    [user fetchUserProfileWithCompletion: ^(NSError *error) {
      [valueDictionary setObject: [NSNumber numberWithInt: 
        user.renterApplication.coapplicantCount] forKey: @"coapplicantCount"];
      [valueDictionary setObject: [NSNumber numberWithBool: 
        user.renterApplication.hasCosigner] forKey: @"hasCosigner"];
      [self updateData];
    }];
    // Fetch the employments
    [user fetchEmploymentsWithCompletion: ^(NSError *error) {
      [self updateData];
    }];
  }
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

#pragma mark - Protocol UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView
{
  return 1;
}

- (NSInteger) pickerView: (UIPickerView *) pickerView
 numberOfRowsInComponent: (NSInteger) component
{
  if(pickerView == coapplicantPickerView)
    return 11;
  else if(pickerView == cosignerPickerView)
    return 2;
  
  return 0;
}

#pragma mark - Protocol UIPickerViewDelegate

- (CGFloat) pickerView: (UIPickerView *) pickerView
rowHeightForComponent: (NSInteger) component
{
  return OMBStandardHeight;
}

- (NSString *) pickerView: (UIPickerView *) pickerView 
titleForRow: (NSInteger) row forComponent: (NSInteger) component
{
  NSString *title =@"";
  if(pickerView == coapplicantPickerView){
    if(row == 0)
      title = @"None";
    else
      title = [NSString stringWithFormat: @"%i", row];
  }
  
  else if(pickerView == cosignerPickerView)
    title = (row == 0 ? @"Yes" : @"No");
  
  return title;
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
  // Rental info
  // Employments
  // Spacing
  return 4;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;

  CGFloat padding = OMBPadding;
  CGRect tableRect = tableView.frame;

  // Subclasses implement this
  static NSString *EmptyCellID = @"EmptyCellID";
  UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:
    EmptyCellID];
  if (!emptyCell)
    emptyCell = [[UITableViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: EmptyCellID];

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
      // cell.separatorInset = UIEdgeInsetsMake(0.0f,
      //   tableView.frame.size.width, 0.0f, 0.0f);
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
      NSString *imageName;
      NSString *key;
      NSString *labelString;
      // First name
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
        cell.secondTextField.placeholder = [lastNameLabelString capitalizedString];
        cell.secondTextField.text = [valueDictionary objectForKey: @"lastName"];
        cell.secondTextField.text = [cell.secondTextField.text capitalizedString];
        cell.secondTextFieldLabel.text = lastNameLabelString;
        [cell.secondTextField addTarget: self action: @selector(textFieldDidChange:)
                       forControlEvents: UIControlEventEditingChanged];
        return cell;
        
      }
      // Last name
      else if (row == OMBMyRenterProfileSectionUserInfoRowLastName) {
        imageName = @"user_icon.png";
        key         = @"lastName";
        labelString = @"Last name";
      }
      // School
      else if (row == OMBMyRenterProfileSectionUserInfoRowSchool) {
        imageName = @"school_icon.png";
        key         = @"school";
        labelString = @"School";
      }
      // Email
      else if (row == OMBMyRenterProfileSectionUserInfoRowEmail) {
        imageName = @"messages_icon_dark.png";
        key         = @"email";
        labelString = @"Email";
      }
      // Phone
      else if (row == OMBMyRenterProfileSectionUserInfoRowPhone) {
        imageName = @"phone_icon.png";
        key         = @"phone";
        labelString = @"Phone";
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
      return cell;
    }
  }
  else if (section == OMBMyRenterProfileSectionRentalInfo) {
    // Co-applicants picker view
    if (row == OMBMyRenterProfileSectionRentalInfoRowCoapplicantsPickerView) {
      
    }

    static NSString *RentalInfoID = @"RentalInfoID";
    OMBRenterProfileUserInfoCell *cell = 
      [tableView dequeueReusableCellWithIdentifier: RentalInfoID];
    if (!cell)
      cell = [[OMBRenterProfileUserInfoCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: RentalInfoID];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    [cell reset];
    CGSize imageSize = cell.iconImageView.bounds.size;
    UIImage *image;
    NSString *string;
    NSString *valueString;
    // Co-applicants
    if (row == OMBMyRenterProfileSectionRentalInfoRowCoapplicants) {
      image = [UIImage imageNamed: @"group_icon.png"];
      string = @"Co-applicants";
      int coapplicants = [[valueDictionary objectForKey: @"coapplicantCount"] intValue];
      if(coapplicants == 0)
        valueString = @"None";
      else
        valueString = [NSString stringWithFormat: @"%i", coapplicants];
    }
    // Co-signer
    else if (row == OMBMyRenterProfileSectionRentalInfoRowCosigners) {
      image = [UIImage imageNamed: @"landlord_icon.png"];
      string = @"Co-signer";
      if ([[valueDictionary objectForKey: @"hasCosigner"] intValue])
        valueString = @"Yes";
      else
        valueString = @"No";
    }
    // Facebook
    else if (row == OMBMyRenterProfileSectionRentalInfoRowFacebook) {
      [cell resetWithCheckmark];
      image  = [UIImage imageNamed: @"facebook_icon_blue.png"];
      string = @"Facebook";
      if (user.renterApplication.facebookAuthenticated) {
        cell.iconImageView.alpha = 1.0f;
        cell.userInteractionEnabled = NO;
        valueString = @"Verified";
        [cell fillCheckmark];
      }
      else{
        valueString = @"Unverified";
        cell.userInteractionEnabled = YES;
      }
    }
    // LinkedIn
    else if (row == OMBMyRenterProfileSectionRentalInfoRowLinkedIn) {
      [cell resetWithCheckmark];
      image  = [UIImage imageNamed: @"linkedin_icon.png"];
      string = @"LinkedIn";
      if (user.renterApplication.linkedinAuthenticated) {
        cell.iconImageView.alpha = 1.0f;
        cell.userInteractionEnabled = NO;
        valueString = @"Verified";
        [cell fillCheckmark];
      }
      else{
        valueString = @"Unverified";
        cell.userInteractionEnabled = YES;
      }
      // cell.separatorInset = UIEdgeInsetsMake(0.0f,
      //   tableView.frame.size.width, 0.0f, 0.0f);
    }
    cell.iconImageView.image = [UIImage image: image size: imageSize];
    cell.label.text = string;
    cell.valueLabel.text = valueString;
    return cell;
  }
  else if (section == OMBMyRenterProfileSectionEmployments) {
    static NSString *EmploymentCellID = @"EmploymentCellID";
    OMBEmploymentCell *cell = [tableView dequeueReusableCellWithIdentifier:
      EmploymentCellID];
    if (!cell)
      cell = [[OMBEmploymentCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: EmploymentCellID];
    [cell loadData: 
      [[user.renterApplication employmentsSortedByStartDate] 
        objectAtIndex: indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  }

  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (section == OMBMyRenterProfileSectionUserInfo) {
    return 7;
  }
  else if (section == OMBMyRenterProfileSectionRentalInfo) {
    return 5;
  }
  // Employments
  else if (section == OMBMyRenterProfileSectionEmployments) {
    return [[user.renterApplication employmentsSortedByStartDate] count];
  }
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
  // Rental info
  else if (section == OMBMyRenterProfileSectionRentalInfo) {
    // Co-applicants
    if (row == OMBMyRenterProfileSectionRentalInfoRowCoapplicants) {
      //[self reloadPickerViewRowAtIndexPath: indexPath];
      [self showPickerView: coapplicantPickerView];
    }
    // Co-signer
    else if (row == OMBMyRenterProfileSectionRentalInfoRowCosigners) {
      [self showPickerView: cosignerPickerView];
    }
    // Facebook
    else if (row == OMBMyRenterProfileSectionRentalInfoRowFacebook) {
      [self facebookButtonSelected];
    }
    // LinkedIn
    else if (row == OMBMyRenterProfileSectionRentalInfoRowLinkedIn) {
      [self linkedInButtonSelected];
    }
  }

  [self.table deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView 
heightForHeaderInSection: (NSInteger) section
{
  if (section == OMBMyRenterProfileSectionRentalInfo)
    return OMBStandardHeight;
  if (section == OMBMyRenterProfileSectionEmployments) {
    if (![user isLandlord]) {
      if ([[user.renterApplication employmentsSortedByStartDate] count])
        return OMBStandardHeight;
    }
  }
  return 0.0f;
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
      return OMBPadding + OMBStandardButtonHeight + OMBPadding;
    }
    // Last Name
    else if (row == OMBMyRenterProfileSectionUserInfoRowLastName)
      return 0.0f;
    // School
    else if (row == OMBMyRenterProfileSectionUserInfoRowSchool) {
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
  // Rental info
  else if (section == OMBMyRenterProfileSectionRentalInfo) {
    // Co-applicants
    if (row == OMBMyRenterProfileSectionRentalInfoRowCoapplicants) {
      if ([user isLandlord]) {
        return 0.0f;
      }
    }
    // Co-applicants picker view
    else if (row == 
      OMBMyRenterProfileSectionRentalInfoRowCoapplicantsPickerView) {
        return 0.0f;
    }
    // Co-signers
    else if (row == OMBMyRenterProfileSectionRentalInfoRowCosigners) {
      if ([user isLandlord]) {
        return 0.0f;
      }
    }
    return [OMBRenterProfileUserInfoCell heightForCell];
  }
  // Employments
  else if (section == OMBMyRenterProfileSectionEmployments) {
    if (![user isLandlord]) {
      return [OMBEmploymentCell heightForCell];
    }
  }
  // Spacing
  else if (section == OMBMyRenterProfileSectionSpacing) {
    if (editingTextView || editingTextField) {
      return 216.0f;
    }
  }
  return 0.0f;
}

- (UIView *) tableView: (UITableView *) tableView 
viewForHeaderInSection: (NSInteger) section
{
  NSString *string;
  if (section == OMBMyRenterProfileSectionRentalInfo)
    string = @"Verifications";
  if (section == OMBMyRenterProfileSectionEmployments)
    string = @"Work History";
  UIView *v = [UIView new];
  v.backgroundColor = [UIColor grayUltraLight];
  v.frame = CGRectMake(0.0f, 0.0f, 
    tableView.frame.size.width, OMBStandardHeight);
  UILabel *label = [UILabel new];
  label.font = [UIFont normalTextFont];
  label.frame = CGRectMake(OMBPadding, 0.0f, 
    v.frame.size.width - (OMBPadding * 2), v.frame.size.height);
  label.text = string;
  label.textColor = [UIColor grayMedium];
  label.textAlignment = NSTextAlignmentCenter;
  [v addSubview: label];
  return v;
}


#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (TextFieldPadding *) textField
{
  textField.inputAccessoryView = textFieldToolbar;

	editingTextField = textField;
	savedTextString = textField.text;
  [self.table beginUpdates];
  [self.table endUpdates];

  if(textField.indexPath.row == OMBMyRenterProfileSectionUserInfoRowLastName)
    [self scrollToRectAtIndexPath:[NSIndexPath indexPathForRow:OMBMyRenterProfileSectionUserInfoRowFirstName
       inSection:textField.indexPath.section]];
  else
    [self scrollToRectAtIndexPath: textField.indexPath];
  // [self.table scrollToRowAtIndexPath: textField.indexPath
  //   atScrollPosition: UITableViewScrollPositionTop animated: YES];
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
  // [self.table scrollToRowAtIndexPath: 
  //   [NSIndexPath indexPathForRow: OMBMyRenterProfileSectionUserInfoRowAbout
  //     inSection: OMBMyRenterProfileSectionUserInfo]
  //       atScrollPosition: UITableViewScrollPositionTop animated: YES];
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

- (void) cancelPicker
{
  [self updatePicker];
  [self hidePickerView];
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

- (void) donePicker
{
  [self hidePickerView];
  
  // Co-applicants
  if ([coapplicantPickerView superview]) {
    NSInteger selectedRow = [coapplicantPickerView selectedRowInComponent:0] ;
    [valueDictionary setObject: [NSNumber numberWithInt: selectedRow]
       forKey: @"coapplicantCount"];
    OMBRenterProfileUserInfoCell *cell = (OMBRenterProfileUserInfoCell *)
    [self.table cellForRowAtIndexPath:
      [NSIndexPath indexPathForItem:OMBMyRenterProfileSectionRentalInfoRowCoapplicants
        inSection:OMBMyRenterProfileSectionRentalInfo]];
    NSString *text;
    if(selectedRow == 0)
      text = @"None";
    else
      text = [NSString stringWithFormat:@"%i", selectedRow];
    cell.valueLabel.text = text ;
  }
  // Co-signer
  else if ([cosignerPickerView superview])
  {
    BOOL selectedRow = ([cosignerPickerView selectedRowInComponent:0] == 0)? YES : NO ;
    [valueDictionary setObject: [NSNumber numberWithBool: selectedRow]
      forKey: @"hasCosigner"];
    OMBRenterProfileUserInfoCell *cell = (OMBRenterProfileUserInfoCell *)
      [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForItem:OMBMyRenterProfileSectionRentalInfoRowCosigners
          inSection:OMBMyRenterProfileSectionRentalInfo]];
    cell.valueLabel.text = selectedRow ? @"Yes" : @"No";
  }
  
  [self updatePicker];
  [self updateRenterApplication];
}

- (void) facebookAuthenticationFinished: (NSNotification *) notification
{
  NSError *error = [notification.userInfo objectForKey: @"error"];
  if (!error) {
    user.renterApplication.facebookAuthenticated = YES;
    [user downloadImageFromImageURLWithCompletion: nil];
    [self updateData];
  }
  else {
    [self showAlertViewWithError: error];
  }
  [[self appDelegate].container stopSpinning];
}

- (void) facebookButtonSelected
{
  [[self appDelegate].container startSpinning];
  [[self appDelegate] openSession];
}

- (void) hidePickerView
{
  CGRect rect = pickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 0.0f;
    pickerViewContainer.frame = rect;
  }];
}

- (void) keyboardWillHide: (NSNotification *) notification
{
  // [self.navigationItem setRightBarButtonItem: saveBarButtonItem 
  //   animated: YES];
}

- (void) keyboardWillShow: (NSNotification *) notification
{
  // [self.navigationItem setRightBarButtonItem: doneBarButtonItem 
  //   animated: YES];
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

- (void) loadUser: (OMBUser *) object
{
  user = object;

  if ([user isLandlord])
    self.title = @"My Landlord Profile";
  else
    self.title = @"My Renter Profile";
}

- (void) preview
{
  [self.navigationController pushViewController:
    [[OMBOtherUserProfileViewController alloc] initWithUser: user]
      animated: YES];
}

- (void) progressConnection: (NSNotification *) notification
{
  float value = ([[notification object] floatValue]);
  
  CustomLoading *custom = [CustomLoading getInstance];
  //editBarButtonItem.enabled = NO;

  if (value == 1.0) {
    custom.numImages--;
    [custom stopAnimatingWithView: self.view];
      //editBarButtonItem.enabled = YES;
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
        // [self.navigationController popViewControllerAnimated: YES];
      }
      else {
        [self showAlertViewWithError: error];
      }
      // [[self appDelegate].container stopSpinning];
    }
  ];
  // [[self appDelegate].container startSpinning];
}

- (void) showPickerView:(UIPickerView *)pickerView
{
  NSString *titlePicker = @"";
  // Co-applicants picker view
  if (coapplicantPickerView == pickerView) {
		titlePicker = @"Co-applicants";
    [cosignerPickerView removeFromSuperview];
		[pickerViewContainer addSubview: coapplicantPickerView];
	}
  // Co-signers picker view
  else if(cosignerPickerView == pickerView)
  {
    titlePicker = @"Co-signers";
    [coapplicantPickerView removeFromSuperview];
    [pickerViewContainer addSubview: cosignerPickerView];
  }
	pickerViewHeaderLabel.text = titlePicker;
  CGRect rect = pickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height -
  pickerViewContainer.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 1.0f;
    pickerViewContainer.frame = rect;
  }];
}

- (void) cancelFromInputAccessoryView
{
	if (editingTextField)
		editingTextField.text = savedTextString;
	
	if (editingTextView)
		editingTextView.text = savedTextString;
	
	[self done];
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

  [self updatePicker];
  [self.table reloadData];
}

- (void) updateRenterApplication
{
  [user.renterApplication updateWithDictionary: valueDictionary
    completion: ^(NSError *error) {
      if (error)
        [self showAlertViewWithError: error];
      // [[self appDelegate].container stopSpinning];
    }
  ];
  // [[self appDelegate].container startSpinning];
}

- (void) updatePicker
{
  NSInteger coapplicant = [[valueDictionary objectForKey:
    @"coapplicantCount"] intValue];
  NSInteger cosigner = [[valueDictionary objectForKey:
    @"hasCosigner"] boolValue] ? 0 : 1;
  
  // Co-applicant picker
  [coapplicantPickerView selectRow: coapplicant
    inComponent: 0 animated: NO];
  // Co-signer picker
  [cosignerPickerView selectRow: cosigner
    inComponent:0 animated:NO];
}

@end
