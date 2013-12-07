//
//  OMBAccountProfileViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBAccountProfileViewController.h"

#import "OMBCenteredImageView.h"
#import "OMBGradientView.h"
#import "OMBUserUpdateProfileConnection.h"
#import "OMBUserUploadImageConnection.h"
#import "OMBViewControllerContainer.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBAccountProfileViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  isEditing = NO;

  self.screenName = self.title = @"Profile";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen      = [[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;

  labelsArray     = [NSMutableArray array];
  textFieldsArray = [NSMutableArray array];

  // Navigation
  // Right
  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
    style: UIBarButtonItemStylePlain target: self 
      action: @selector(doneEditing)];
  editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Edit"
    style: UIBarButtonItemStylePlain target: self action: @selector(showEdit)];
  saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Save"
    style: UIBarButtonItemStylePlain target: self action: @selector(showSave)];
  self.navigationItem.rightBarButtonItem = editBarButtonItem;

  self.table.backgroundColor = [UIColor grayUltraLight];

  // User profile image
  userProfileImageView = [[OMBCenteredImageView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, screenWidth, (screenHeight * 0.4f))];
  OMBGradientView *gradient = [[OMBGradientView alloc] init];
    gradient.colors = @[
      [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.0],
        [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5]];
  gradient.frame = userProfileImageView.frame;
  [userProfileImageView addSubview: gradient];
  // First name, last name
  fullNameLabel = [[UILabel alloc] init];
  fullNameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 27];
  fullNameLabel.frame = CGRectMake(20.0f, 
      userProfileImageView.frame.size.height - (36 + 20),
        userProfileImageView.frame.size.width - (20 * 2), 36.0f);
  fullNameLabel.textColor = [UIColor whiteColor];
  [userProfileImageView addSubview: fullNameLabel];

  // Upload
  // View that holds everything
  uploadPhotoView = [[UIView alloc] init];
  float uploadPhotoViewSize = userProfileImageView.frame.size.width * 0.5;
  uploadPhotoView.alpha = 0.0f;
  uploadPhotoView.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.5];
  uploadPhotoView.clipsToBounds = YES;
  uploadPhotoView.frame = CGRectMake(
    (userProfileImageView.frame.size.width - uploadPhotoViewSize) * 0.5,
      (userProfileImageView.frame.size.height - uploadPhotoViewSize) * 0.5,
        uploadPhotoViewSize, uploadPhotoViewSize);
  uploadPhotoView.layer.cornerRadius = 5.0f;
  [userProfileImageView addSubview: uploadPhotoView];
  // Image of the camera
  UIImageView *uploadImageView = [[UIImageView alloc] init];
  float uploadImageViewSize = uploadPhotoViewSize * 0.5;
  uploadImageView.frame = CGRectMake(
    (uploadPhotoViewSize - uploadImageViewSize) * 0.5,
      (uploadPhotoViewSize - uploadImageViewSize) * 0.5,
        uploadImageViewSize, uploadImageViewSize);
  uploadImageView.image = [UIImage imageNamed: @"camera_icon.png"];
  [uploadPhotoView addSubview: uploadImageView];
  // Button to show the image picker controller
  UIButton *uploadButton = [[UIButton alloc] init];
  uploadButton.frame = CGRectMake(0, 0, 
    uploadPhotoViewSize, uploadPhotoViewSize);
  [uploadButton addTarget: self action: @selector(uploadButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [uploadButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor colorWithWhite: 0 alpha: 0.3]] 
      forState: UIControlStateHighlighted];
  [uploadPhotoView addSubview: uploadButton];

  // Action sheet
  uploadActionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self 
    cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil 
      otherButtonTitles: @"Take Photo", @"Choose Existing", nil];
  [self.view addSubview: uploadActionSheet];

  // Image picker controller
  imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.allowsEditing = YES;
  imagePickerController.delegate = self;

  // User profile view
  int padding = 20;
  userProfileView = [[UIView alloc] init];
  userProfileView.backgroundColor = [UIColor redColor];
  // height is padding top and bottom and 3 times the label heights
  userProfileView.frame = CGRectMake(0, 0, screenWidth,
    padding + (22 * 3) + padding);
  // Labels
  // School
  schoolLabel = [[UILabel alloc] init];  
  schoolLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  schoolLabel.frame = CGRectMake(padding, padding, 
    screenWidth - (padding * 2), 22);
  schoolLabel.textColor = [UIColor textColor];
  [labelsArray addObject: schoolLabel];
  [userProfileView addSubview: schoolLabel];
  // Email
  emailLabel = [[UILabel alloc] init];
  emailLabel.font = schoolLabel.font;
  emailLabel.frame = CGRectMake(schoolLabel.frame.origin.x,
    schoolLabel.frame.origin.y + schoolLabel.frame.size.height,
      schoolLabel.frame.size.width, schoolLabel.frame.size.height);
  emailLabel.textColor = schoolLabel.textColor;
  [labelsArray addObject: emailLabel];
  [userProfileView addSubview: emailLabel];
  // Phone
  phoneLabel = [[UILabel alloc] init];
  phoneLabel.font = emailLabel.font;
  phoneLabel.frame = CGRectMake(emailLabel.frame.origin.x,
    emailLabel.frame.origin.y + emailLabel.frame.size.height,
      emailLabel.frame.size.width, emailLabel.frame.size.height);
  phoneLabel.textColor = schoolLabel.textColor;
  [labelsArray addObject: phoneLabel];
  [userProfileView addSubview: phoneLabel];
  // About
  aboutLabel = [[UILabel alloc] init];
  aboutLabel.font = schoolLabel.font;
  aboutLabel.frame = CGRectMake(schoolLabel.frame.origin.x,
    padding + phoneLabel.frame.origin.y + phoneLabel.frame.size.height, 
      schoolLabel.frame.size.width, 0);
  aboutLabel.numberOfLines = 0;
  aboutLabel.textColor = schoolLabel.textColor;
  [labelsArray addObject: aboutLabel];
  [userProfileView addSubview: aboutLabel];

  // Text fields
  userTextFieldView = [[UIView alloc] init];
  userTextFieldView.alpha = 0.0f;
  userTextFieldView.frame = CGRectMake(userProfileView.frame.origin.x,
    userProfileView.frame.origin.y, userProfileView.frame.size.width,
      // 44 is the height of the text fields, 20 is the spacing in between
      (44 * 4) + (20 * 3));
  // First name
  firstNameTextField = [[TextFieldPadding alloc] init];
  firstNameTextField.alpha = 0.0f;
  firstNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  firstNameTextField.backgroundColor = [UIColor grayUltraLight];
  firstNameTextField.delegate = self;
  firstNameTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  firstNameTextField.frame = CGRectMake(padding, padding, 
    (screenWidth - (padding * 3)) * 0.5, 44);
  firstNameTextField.layer.borderColor = [UIColor grayLight].CGColor;
  firstNameTextField.layer.borderWidth = 1.0;
  firstNameTextField.layer.cornerRadius = 2.0;
  firstNameTextField.paddingX = padding * 0.5;
  firstNameTextField.paddingY = padding * 0.5;
  firstNameTextField.placeholder = @"First name";
  firstNameTextField.returnKeyType = UIReturnKeyDone;
  firstNameTextField.textColor = [UIColor textColor];
  [textFieldsArray addObject: firstNameTextField];
  // [userTextFieldView addSubview: firstNameTextField];
  // Last name
  lastNameTextField = [[TextFieldPadding alloc] init];
  lastNameTextField.alpha = firstNameTextField.alpha;
  lastNameTextField.autocorrectionType = firstNameTextField.autocorrectionType;
  lastNameTextField.backgroundColor = firstNameTextField.backgroundColor;
  lastNameTextField.delegate = firstNameTextField.delegate;
  lastNameTextField.font = firstNameTextField.font;
  lastNameTextField.frame = CGRectMake(
    screenWidth - (firstNameTextField.frame.size.width + padding), 
      firstNameTextField.frame.origin.y, firstNameTextField.frame.size.width,
        firstNameTextField.frame.size.height);
  lastNameTextField.layer.borderColor = firstNameTextField.layer.borderColor;
  lastNameTextField.layer.borderWidth = firstNameTextField.layer.borderWidth;
  lastNameTextField.layer.cornerRadius = firstNameTextField.layer.cornerRadius;
  lastNameTextField.paddingX = firstNameTextField.paddingX;
  lastNameTextField.paddingY = firstNameTextField.paddingY;
  lastNameTextField.placeholder = @"Last name";
  lastNameTextField.returnKeyType = firstNameTextField.returnKeyType;
  lastNameTextField.textColor = firstNameTextField.textColor;
  [textFieldsArray addObject: lastNameTextField];
  // [userTextFieldView addSubview: lastNameTextField];
  // School
  schoolTextField = [[TextFieldPadding alloc] init];
  schoolTextField.alpha = firstNameTextField.alpha;
  schoolTextField.autocorrectionType = firstNameTextField.autocorrectionType;
  schoolTextField.backgroundColor = firstNameTextField.backgroundColor;
  schoolTextField.delegate = firstNameTextField.delegate;
  schoolTextField.font = firstNameTextField.font;
  schoolTextField.frame = CGRectMake(padding, padding, 
    screenWidth - (padding * 2), firstNameTextField.frame.size.height);
  schoolTextField.layer.borderColor = firstNameTextField.layer.borderColor;
  schoolTextField.layer.borderWidth = firstNameTextField.layer.borderWidth;
  schoolTextField.layer.cornerRadius = firstNameTextField.layer.cornerRadius;
  schoolTextField.paddingX = firstNameTextField.paddingX;
  schoolTextField.paddingY = firstNameTextField.paddingY;
  schoolTextField.placeholder = @"School";
  schoolTextField.returnKeyType = firstNameTextField.returnKeyType;
  schoolTextField.textColor = firstNameTextField.textColor;
  [textFieldsArray addObject: schoolTextField];
  // [userTextFieldView addSubview: schoolTextField];
  // Email
  emailTextField = [[TextFieldPadding alloc] init];
  emailTextField.alpha = firstNameTextField.alpha;
  emailTextField.autocorrectionType = firstNameTextField.autocorrectionType;
  emailTextField.backgroundColor = firstNameTextField.backgroundColor;
  emailTextField.delegate = firstNameTextField.delegate;
  emailTextField.font = firstNameTextField.font;
  emailTextField.frame = schoolTextField.frame;
  emailTextField.layer.borderColor = firstNameTextField.layer.borderColor;
  emailTextField.layer.borderWidth = firstNameTextField.layer.borderWidth;
  emailTextField.layer.cornerRadius = firstNameTextField.layer.cornerRadius;
  emailTextField.paddingX = firstNameTextField.paddingX;
  emailTextField.paddingY = firstNameTextField.paddingY;
  emailTextField.placeholder = @"Email";
  emailTextField.returnKeyType = firstNameTextField.returnKeyType;
  emailTextField.textColor = firstNameTextField.textColor;
  [textFieldsArray addObject: emailTextField];
  // [userTextFieldView addSubview: emailTextField];
  // Phone
  phoneTextField = [[TextFieldPadding alloc] init];
  phoneTextField.alpha = firstNameTextField.alpha;
  phoneTextField.autocorrectionType = firstNameTextField.autocorrectionType;
  phoneTextField.backgroundColor = firstNameTextField.backgroundColor;
  phoneTextField.delegate = firstNameTextField.delegate;
  phoneTextField.font = firstNameTextField.font;
  phoneTextField.frame = schoolTextField.frame;
  phoneTextField.layer.borderColor = firstNameTextField.layer.borderColor;
  phoneTextField.layer.borderWidth = firstNameTextField.layer.borderWidth;
  phoneTextField.layer.cornerRadius = firstNameTextField.layer.cornerRadius;
  phoneTextField.paddingX = firstNameTextField.paddingX;
  phoneTextField.paddingY = firstNameTextField.paddingY;
  phoneTextField.placeholder = @"Phone";
  phoneTextField.returnKeyType = firstNameTextField.returnKeyType;
  phoneTextField.textColor = firstNameTextField.textColor;
  [textFieldsArray addObject: phoneTextField];
  // [userTextFieldView addSubview: phoneTextField];

  // About text view
  aboutTextView = [[UITextView alloc] init];
  aboutTextView.alpha = firstNameTextField.alpha;
  aboutTextView.autocorrectionType = UITextAutocorrectionTypeYes;
  aboutTextView.backgroundColor = firstNameTextField.backgroundColor;
  aboutTextView.delegate = self;
  aboutTextView.font = firstNameTextField.font;
  aboutTextView.frame = CGRectMake(aboutLabel.frame.origin.x,
    aboutLabel.frame.origin.y, aboutLabel.frame.size.width, 0);
  aboutTextView.keyboardAppearance= UIKeyboardAppearanceLight;
  aboutTextView.layer.borderColor = firstNameTextField.layer.borderColor;
  aboutTextView.layer.borderWidth = firstNameTextField.layer.borderWidth;
  aboutTextView.layer.cornerRadius = firstNameTextField.layer.cornerRadius;
  aboutTextView.showsVerticalScrollIndicator = NO;
  aboutTextView.textColor = firstNameTextField.textColor;
  [textFieldsArray addObject: aboutTextView];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  // Load the user's image
  // Slowing it down... why?
  NSLog(@"SETTING IMAGE IS SLOW!");
  if ([OMBUser currentUser].image) {
    [userProfileImageView setImage: [OMBUser currentUser].image];
  }
  else {
    [[OMBUser currentUser] downloadImageFromImageURLWithCompletion: 
      ^(NSError *error) {
        if ([OMBUser currentUser].image)
          [userProfileImageView setImage: [OMBUser currentUser].image];
        else
          [userProfileImageView setImage: [UIImage imageNamed:
            @"default_user_image"]];
      }
    ]; 
  }
  [self setLabelAndTextFieldValues];
  [self adjustAboutLabelFrame];  
  [self adjustAboutTextViewFrame];
}

