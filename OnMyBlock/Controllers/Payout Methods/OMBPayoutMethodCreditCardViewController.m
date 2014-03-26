//
//  OMBPayoutMethodCreditCardViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodCreditCardViewController.h"

#import "NSString+Extensions.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBNavigationController.h"
#import "OMBRenterApplication.h"
#import "OMBTwoLabelTextFieldCell.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Resize.h"

@implementation OMBPayoutMethodCreditCardViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;
  
  self.screenName = @"Payout Method Credit Card";
  self.title      = @"Payout";
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  
  [self setupForTable];
  
  cancelBarButton =
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
      style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];
  UIFont *notBoldFont = [UIFont mediumTextFont];
  [cancelBarButton setTitleTextAttributes: @{
    NSFontAttributeName: notBoldFont
      } forState: UIControlStateNormal];
  cancelBarButton.tintColor = [UIColor grayMedium];
  
  doneBarButton =
    [[UIBarButtonItem alloc] initWithTitle: @"Done"
      style: UIBarButtonItemStylePlain target: self action: @selector(done)];
  UIFont *boldFont = [UIFont mediumTextFontBold];
  [doneBarButton setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
      } forState: UIControlStateNormal];
  
  self.navigationItem.leftBarButtonItem  = cancelBarButton;
  self.navigationItem.rightBarButtonItem = doneBarButton;

  /*CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight   = screen.size.height;
  CGFloat screenWidth    = screen.size.width;
  CGFloat padding        = OMBPadding;
  CGFloat standardHeight = OMBStandardHeight;*/
  
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
      action: @selector(doneFromInputAccessoryView)];
  
  // Right padding
  UIBarButtonItem *rightPadding =
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
   UIBarButtonSystemItemFixedSpace target: nil action: nil];
  // iOS 7 toolbar spacing is 16px; 20px on iPad
  rightPadding.width = 4.0f;
  
  textFieldToolbar = [UIToolbar new];
  textFieldToolbar.barTintColor = [UIColor whiteColor];
  textFieldToolbar.clipsToBounds = YES;
  textFieldToolbar.frame = CGRectMake(0.0f, 0.0f,
    [self screen].size.width, OMBStandardHeight);
  textFieldToolbar.items = @[
    leftPadding,
    cancelBarButtonItemForTextFieldToolbar,
    flexibleSpace,
    doneBarButtonItemForTextFieldToolbar,
    rightPadding
  ];
  textFieldToolbar.tintColor = [UIColor blue];
}

