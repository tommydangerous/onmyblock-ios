//
//  OMBFinishListingAddressViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingAddressViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "OMBLabelTextFieldCell.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBFinishListingAddressViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  self.screenName = self.title = @"Location";

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(makeTableViewSmaller:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(makeTableViewLarger:)
      name: UIKeyboardWillHideNotification object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;

  // Map  
  map = [[MKMapView alloc] init];
  map.delegate = self;
  map.frame = CGRectMake(0.0f, 0.0f, screenWidth, screen.size.height);
  map.mapType = MKMapTypeStandard;
  [self.view addSubview: map];

  addressTextFieldView = [[AMBlurView alloc] init];
  addressTextFieldView.frame = CGRectMake(0.0f, 20.0f + 44.0f, 
    screenWidth, padding + 44.0f + padding);
  [self.view addSubview: addressTextFieldView];
  // Bottom border
  CALayer *addressTextFieldViewBottomBorder = [CALayer layer];
  addressTextFieldViewBottomBorder.backgroundColor = 
    [UIColor grayLight].CGColor;
  addressTextFieldViewBottomBorder.frame = CGRectMake(0.0f, 
    addressTextFieldView.frame.size.height - 1.0f, 
      addressTextFieldView.frame.size.width, 1.0f);
  [addressTextFieldView.layer addSublayer: 
    addressTextFieldViewBottomBorder];
  // Address text field when searching for location
  addressTextField = [[TextFieldPadding alloc] init];
  addressTextField.backgroundColor = [UIColor grayVeryLight];
  addressTextField.delegate = self;
  addressTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  addressTextField.frame = CGRectMake(padding, padding, 
    addressTextFieldView.frame.size.width - (padding * 2), 44.0f);
  addressTextField.layer.cornerRadius = 2.0f;
  addressTextField.paddingX = padding * 0.5f;
  addressTextField.placeholderColor = [UIColor grayMedium];
  addressTextField.placeholder = @"Address";
  addressTextField.returnKeyType = UIReturnKeyDone;
  addressTextField.rightViewMode = UITextFieldViewModeAlways;
  addressTextField.textColor = [UIColor textColor];
  [addressTextField addTarget: self action: @selector(textFieldDidChange:)
    forControlEvents: UIControlEventEditingChanged];
  [addressTextFieldView addSubview: addressTextField];
  // Current location button
  currentLocationButton = [UIButton new];
  currentLocationButton.frame = CGRectMake(0.0f, 0.0f,
    addressTextField.frame.size.height, addressTextField.frame.size.height);
  UIImage *currentLocationButtonImage = [UIImage image: [UIImage imageNamed: 
    @"gps_cursor_blue.png"] size: CGSizeMake(padding, padding)];
  [currentLocationButton setImage: currentLocationButtonImage 
    forState: UIControlStateNormal];
  addressTextField.rightView = currentLocationButton;

  // List of address results
  CGFloat addressTableViewHeight = screen.size.height - 
    (addressTextFieldView.frame.origin.y + 
      addressTextFieldView.frame.size.height);
  addressTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f,
    addressTextFieldView.frame.origin.y + 
    addressTextFieldView.frame.size.height, 
      screenWidth,  addressTableViewHeight)
    style: UITableViewStylePlain];
  addressTableView.backgroundColor = [UIColor grayUltraLight];
  addressTableView.dataSource = self;
  addressTableView.delegate = self;
  addressTableView.hidden = YES;
  addressTableView.separatorColor  = [UIColor grayLight];
  addressTableView.separatorInset  = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  addressTableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
  addressTableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
  [self.view addSubview: addressTableView];

  CGFloat textFieldTableViewHeight = screen.size.height - 
    addressTableView.frame.origin.y;
  textFieldTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f,
    screen.size.height, screenWidth, textFieldTableViewHeight)
      style: UITableViewStylePlain];
  textFieldTableView.backgroundColor = [UIColor grayUltraLight];
  textFieldTableView.dataSource = self;
  textFieldTableView.delegate = self;
  textFieldTableView.hidden = YES;
  textFieldTableView.separatorColor = [UIColor grayLight];
  textFieldTableView.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  textFieldTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  textFieldTableView.tableFooterView = [[UIView alloc] initWithFrame: 
    CGRectZero];
  [self.view addSubview: textFieldTableView];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];

  [addressTextField becomeFirstResponder];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Subclasses implement this
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  if (tableView == addressTableView) {
    cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
      size: 15];
    cell.textLabel.text = 
      @"101 West Broadway, San Diego, CA, 92122, United States";
    cell.textLabel.textColor = [UIColor textColor];
    if (indexPath.row == 
      [tableView numberOfRowsInSection: indexPath.section] - 1) {

      cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
        size: 15];
      cell.textLabel.text = @"Use address form";
      cell.textLabel.textColor = [UIColor blue];
    }
  }
  else if (tableView == textFieldTableView) {
    static NSString *TextFieldCellIdentifier = @"TextFieldCellIdentifier";
    OMBLabelTextFieldCell *c = [tableView dequeueReusableCellWithIdentifier:
      TextFieldCellIdentifier];
    if (!c)
      c = [[OMBLabelTextFieldCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: TextFieldCellIdentifier];
    c.selectionStyle = UITableViewCellSelectionStyleNone;
    // Top border
    UIView *topBorder = [c.contentView viewWithTag: 9998];
    if (topBorder)
      [topBorder removeFromSuperview];
    else {
      topBorder = [UIView new];
      topBorder.backgroundColor = [UIColor grayLight];
      topBorder.frame = CGRectMake(0.0f, 0.0f, 
        tableView.frame.size.width, 0.5f);
      topBorder.tag = 9998;
    }
    // Bottom border
    UIView *bottomBorder = [c.contentView viewWithTag: 9999];
    if (bottomBorder)
      [bottomBorder removeFromSuperview];
    else {
      bottomBorder = [UIView new];
      bottomBorder.backgroundColor = [UIColor grayLight];
      bottomBorder.frame = CGRectMake(0.0f, 44.0f - 0.5f, 
        tableView.frame.size.width, 0.5f);
      bottomBorder.tag = 9999;
    }
    NSString *string = @"";
    if (indexPath.row == 0) {
      string = @"Address";
      [c.contentView addSubview: topBorder];
    }
    else if (indexPath.row == 1) {
      string = @"Unit";
    }
    else if (indexPath.row == 2) {
      string = @"City";
    }
    else if (indexPath.row == 3) {
      string = @"State";
    }
    else if (indexPath.row == 4) {
      string = @"Zip";
      [c.contentView addSubview: bottomBorder];
    }
    c.textField.delegate = self;
    c.textFieldLabel.text = string;
    [c setFramesUsingString: @"Address"];
    return c;
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (tableView == addressTableView) {
    return 10;
  }
  else if (tableView == textFieldTableView) {
    return 5;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (tableView == addressTableView) {
    if (indexPath.row == 
      [tableView numberOfRowsInSection: indexPath.section] - 1) {

      [self showAddressForm];
    }
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 44.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) makeTableViewLarger: (NSNotification *) notification
{
  NSTimeInterval duration = [[notification.userInfo objectForKey: 
    UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration: duration delay: 0.0f 
    options: UIViewAnimationOptionCurveEaseOut animations: 
    ^{
      CGRect screen = [[UIScreen mainScreen] bounds];
      CGFloat addressTableViewHeight = screen.size.height - 
        (addressTextFieldView.frame.origin.y + 
          addressTextFieldView.frame.size.height);
      CGRect rect = addressTableView.frame;
      rect.size.height = addressTableViewHeight;
      addressTableView.frame = rect;

      // Text field table view
      CGRect rect2 = textFieldTableView.frame;
      rect2.size.height = screen.size.height - (20.0f + 44.0f);
      textFieldTableView.frame = rect2;
    } 
    completion: nil
  ];
}

- (void) makeTableViewSmaller: (NSNotification *) notification
{
  NSTimeInterval duration = [[notification.userInfo objectForKey: 
    UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration: duration delay: 0.0f 
    options: UIViewAnimationOptionCurveEaseOut animations: 
    ^{
      CGRect screen = [[UIScreen mainScreen] bounds];
      CGFloat addressTableViewHeight = screen.size.height - 
        (addressTextFieldView.frame.origin.y + 
          addressTextFieldView.frame.size.height);
      CGRect rect = addressTableView.frame;
      rect.size.height = addressTableViewHeight - 216.0f;
      addressTableView.frame = rect;

      // Text field table view
      CGRect rect2 = textFieldTableView.frame;
      rect2.size.height = (screen.size.height - (20.0f + 44.0f)) - 216.0f;
      textFieldTableView.frame = rect2;
    } 
    completion: nil
  ];
}

- (void) showAddressForm
{
  // Animate the address text field view up
  [UIView animateWithDuration: 0.25f animations: ^{
    CGRect rect = addressTextFieldView.frame;
    rect.origin.y = -1 * rect.size.height;
    addressTextFieldView.frame = rect;
  }];
  // Animate the text field table view up
  [UIView animateWithDuration: 0.25f animations: ^{
    textFieldTableView.hidden = NO;
    CGRect rect = textFieldTableView.frame;
    rect.origin.y = 20.0f + 44.0f;
    textFieldTableView.frame = rect;
  } completion: ^(BOOL finished) {
    addressTableView.hidden = YES;
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *) 
      [textFieldTableView cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: 0 inSection: 0]];
    [cell.textField becomeFirstResponder];

    saveBarButtonItem.enabled = YES;
  }];
}

- (void) textFieldDidChange: (UITextField *) textField
{
  NSLog(@"%@", textField.text);
  NSInteger length = [[textField.text stripWhiteSpace] length];
  if (length) {
    [self.navigationItem setRightBarButtonItem: saveBarButtonItem
      animated: YES];
    addressTextField.clearButtonMode = UITextFieldViewModeAlways;
    addressTextField.rightViewMode   = UITextFieldViewModeNever;
    addressTableView.hidden = NO;
    map.hidden = YES;
  }
  else {
    [self.navigationItem setRightBarButtonItem: nil animated: YES];
    addressTextField.clearButtonMode = UITextFieldViewModeNever;
    addressTextField.rightViewMode   = UITextFieldViewModeAlways;
    addressTableView.hidden = YES;
    map.hidden = NO;
  }
}

- (void) save
{
  [self.navigationController popViewControllerAnimated: YES];
}

@end