#pragma mark - Protocol

#pragma mark - Protocol UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
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
  [OMBUser currentUser].image = image;
  // NSString *encoded = [Base64 encode: imageData];
  OMBUserUploadImageConnection *connection = 
    [[OMBUserUploadImageConnection alloc] init];
  [connection start];
  // Update the small icon in the bottom right corner of the menu
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.container.accountView setImage: [OMBUser currentUser].image];
  // Hide the image picker
  [picker dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  cell.selectionStyle   = UITableViewCellSelectionStyleNone;
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      [cell.contentView addSubview: userProfileImageView];
    }
  }
  // The non editing table view
  if (tableView == self.table) {
    if (indexPath.row == 1) {
      [cell.contentView addSubview: userProfileView];
    }
  }
  // The editing table view
  else if (tableView == textFieldScroll) {

  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (section == 0) {
    int total = 1;
    // The non editing table view
    if (tableView == self.table) {
      // userProfileView
      total += 1;
      return total;
    }
    // The editing table view
    else if (tableView == textFieldScroll) {
      // first name, last name, school, email, phone, about
      total += 6;
      return total;
    }
  }
  else if (section == 1) {
    return 1;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  float height = 0;
  int padding  = 20;
  // User image
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      return userProfileImageView.frame.size.height;
    }
    // Not editing
    if (tableView == self.table) {
      // User profile view
      if (indexPath.row == 1) {
        height = padding + (22 * 3) + padding + 
          aboutLabel.frame.size.height + padding;
      }
    }
    // Editing
    else if (tableView == textFieldScroll) {
      // If this is the last row; the about text field
      if (indexPath.row == [self tableView: tableView 
        numberOfRowsInSection: indexPath.section] - 1) {
        height = aboutTextView.frame.size.height;
      }
      else {
        height = firstNameTextField.frame.size.height;
      }
    }
    return height;
  }
  else if (indexPath.section == 1) {
    if (tableView == textFieldScroll) {
      return padding + 216.0f;
    }
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  NSLog(@"TEXT FIELD DID BEGIN EDITING");
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [self.view endEditing: YES];
  return YES;
}