- (void) viewDidLoad
{
  [super viewDidLoad];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Personal Information
  // Spacing
  // Credit Card Information
  // Keyboard
  return 4;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  CGFloat borderHeight = 0.5f;
  
  static NSString *EmptyID = @"EmptyID";
  UITableViewCell *empty = [tableView dequeueReusableCellWithIdentifier:
    EmptyID];
  if (!empty) {
    empty = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleDefault reuseIdentifier: EmptyID];
  }
  
  // Fields
  if (section == OMBPayoutMethodCreditCardSectionPersonal) {
    static NSString *PersonalID = @"PersonalID";
    OMBLabelTextFieldCell *cell =
      [tableView dequeueReusableCellWithIdentifier: PersonalID];
    if (!cell) {
      cell = [[OMBLabelTextFieldCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier: PersonalID];
      [cell setFrameUsingIconImageView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    cell.textField.userInteractionEnabled = YES;
    NSString *imageName;
    NSString *labelString;
    NSString *key;
    if (row == OMBPayoutMethodCreditCardSectionPersonalRowBilling ) {
      imageName         = @"business_icon_black";
      labelString = @"Billing address";
      key = @"billing_address";
    }
    if (row == OMBPayoutMethodCreditCardSectionPersonalRowZip) {
      imageName         = @"location_icon_black.png";
      labelString = @"Zip";
      key = @"zip";
    }
    
    cell.iconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
      size: cell.iconImageView.bounds.size];
    cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cell.textField.delegate  = self;
    cell.textField.indexPath = indexPath;
    cell.textField.placeholder = labelString;
    [cell.textField addTarget: self
      action: @selector(textFieldDidChange:)
        forControlEvents: UIControlEventEditingChanged];
    return cell;
  }
  // Empty
  else if (section == OMBPayoutMethodCreditCardSectionEmpty) {
    empty.contentView.backgroundColor = self.table.backgroundColor;
    empty.selectedBackgroundView = nil;
    empty.selectionStyle = UITableViewCellSelectionStyleNone;
    empty.textLabel.text = @"";
    empty.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
  }
  // Credit Card
  else if (section == OMBPayoutMethodCreditCardSectionCreditCard){
    static NSString *CreditCardID = @"CreditCardID";
    OMBLabelTextFieldCell *cell =
      [tableView dequeueReusableCellWithIdentifier: CreditCardID];
    if (!cell) {
      cell = [[OMBLabelTextFieldCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier: CreditCardID];
      [cell setFrameUsingIconImageView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    cell.textField.userInteractionEnabled = YES;
    NSString *imageName;
    NSString *labelString;
    NSString *key;
    // Card Number
    if (row == OMBPayoutMethodCreditCardSectionCreditCardRowNumber) {
      imageName         = @"credit_card_icon.png";
      labelString = @"Card number";
      key = @"card_number";
      CALayer *border = [CALayer layer];
      border.backgroundColor = [UIColor grayLight].CGColor;
      border.frame = CGRectMake(20.0f, 0.0f,
        cell.contentView.frame.size.width - 20.0f, borderHeight);
      [cell.layer addSublayer: border];
    }
    // Expiry CCV
    else if (row == OMBPayoutMethodCreditCardSectionCreditCardRowExpiration) {
      imageName = @"globe_icon_black.png";
      static NSString *LabelTextCellID = @"TwoLabelTextCellID";
      OMBTwoLabelTextFieldCell *cell =
      [tableView dequeueReusableCellWithIdentifier: LabelTextCellID];
      if (!cell) {
        cell = [[OMBTwoLabelTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: LabelTextCellID];
        [cell setFrameUsingIconImageView];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
      NSString *firstlabelString = @"Expiry";
      NSString *secondlabelString = @"CCV";
      
      // Expiry
      cell.firstIconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
        size: cell.firstIconImageView.bounds.size];
      cell.firstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.firstTextField.delegate  = self;
      cell.firstTextField.font = [UIFont normalTextFont];
      cell.firstTextField.indexPath = indexPath;
      cell.firstTextField.placeholder = firstlabelString;
      [cell.firstTextField addTarget: self action: @selector(textFieldDidChange:)
        forControlEvents: UIControlEventEditingChanged];
      
      // CCV
      cell.secondTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.secondTextField.delegate  = self;
      cell.secondTextField.font = cell.firstTextField.font;
      cell.secondTextField.indexPath =
      [NSIndexPath indexPathForRow: OMBPayoutMethodCreditCardSectionCreditCardRowCCV
        inSection: indexPath.section] ;
      cell.secondTextField.placeholder = secondlabelString;
      [cell.secondTextField addTarget: self action: @selector(textFieldDidChange:)
        forControlEvents: UIControlEventEditingChanged];
      return cell;
    }
    
    cell.iconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
      size: cell.iconImageView.bounds.size];
    cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cell.textField.delegate  = self;
    cell.textField.indexPath = indexPath;
    cell.textField.placeholder = labelString;
    [cell.textField addTarget: self
      action: @selector(textFieldDidChange:)
        forControlEvents: UIControlEventEditingChanged];
    return cell;
  }
  // Spacing Keyboard
  else if (section == OMBPayoutMethodCreditCardSectionSpacingKeyboard) {
    empty.backgroundColor = [UIColor grayUltraLight];
    empty.separatorInset = UIEdgeInsetsMake(0.0f,
      tableView.frame.size.width, 0.0f, 0.0f);
    return empty;
  }
  return empty;
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
  // Personal
  if (section == OMBPayoutMethodCreditCardSectionPersonal) {
    return 2;
  }
  // Empty
  if (section == OMBPayoutMethodCreditCardSectionEmpty) {
    return 1;
  }
  // CreditCard
  if (section == OMBPayoutMethodCreditCardSectionCreditCard ) {
    return 3;
  }
  // Spacing Keyboard
  if (section == OMBPayoutMethodCreditCardSectionSpacingKeyboard) {
    return 1;
  }
  return 0;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  
  // Personal
  if (section == OMBPayoutMethodCreditCardSectionPersonal) {
    return [OMBLabelTextFieldCell heightForCellWithIconImageView];
  }
  // Empty
  else if (section == OMBPayoutMethodCreditCardSectionEmpty) {
    return OMBStandardHeight;
  }
  // Credit Card
  else if (section == OMBPayoutMethodCreditCardSectionCreditCard) {
    if (row == OMBPayoutMethodCreditCardSectionCreditCardRowCCV)
      return 0.0f;
    
    return [OMBLabelTextFieldCell heightForCellWithIconImageView];
  }
  // Spacing Keyboard
  else if (section == OMBPayoutMethodCreditCardSectionSpacingKeyboard) {
    if (isEditing) {
      return OMBKeyboardHeight + textFieldToolbar.frame.size.height;
    }
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing:(TextFieldPadding *)textField
{
  isEditing = YES;
  [self.table beginUpdates];
  [self.table endUpdates];
  
  textField.inputAccessoryView = textFieldToolbar;
  
  if (textField.indexPath.row == OMBPayoutMethodCreditCardSectionCreditCardRowCCV)
    [self scrollToRowAtIndexPath:
      [NSIndexPath indexPathForRow:
        OMBPayoutMethodCreditCardSectionCreditCardRowExpiration
          inSection:textField.indexPath.section]];
  else
    [self scrollToRowAtIndexPath: textField.indexPath];
  
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [self doneFromInputAccessoryView];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancel
{
  [self.navigationController dismissViewControllerAnimated: YES
    completion: nil];
}

- (void) cancelFromInputAccessoryView
{
  [self.view endEditing: YES];
  isEditing = NO;
  [self.table beginUpdates];
  [self.table endUpdates];
}

- (void) done
{
  [[OMBUser currentUser] createPayoutMethodWithDictionary:
   @{
     @"active":      [NSNumber numberWithBool: YES],
     @"email":       @"aguilarpgc",
     @"payoutType":  @"credit_card",
     @"primary":     [NSNumber numberWithBool: YES]
     } withCompletion: ^(NSError *error) {
       if(error)
         NSLog(@"ERROR: %@",error.description);
       [[self appDelegate].container stopSpinning];
       [self cancel];
  }];
  [[self appDelegate].container startSpinning];

}

- (void) doneFromInputAccessoryView
{
  [self cancelFromInputAccessoryView];
}

- (void) scrollToRowAtIndexPath: (NSIndexPath *) indexPath
{
  [self.table scrollToRowAtIndexPath: indexPath
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  NSInteger row = textField.indexPath.row;
  NSString *string = textField.text;
  
  if ([string length]) {
    if (row == OMBPayoutMethodCreditCardSectionPersonalRowBilling ) {
    }
  }
}

@end
