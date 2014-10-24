//
//  OMBHomebaseRenterAddRoommateFromEmailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterAddRoommateFromEmailViewController.h"

#import "NSString+Extensions.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"

@implementation OMBHomebaseRenterAddRoommateFromEmailViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Add From Email";

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillShow:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillHide:)
      name: UIKeyboardWillHideNotification object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setupForTable];

  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
    style: UIBarButtonItemStylePlain target: self
      action: @selector(done)];
  [doneBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];

  inviteBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Invite"
    style: UIBarButtonItemStylePlain target: self
      action: @selector(invite)];
  [inviteBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  inviteBarButtonItem.enabled = NO;
  self.navigationItem.rightBarButtonItem = inviteBarButtonItem;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth    = screen.size.width;
  CGFloat padding        = 20.0f;
  CGFloat standardHeight = 44.0f;

  emailTextField = [[TextFieldPadding alloc] init];
  emailTextField.backgroundColor = [UIColor whiteColor];
  emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  emailTextField.delegate = self;
  emailTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  emailTextField.frame = CGRectMake(padding, padding, 
    screenWidth - (padding * 2), standardHeight);
  emailTextField.layer.borderColor = [UIColor grayLight].CGColor;
  emailTextField.layer.borderWidth = 1.0f;
  emailTextField.layer.cornerRadius = 5.0f;
  emailTextField.paddingX = padding * 0.5f;
  emailTextField.placeholder = @"Roommate's email";
  [emailTextField addTarget: self action: @selector(textFieldDidChange:)
    forControlEvents: UIControlEventEditingChanged];

  messageTextView = [UITextView new];
  messageTextView.backgroundColor = emailTextField.backgroundColor;
  messageTextView.delegate = self;
  messageTextView.font = emailTextField.font;
  messageTextView.frame = CGRectMake(padding, padding, 
    emailTextField.frame.size.width, screen.size.height - 
      (padding + standardHeight + padding + 
      emailTextField.frame.size.height + padding + padding + padding));
  messageTextView.layer.borderColor = emailTextField.layer.borderColor;
  messageTextView.layer.borderWidth = emailTextField.layer.borderWidth;
  messageTextView.layer.cornerRadius = emailTextField.layer.cornerRadius;
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Email text field, Message text view
  // Spacing
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  if (indexPath.section == 0) {
    // Email text field
    if (indexPath.row == 0) {
      [emailTextField removeFromSuperview];
      [cell.contentView addSubview: emailTextField];
    }
    // Message text view
    else if (indexPath.row == 1) {
      [messageTextView removeFromSuperview];
      [cell.contentView addSubview: messageTextView];
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Email, message
  if (section == 0) {
    return 2;
  }
  // Spacing
  else if (section == 1) {
    return 1;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat padding        = 20.0f;
  // CGFloat standardHeight = 44.0f;
  // Email, message
  if (indexPath.section == 0) {
    // Email
    if (indexPath.row == 0) {
      return padding + emailTextField.frame.size.height + padding;
    }
    // Message
    else if (indexPath.row == 1) {
      return padding + messageTextView.frame.size.height + padding;
    }
  }
  // Spacing
  else if (indexPath.section == 1) {
    if (isEditing) {
      return 216.0f;
    }
  } 
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) done
{
  [self.view endEditing: YES];
}

- (void) keyboardWillHide: (NSNotification *) notification
{
  isEditing = NO;
  [self.table beginUpdates];
  [self.table endUpdates];
  [self.navigationItem setRightBarButtonItem: inviteBarButtonItem 
    animated: YES];
}

- (void) keyboardWillShow: (NSNotification *) notification
{
  isEditing = YES;
  [self.table beginUpdates];
  [self.table endUpdates];
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem animated: YES];
}

- (void) invite
{
  NSLog(@"INVITE");
  [self.navigationController popViewControllerAnimated: YES]; 
}

- (void) textFieldDidChange: (UITextField *) textField
{
  NSInteger length = [[textField.text stripWhiteSpace] length];
  if (length) {
    inviteBarButtonItem.enabled = YES;
  }
  else {
    inviteBarButtonItem.enabled = NO;
  }

}

@end