#pragma mark - Protocol UITextViewDelegate

- (void) textViewDidBeginEditing: (UITextView *) textView
{
  if (textView == aboutTextView) {
    [self.table scrollToRowAtIndexPath: 
      [NSIndexPath indexPathForRow: 5 inSection: 0] 
        atScrollPosition: UITableViewScrollPositionTop animated: YES];
  }
}

- (void) textViewDidChange: (UITextView *) textView
{
  [self adjustAboutTextViewFrame];
}

- (void) textViewDidEndEditing: (UITextView *) textView
{
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: YES];
}

- (BOOL) textViewShouldBeginEditing: (UITextView *) textView
{
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem animated: YES];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) adjustAboutLabelFrame
{
  CGRect rect = [aboutLabel.text boundingRectWithSize:
    CGSizeMake(aboutLabel.frame.size.width, 5000)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: aboutLabel.font } 
          context: nil];
  aboutLabel.frame = CGRectMake(aboutLabel.frame.origin.x, 
    aboutLabel.frame.origin.y, aboutLabel.frame.size.width,
      rect.size.height);
}

- (void) adjustAboutTextViewFrame
{
  CGRect rect = [aboutTextView.text boundingRectWithSize:
    CGSizeMake(aboutTextView.frame.size.width, 5000)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: aboutTextView.font }
          context: nil];
  [self.table beginUpdates];
  aboutTextView.frame = CGRectMake(aboutTextView.frame.origin.x,
    aboutTextView.frame.origin.y, aboutTextView.frame.size.width,
      // 10 + 1 is for the top and bottom insets
      rect.size.height + (11 * 2));
  [self.table endUpdates];
}

