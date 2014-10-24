//
//  OMBEditProfileViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBEditProfileViewController.h"

#import "CustomLoading.h"
#import "NSString+Extensions.h"
#import "OMBBlurView.h"
#import "OMBCenteredImageView.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBUser.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBEditProfileViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Edit Profile View Controller";
  self.title      = @"Edit Profile";

  CGRect rect = [@"First name" boundingRectWithSize:
    CGSizeMake(9999, OMBStandardHeight) font: [UIFont normalTextFontBold]];
  sizeForLabelTextFieldCell = rect.size;

  user = object;

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillShow:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillHide:)
      name: UIKeyboardWillHideNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(progressConnection:)
      name: @"progressConnection" object:nil];
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  
  [[CustomLoading getInstance] clearInstance];
  
  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
    style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];
  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
    style: UIBarButtonItemStylePlain target: self action: @selector(done)];
  [doneBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Save"
    style: UIBarButtonItemStylePlain target: self action: @selector(save)];
  [saveBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];

  self.navigationItem.leftBarButtonItem  = cancelBarButtonItem;
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  [self setupForTable];

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = OMBPadding;

  self.table.backgroundColor = [UIColor clearColor];
  self.table.frame = CGRectMake(0.0f, OMBPadding + OMBStandardHeight,
    screenWidth, screen.size.height - (OMBPadding + OMBStandardHeight));

  backgroundBlurView = [[OMBBlurView alloc] initWithFrame: self.view.frame];
  backgroundBlurView.blurRadius = 20.0f;
  backgroundBlurView.tintColor = [UIColor colorWithWhite: 1.0f alpha: 0.5f];
  [self.view insertSubview: backgroundBlurView belowSubview: self.table];

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
  aboutTextViewPlaceholder.text = @"Talk about how cool you are...";
  aboutTextViewPlaceholder.textColor = [UIColor grayMedium];
  [aboutTextView addSubview: aboutTextViewPlaceholder];

  // Action sheet
  uploadActionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self 
    cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil 
      otherButtonTitles: @"Take Photo", @"Choose Existing", nil];
  [self.view addSubview: uploadActionSheet];

  // Image
  CGFloat imageSize = OMBStandardHeight * 3.0f;
  userImageView = [[OMBCenteredImageView alloc] initWithFrame: 
    CGRectMake((screenWidth - imageSize) * 0.5f, OMBPadding, 
      imageSize, imageSize)];
  userImageView.layer.borderWidth = 1.0f;
  userImageView.layer.cornerRadius = userImageView.frame.size.width * 0.5f;
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];

  [self.table setContentOffset: CGPointZero animated: NO];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [backgroundBlurView refreshWithImage: user.image];
  [userImageView setImage: [OMBUser currentUser].image];

  valueDictionary = [NSMutableDictionary dictionaryWithDictionary: @{
    @"about":     user.about ? user.about : @"",
    @"email":     user.email ? user.email : @"",
    @"firstName": user.firstName ? user.firstName: @"",
    @"lastName":  user.lastName ? user.lastName : @"",
    @"phone":     user.phone ? user.phone : @"",
    @"school":    user.school ? user.school : @""
  }];
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

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Everything else
  // Spacing
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *EmptyCellID = @"EmptyCellID";
  UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:
    EmptyCellID];
  if (!emptyCell)
    emptyCell = [[UITableViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: EmptyCellID];
  emptyCell.backgroundColor = [UIColor clearColor];
  // Main
  if (indexPath.section == OMBEditProfileSectionMain) {
    // Image
    if (indexPath.row == OMBEditProfileSectionMainRowImage) {
      static NSString *ImageCellID = @"ImageCellID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        ImageCellID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: ImageCellID];
        [userImageView removeFromSuperview];
        [cell.contentView addSubview: userImageView];
        // Label
        UILabel *label = [UILabel new];
        label.font = [UIFont normalTextFontBold];
        label.frame = CGRectMake(0.0f, 
          userImageView.frame.origin.y + userImageView.frame.size.height, 
            tableView.frame.size.width, OMBStandardHeight);
        label.text = @"Edit Profile Picture";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor textColor];
        [cell.contentView addSubview: label];
      }
      cell.backgroundColor = [UIColor clearColor];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.separatorInset = UIEdgeInsetsMake(0.0f,
        tableView.frame.size.width, 0.0f, 0.0f);
      return cell;
    }
    // About
    else if (indexPath.row == OMBEditProfileSectionMainRowAbout) {
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
      cell.separatorInset = UIEdgeInsetsMake(0.0f,
        tableView.frame.size.width, 0.0f, 0.0f);
      return cell;
    }
    else {
      static NSString *LabelTextCellID = @"LabelTextCellID";
      OMBLabelTextFieldCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: LabelTextCellID];
      if (!cell) {
        cell = [[OMBLabelTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: LabelTextCellID];
        [cell setFrameUsingSize: sizeForLabelTextFieldCell];
      }
      // cell.backgroundColor = transparentWhite;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.textField.textColor = [UIColor blueDark];
      cell.textFieldLabel.font = [UIFont normalTextFontBold];
      NSString *key;
      NSString *labelString;
      // First name
      if (indexPath.row == OMBEditProfileSectionMainRowFirstName) {
        key         = @"firstName";
        labelString = @"First name";
      }
      // Last name
      else if (indexPath.row == OMBEditProfileSectionMainRowLastName) {
        key         = @"lastName";
        labelString = @"Last name";
      }
      // School
      else if (indexPath.row == OMBEditProfileSectionMainRowSchool) {
        key         = @"school";
        labelString = @"School";
      }
      // Email
      else if (indexPath.row == OMBEditProfileSectionMainRowEmail) {
        key         = @"email";
        labelString = @"Email";
      }
      // Phone
      else if (indexPath.row == OMBEditProfileSectionMainRowPhone) {
        key         = @"phone";
        labelString = @"Phone";
      }
      cell.textField.delegate  = self;
      cell.textField.indexPath = indexPath;
      cell.textField.placeholder = [labelString lowercaseString];
      cell.textField.text = [valueDictionary objectForKey: key];
      cell.textFieldLabel.text = labelString;
      [cell.textField addTarget: self action: @selector(textFieldDidChange:)
        forControlEvents: UIControlEventEditingChanged];
      return cell;
    }
  }
  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Main
  if (section == OMBEditProfileSectionMain) {
    // Image
    // First name
    // Last name
    // School
    // Email
    // Phone
    // About
    return 7;
  }
  // Spacing
  else if (section == OMBEditProfileSectionSpacing) {
    return 1;
  }
  return 0;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Main
  if (indexPath.section == OMBEditProfileSectionMain) {
    // Image
    if (indexPath.row == OMBEditProfileSectionMainRowImage) {
      return OMBPadding + (OMBStandardHeight * 3.0f) + 
        OMBStandardHeight + OMBPadding;
    }
    // About
    else if (indexPath.row == OMBEditProfileSectionMainRowAbout) {
      return OMBPadding + (22.0f * 5) + OMBPadding;
    }
    return [OMBLabelTextFieldCell heightForCell];
  }
  // Spacing
  else if (indexPath.section == OMBEditProfileSectionSpacing) {
    if (isEditing) {
      return 216.0f;
    }
  }
  return 0.0f;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Main
  if (indexPath.section == OMBEditProfileSectionMain) {
    // Image
    if (indexPath.row == OMBEditProfileSectionMainRowImage) {
      [uploadActionSheet showInView: self.view];
    }
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (TextFieldPadding *) textField
{
  isEditing = YES;
  [self.table beginUpdates];
  [self.table endUpdates];
  [self.table scrollToRowAtIndexPath: textField.indexPath
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [self done];
  return YES;
}

#pragma mark - Protocol UITextViewDelegate

- (void) textViewDidBeginEditing: (UITextView *) textView
{
  isEditing = YES;
  [self.table beginUpdates];
  [self.table endUpdates];
  [self.table scrollToRowAtIndexPath: 
    [NSIndexPath indexPathForRow: OMBEditProfileSectionMainRowAbout
      inSection: OMBEditProfileSectionMain]
        atScrollPosition: UITableViewScrollPositionTop animated: YES];
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

- (void) cancel
{
  [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) done
{
  [self.view endEditing: YES];
  isEditing = NO;
  [self.table beginUpdates];
  [self.table endUpdates];
}

- (void) keyboardWillHide: (NSNotification *) notification
{
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: YES];
}

- (void) keyboardWillShow: (NSNotification *) notification
{
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem animated: YES];
}

- (void)progressConnection:(NSNotification *)notification{
  
  float value = ([[notification object] floatValue]);
  
  CustomLoading *custom = [CustomLoading getInstance];
  //editBarButtonItem.enabled = NO;
  
  if(value == 1.0){
    custom.numImages--;
    [custom stopAnimatingWithView:self.view];
      //editBarButtonItem.enabled = YES;
  }else{
    [custom startAnimatingWithProgress:(int)(value * 25) withView:self.view];
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
        [self cancel];
      }
      else {
        [self showAlertViewWithError: error];
      }
      [[self appDelegate].container stopSpinning];
    }
  ];
  [[self appDelegate].container startSpinning];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  if (textField.indexPath.row == OMBEditProfileSectionMainRowFirstName) {
    if ([textField.text length])
      [valueDictionary setObject: textField.text forKey: @"firstName"];
  }
  else if (textField.indexPath.row == OMBEditProfileSectionMainRowLastName) {
    if ([textField.text length])
      [valueDictionary setObject: textField.text forKey: @"lastName"]; 
  }
  else if (textField.indexPath.row == OMBEditProfileSectionMainRowSchool) {
    [valueDictionary setObject: textField.text forKey: @"school"]; 
  }
  else if (textField.indexPath.row == OMBEditProfileSectionMainRowEmail) {
    [valueDictionary setObject: textField.text forKey: @"email"]; 
  }
  else if (textField.indexPath.row == OMBEditProfileSectionMainRowPhone) {
    [valueDictionary setObject: textField.text forKey: @"phone"];
  }
}

@end
