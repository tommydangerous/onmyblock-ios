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

  // Text field scroll
  textFieldTableView = [[UITableView alloc] initWithFrame: screen
    style: UITableViewStylePlain];
  textFieldTableView.alpha = 0.0f;
  textFieldTableView.alwaysBounceVertical = self.table.alwaysBounceVertical;
  textFieldTableView.backgroundColor = self.table.backgroundColor;
  // 20 (the status bar height) + 44 (the navigation bar height)
  textFieldTableView.contentInset = UIEdgeInsetsMake(20 + 44, 0, 0, 0);
  textFieldTableView.dataSource = self;
  textFieldTableView.delegate = self;
  textFieldTableView.separatorColor = [UIColor grayLight];
  textFieldTableView.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  textFieldTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  textFieldTableView.showsVerticalScrollIndicator = NO;
  [self.view addSubview: textFieldTableView];

  // User profile image
  userProfileImageView = [[OMBCenteredImageView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, screenWidth, (screenHeight * 0.4f))];
  userProfileImageView.backgroundColor = [UIColor blackColor];
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
  uploadPhotoView.layer.cornerRadius = uploadPhotoView.frame.size.height * 0.5f;
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
  // [userProfileView addSubview: schoolLabel];
  [labelsArray addObject: schoolLabel];
  // Email
  emailLabel = [[UILabel alloc] init];
  emailLabel.font = schoolLabel.font;
  emailLabel.frame = CGRectMake(schoolLabel.frame.origin.x,
    schoolLabel.frame.origin.y + schoolLabel.frame.size.height,
      schoolLabel.frame.size.width, schoolLabel.frame.size.height);
  emailLabel.textColor = schoolLabel.textColor;
  // [userProfileView addSubview: emailLabel];
  [labelsArray addObject: emailLabel];
  // Phone
  phoneLabel = [[UILabel alloc] init];
  phoneLabel.font = emailLabel.font;
  phoneLabel.frame = CGRectMake(emailLabel.frame.origin.x,
    emailLabel.frame.origin.y + emailLabel.frame.size.height,
      emailLabel.frame.size.width, emailLabel.frame.size.height);
  phoneLabel.textColor = schoolLabel.textColor;
  // [userProfileView addSubview: phoneLabel];
  [labelsArray addObject: phoneLabel];
  // About
  aboutLabel = [[UILabel alloc] init];
  aboutLabel.font = schoolLabel.font;
  aboutLabel.frame = CGRectMake(schoolLabel.frame.origin.x,
    (padding * 2) + phoneLabel.frame.origin.y + phoneLabel.frame.size.height, 
      schoolLabel.frame.size.width, 0);
  aboutLabel.numberOfLines = 0;
  aboutLabel.textColor = schoolLabel.textColor;
  [labelsArray addObject: aboutLabel];

  // Text fields
  firstNameTextField = [[TextFieldPadding alloc] init];
  lastNameTextField  = [[TextFieldPadding alloc] init];
  schoolTextField    = [[TextFieldPadding alloc] init];
  emailTextField     = [[TextFieldPadding alloc] init];
  phoneTextField     = [[TextFieldPadding alloc] init];
  textFieldsArray = @[
    firstNameTextField,
    lastNameTextField,
    schoolTextField,
    emailTextField,
    phoneTextField
  ];
  for (TextFieldPadding *textField in textFieldsArray) {
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.delegate = self;
    textField.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
    textField.frame = CGRectMake(0, 0, screenWidth, 44);
    textField.returnKeyType = UIReturnKeyDone;
    textField.textColor = [UIColor textColor];
  }
  emailTextField.keyboardType       = UIKeyboardTypeEmailAddress;
  phoneTextField.keyboardAppearance = UIKeyboardAppearanceDark;
  phoneTextField.keyboardType       = UIKeyboardTypePhonePad;
  // About text view
  aboutTextView = [[UITextView alloc] init];
  aboutTextView.autocorrectionType = UITextAutocorrectionTypeYes;
  aboutTextView.contentInset = UIEdgeInsetsMake(0, -2, 0, 0);
  aboutTextView.delegate = self;
  aboutTextView.font = firstNameTextField.font;
  aboutTextView.frame = CGRectMake(padding, padding * 0.5, 
    screenWidth - (padding * 2), 0);
  aboutTextView.keyboardAppearance = UIKeyboardAppearanceLight;
  aboutTextView.scrollEnabled = NO;
  aboutTextView.showsVerticalScrollIndicator = NO;
  aboutTextView.textColor = firstNameTextField.textColor;
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
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
            @"default_user_image.png"]];
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
  // Image picker controller
  imagePickerController = [[UIImagePickerController alloc] init];
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
      cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
      [cell.contentView addSubview: userProfileImageView];
    }
  }
  else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
    }
  }
  // The non editing table view
  if (tableView == self.table) {
    if (indexPath.row == 1) {
      for (UIView *v in labelsArray) {
        [cell.contentView addSubview: v];
      }
      CGRect screen = [[UIScreen mainScreen] bounds];
      CALayer *borderTop = [CALayer layer];
      float padding = 20.0f;
      borderTop.backgroundColor = [UIColor grayLight].CGColor;
      borderTop.frame = CGRectMake(padding, 
        phoneLabel.frame.origin.y + phoneLabel.frame.size.height + padding, 
          screen.size.width - padding, 0.5f);
      [cell.contentView.layer addSublayer: borderTop];
    }
  }
  // The editing table view
  else if (tableView == textFieldTableView) {
    CGRect screen     = [[UIScreen mainScreen] bounds];
    float screenWidth = screen.size.width;
    float padding = 20.0f;
    UILabel *label = [[UILabel alloc] init];
    label.font = firstNameTextField.font;
    label.textColor = firstNameTextField.textColor;
    CGRect rect = [@"Last name" boundingRectWithSize:
      CGSizeMake(320, firstNameTextField.frame.size.height)
        options: NSStringDrawingUsesLineFragmentOrigin
          attributes: @{ NSFontAttributeName: label.font }
            context: nil];
    label.frame = CGRectMake(padding, 0, rect.size.width,
      firstNameTextField.frame.size.height);
    CGRect rect2 = firstNameTextField.frame;
    rect2.origin.x = label.frame.origin.x + label.frame.size.width + padding;
    rect2.size.width = screenWidth - 
      (padding + label.frame.size.width + padding + padding);
    // First name
    if (indexPath.row == 1) {
      label.text = @"First name";
      firstNameTextField.frame = rect2;
      [cell.contentView addSubview: firstNameTextField];
    }
    else if (indexPath.row == 2) {
      label.text = @"Last name";
      lastNameTextField.frame = rect2;
      [cell.contentView addSubview: lastNameTextField];
    }
    else if (indexPath.row == 3) {
      label.text = @"School";
      schoolTextField.frame = rect2;
      [cell.contentView addSubview: schoolTextField];
    }
    else if (indexPath.row == 4) {
      label.text = @"Email";
      emailTextField.frame = rect2;
      [cell.contentView addSubview: emailTextField];
    }
    else if (indexPath.row == 5) {
      label.text = @"Phone";
      phoneTextField.frame = rect2;
      [cell.contentView addSubview: phoneTextField];
    }
    else if (indexPath.row == 6) {
      [cell.contentView addSubview: aboutTextView];
    }
    if (indexPath.row > 0 && indexPath.row < 6) {
      [cell.contentView addSubview: label];
    }
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
    else if (tableView == textFieldTableView) {
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
  if (indexPath.section == 0) {
    // User image
    if (indexPath.row == 0) {
      return userProfileImageView.frame.size.height;
    }
    // Not editing
    if (tableView == self.table) {
      // User profile view
      if (indexPath.row == 1) {
        height = aboutLabel.frame.origin.y + 
          aboutLabel.frame.size.height + padding;
      }
    }
    // Editing
    else if (tableView == textFieldTableView) {
      // If this is the last row; the about text field
      if (indexPath.row == [self tableView: tableView 
        numberOfRowsInSection: indexPath.section] - 1) {
        height = padding + aboutTextView.frame.size.height;
      }
      // If this is not the first or last row
      else {
        height = firstNameTextField.frame.size.height;
      }
    }
    return height;
  }
  else if (indexPath.section == 1) {
    if (tableView == textFieldTableView) {
      return 216.0f;
    }
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  int row = [textFieldsArray indexOfObject: textField] + 1;
  [textFieldTableView scrollToRowAtIndexPath: 
    [NSIndexPath indexPathForRow: row inSection: 0] 
      atScrollPosition: UITableViewScrollPositionTop animated: YES];
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
    int row = [self tableView: textFieldTableView
      numberOfRowsInSection: 0] - 1;
    [textFieldTableView scrollToRowAtIndexPath: 
      [NSIndexPath indexPathForRow: row inSection: 0] 
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
    CGSizeMake(aboutTextView.frame.size.width, 50000)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: aboutTextView.font }
          context: nil];
  [textFieldTableView beginUpdates];
  aboutTextView.frame = CGRectMake(aboutTextView.frame.origin.x,
    aboutTextView.frame.origin.y, aboutTextView.frame.size.width,
      8 + rect.size.height + 8);
  [textFieldTableView endUpdates];
}

- (void) doneEditing
{
  [self.view endEditing: YES];
}

- (void) reloadTable
{
  for (UITableView *tableView in @[self.table, textFieldTableView]) {
    for (int i = 0; i < [self tableView: tableView 
      numberOfRowsInSection: 0]; i++) {
      [tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: i
        inSection: 0]] withRowAnimation: UITableViewRowAnimationNone];
    }
  }
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
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: YES];
  // [textFieldTableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: 0
  //   inSection: 0]] withRowAnimation: UITableViewRowAnimationNone];
  [textFieldTableView reloadData];
  self.table.alpha         = 0.0f;
  textFieldTableView.alpha = 1.0f;
  uploadPhotoView.alpha    = 1.0f;
}

- (void) showSave
{
  // Set the user's values
  [OMBUser currentUser].about     = aboutTextView.text;
  [OMBUser currentUser].email     = [emailTextField.text lowercaseString];
  [OMBUser currentUser].firstName = firstNameTextField.text;
  [OMBUser currentUser].lastName  = lastNameTextField.text;
  [OMBUser currentUser].phone     = phoneTextField.text;
  [OMBUser currentUser].school    = schoolTextField.text;
  // Save to web server
  [[[OMBUserUpdateProfileConnection alloc] init] start];

  [self setLabelAndTextFieldValues];
  [self adjustAboutLabelFrame];

  [self.navigationItem setRightBarButtonItem: editBarButtonItem animated: YES];
  // [self.table reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: 0
  //   inSection: 0]] withRowAnimation: UITableViewRowAnimationNone];
  [self.table reloadData];
  self.table.alpha         = 1.0f;
  textFieldTableView.alpha = 0.0f;
  uploadPhotoView.alpha    = 0.0f;
  [self.view endEditing: YES];
}

- (void) uploadButtonSelected
{
  [uploadActionSheet showInView: self.view];
}

@end