- (void) doneEditing
{
  [self.view endEditing: YES];
}

- (void) setLabelAndTextFieldValues
{
  // Labels
  aboutLabel.text    = [OMBUser currentUser].about;
  emailLabel.text    = [[OMBUser currentUser].email lowercaseString];
  fullNameLabel.text = [[OMBUser currentUser] fullName];
  phoneLabel.text    = [[OMBUser currentUser] phoneString];
  schoolLabel.text   = [OMBUser currentUser].school;
  // Text fields
  aboutTextView.text   = [OMBUser currentUser].about;
  emailTextField.text  = [[OMBUser currentUser].email lowercaseString];
  firstNameTextField.text = 
    [[OMBUser currentUser].firstName capitalizedString];
  lastNameTextField.text =
    [[OMBUser currentUser].lastName capitalizedString];
  phoneTextField.text  = [OMBUser currentUser].phone;
  schoolTextField.text = [OMBUser currentUser].school;  
}

- (void) showEdit
{
  isEditing = YES;
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: YES];
  [self.table beginUpdates];
  [self.table insertRowsAtIndexPaths:
    @[
      [NSIndexPath indexPathForRow: 3 inSection: 0],
      [NSIndexPath indexPathForRow: 4 inSection: 0],
      [NSIndexPath indexPathForRow: 5 inSection: 0]
    ] withRowAnimation: UITableViewRowAnimationFade];
  [UIView animateWithDuration: 0.1 animations: ^{
    uploadPhotoView.alpha = 1.0f;
    userProfileView.alpha = 0.0f;
    for (UIView *v in textFieldsArray) {
      v.alpha = 1.0f;
    }
  }];
  [self.table endUpdates];
  [self.table reloadData];
}

