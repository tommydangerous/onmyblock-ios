//
//  OMBAccountProfileViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBAccountProfileViewController.h"

#import "OMBCenteredImageView.h"
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

  self.screenName = [NSString stringWithFormat: 
    @"Account Profile - User ID: %i", [OMBUser currentUser].uid];
  self.title = @"Profile";

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
    CGRectMake(0.0f, 0.0f, screenWidth, (screenHeight * 0.5))];

  // User profile view
  int padding = 20;
  userProfileView = [[UIView alloc] init];
  userProfileView.frame = CGRectMake(0, padding, screenWidth, 
    24 + (padding * 0.5) + (22 * 3));
  // Labels
  // First name, last name
  fullNameLabel = [[UILabel alloc] init];
  fullNameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 18];
  fullNameLabel.frame = CGRectMake(padding, 0, screenWidth - (padding * 2), 24);
  fullNameLabel.textColor = [UIColor textColor];
  [labelsArray addObject: fullNameLabel];
  [userProfileView addSubview: fullNameLabel];
  // School
  schoolLabel = [[UILabel alloc] init];  
  schoolLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  schoolLabel.frame = CGRectMake(fullNameLabel.frame.origin.x,
    fullNameLabel.frame.origin.y + fullNameLabel.frame.size.height + 
    (padding * 0.5),
      fullNameLabel.frame.size.width, 22);
  schoolLabel.textColor = fullNameLabel.textColor;
  [labelsArray addObject: schoolLabel];
  [userProfileView addSubview: schoolLabel];
  // Email
  emailLabel = [[UILabel alloc] init];
  emailLabel.font = schoolLabel.font;
  emailLabel.frame = CGRectMake(schoolLabel.frame.origin.x,
    schoolLabel.frame.origin.y + schoolLabel.frame.size.height,
      schoolLabel.frame.size.width, schoolLabel.frame.size.height);
  emailLabel.textColor = fullNameLabel.textColor;
  [labelsArray addObject: emailLabel];
  [userProfileView addSubview: emailLabel];
  // Phone
  phoneLabel = [[UILabel alloc] init];
  phoneLabel.font = emailLabel.font;
  phoneLabel.frame = CGRectMake(emailLabel.frame.origin.x,
    emailLabel.frame.origin.y + emailLabel.frame.size.height,
      emailLabel.frame.size.width, emailLabel.frame.size.height);
  phoneLabel.textColor = fullNameLabel.textColor;
  [labelsArray addObject: phoneLabel];
  [userProfileView addSubview: phoneLabel];
  // About
  aboutLabel = [[UILabel alloc] init];
  aboutLabel.font = schoolLabel.font;
  aboutLabel.frame = CGRectMake(schoolLabel.frame.origin.x,
    padding, schoolLabel.frame.size.width, 0);
  aboutLabel.numberOfLines = 0;
  aboutLabel.textColor = schoolLabel.textColor;
  [labelsArray addObject: aboutLabel];

  // Text fields
  userTextFieldView = [[UIView alloc] init];
  userTextFieldView.alpha = 0.0f;
  userTextFieldView.frame = CGRectMake(userProfileView.frame.origin.x,
    userProfileView.frame.origin.y, userProfileView.frame.size.width,
      // 44 is the height of the text fields, 20 is the spacing in between
      (44 * 4) + (20 * 3));
  // First name
  firstNameTextField = [[TextFieldPadding alloc] init];
  firstNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  firstNameTextField.backgroundColor = [UIColor grayUltraLight];
  firstNameTextField.delegate = self;
  firstNameTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  firstNameTextField.frame = CGRectMake(padding, 0, 
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
  [userTextFieldView addSubview: firstNameTextField];
  // Last name
  lastNameTextField = [[TextFieldPadding alloc] init];
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
  [userTextFieldView addSubview: lastNameTextField];
  // School
  schoolTextField = [[TextFieldPadding alloc] init];
  schoolTextField.autocorrectionType = firstNameTextField.autocorrectionType;
  schoolTextField.backgroundColor = firstNameTextField.backgroundColor;
  schoolTextField.delegate = firstNameTextField.delegate;
  schoolTextField.font = firstNameTextField.font;
  schoolTextField.frame = CGRectMake(padding, 
    lastNameTextField.frame.origin.y + 
    lastNameTextField.frame.size.height + padding, 
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
  [userTextFieldView addSubview: schoolTextField];
  // Email
  emailTextField = [[TextFieldPadding alloc] init];
  emailTextField.autocorrectionType = firstNameTextField.autocorrectionType;
  emailTextField.backgroundColor = firstNameTextField.backgroundColor;
  emailTextField.delegate = firstNameTextField.delegate;
  emailTextField.font = firstNameTextField.font;
  emailTextField.frame = CGRectMake(padding, 
    schoolTextField.frame.origin.y + 
    schoolTextField.frame.size.height + padding, 
      schoolTextField.frame.size.width, firstNameTextField.frame.size.height);
  emailTextField.layer.borderColor = firstNameTextField.layer.borderColor;
  emailTextField.layer.borderWidth = firstNameTextField.layer.borderWidth;
  emailTextField.layer.cornerRadius = firstNameTextField.layer.cornerRadius;
  emailTextField.paddingX = firstNameTextField.paddingX;
  emailTextField.paddingY = firstNameTextField.paddingY;
  emailTextField.placeholder = @"Email";
  emailTextField.returnKeyType = firstNameTextField.returnKeyType;
  emailTextField.textColor = firstNameTextField.textColor;
  [textFieldsArray addObject: emailTextField];
  [userTextFieldView addSubview: emailTextField];
  // Phone
  phoneTextField = [[TextFieldPadding alloc] init];
  phoneTextField.autocorrectionType = firstNameTextField.autocorrectionType;
  phoneTextField.backgroundColor = firstNameTextField.backgroundColor;
  phoneTextField.delegate = firstNameTextField.delegate;
  phoneTextField.font = firstNameTextField.font;
  phoneTextField.frame = CGRectMake(padding, 
    emailTextField.frame.origin.y + 
    emailTextField.frame.size.height + padding, 
      emailTextField.frame.size.width, firstNameTextField.frame.size.height);
  phoneTextField.layer.borderColor = firstNameTextField.layer.borderColor;
  phoneTextField.layer.borderWidth = firstNameTextField.layer.borderWidth;
  phoneTextField.layer.cornerRadius = firstNameTextField.layer.cornerRadius;
  phoneTextField.paddingX = firstNameTextField.paddingX;
  phoneTextField.paddingY = firstNameTextField.paddingY;
  phoneTextField.placeholder = @"Phone";
  phoneTextField.returnKeyType = firstNameTextField.returnKeyType;
  phoneTextField.textColor = firstNameTextField.textColor;
  [textFieldsArray addObject: phoneTextField];
  [userTextFieldView addSubview: phoneTextField];

  // About text view
  aboutTextView = [[UITextView alloc] init];
  aboutTextView.alpha = 0.0f;
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
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  // Load the user's image
  if ([OMBUser currentUser].image) {
    [userProfileImageView setImage: [OMBUser currentUser].image];
  }
  else {
    [[OMBUser currentUser] downloadImageFromImageURLWithCompletion: 
      ^(NSError *error) {
        [userProfileImageView setImage: [OMBUser currentUser].image];
      }
    ]; 
  }
  fullNameLabel.text = [[OMBUser currentUser] fullName];
  schoolLabel.text   = [OMBUser currentUser].school;
  emailLabel.text    = [[OMBUser currentUser].email lowercaseString];
  phoneLabel.text    = [[OMBUser currentUser] phoneString];
  [self adjustAboutLabelFrame];

  // Text fields
  firstNameTextField.text = 
    [[OMBUser currentUser].firstName capitalizedString];
  lastNameTextField.text =
    [[OMBUser currentUser].lastName capitalizedString];
  schoolTextField.text = [OMBUser currentUser].school;
  emailTextField.text  = [[OMBUser currentUser].email lowercaseString];
  phoneTextField.text  = [OMBUser currentUser].phone;
  aboutTextView.text   = [OMBUser currentUser].about;
  [self adjustAboutTextViewFrame];
}

#pragma mark - Protocol

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
    else if (indexPath.row == 1) {
      [cell.contentView addSubview: userProfileView];
      [cell.contentView addSubview: userTextFieldView];
    }
    else if (indexPath.row == 2) {
      [cell.contentView addSubview: aboutLabel];
      [cell.contentView addSubview: aboutTextView];
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (section == 0) {
    return 3;
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
  int padding = 20;
  // User image
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      return userProfileImageView.frame.size.height;
    }
    else if (indexPath.row == 1) {
      // 20 for the spacing between the user profile image and info
      float height = padding;
      if (isEditing) {
        height += userTextFieldView.frame.size.height;
      }
      else {
        height += userProfileView.frame.size.height;
      }
      return height;
    }
    else if (indexPath.row == 2) {
      float height = padding * 2;
      if (isEditing) {
        height += aboutTextView.frame.size.height;
      }
      else {
        height += aboutLabel.frame.size.height;
      }
      return height;
    }
  }
  else if (indexPath.section == 1) {
    if (isEditing) {
      return 216.0f;
    }
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  int row = 0;
  if (textField == firstNameTextField || textField == lastNameTextField) {
    row = 1;
  }
  else if (textField == schoolTextField) {
    row = 2;
  }
  else if (textField == emailTextField) {
    row = 3;
  }
  else if (textField == phoneTextField) {
    row = 4;
  }
  if (row > 0) {
    [self.table scrollToRowAtIndexPath: 
      [NSIndexPath indexPathForRow: row inSection: 0] 
        atScrollPosition: UITableViewScrollPositionTop animated: YES];
  }
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [self.view endEditing: YES];
  return YES;
}

#pragma mark - Protocol UITextViewDelegate

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
  aboutLabel.text  = [OMBUser currentUser].about;
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

- (void) showEdit
{
  isEditing = YES;
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: YES];
  [self.table beginUpdates];
  [UIView animateWithDuration: 0.25 animations: ^{
    // User profile info
    userProfileView.alpha   = 0.0f;
    userTextFieldView.alpha = 1.0f;
    // About
    aboutLabel.alpha    = 0.0f;
    aboutTextView.alpha = 1.0f;
  }];
  [self.table endUpdates];
}

- (void) showSave
{
  isEditing = NO;
  [self.navigationItem setRightBarButtonItem: editBarButtonItem animated: YES];
  [self.table beginUpdates];
  [UIView animateWithDuration: 0.25 animations: ^{
    userProfileView.alpha   = 1.0f;
    userTextFieldView.alpha = 0.0f;
    // About
    aboutLabel.alpha    = 1.0f;
    aboutTextView.alpha = 0.0f;
  }];
  [self.table endUpdates];
  [self.view endEditing: YES];
}

@end