- (void) showSave
{
  [OMBUser currentUser].about     = aboutTextView.text;
  [OMBUser currentUser].email     = [emailTextField.text lowercaseString];
  [OMBUser currentUser].firstName = firstNameTextField.text;
  [OMBUser currentUser].lastName  = lastNameTextField.text;
  [OMBUser currentUser].phone     = phoneTextField.text;
  [OMBUser currentUser].school    = schoolTextField.text;

  [[[OMBUserUpdateProfileConnection alloc] init] start];

  [self setLabelAndTextFieldValues];
  [self adjustAboutLabelFrame];

  isEditing = NO;
  [self.navigationItem setRightBarButtonItem: editBarButtonItem animated: YES];
  [self.table beginUpdates];
  [UIView animateWithDuration: 0.1 animations: ^{
    uploadPhotoView.alpha = 0.0f;
    userProfileView.alpha = 1.0f;
    for (UIView *v in textFieldsArray) {
      v.alpha = 0.0f;
    }  }];
  [self.table deleteRowsAtIndexPaths:
    @[
      [NSIndexPath indexPathForRow: 3 inSection: 0],
      [NSIndexPath indexPathForRow: 4 inSection: 0],
      [NSIndexPath indexPathForRow: 5 inSection: 0]
    ] withRowAnimation: UITableViewRowAnimationFade];
  [self.table endUpdates];
  [self.view endEditing: YES];
}

- (void) uploadButtonSelected
{
  [uploadActionSheet showInView: self.view];
}

@end
