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
  self.title      = @"Add payment";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setupForTable];

    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];

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
  // Credit Card Information
  // Keyboard
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  // CGFloat borderHeight = 0.5f;

  static NSString *EmptyID = @"EmptyID";
  UITableViewCell *empty = [tableView dequeueReusableCellWithIdentifier:
    EmptyID];
  if (!empty) {
    empty = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleDefault reuseIdentifier: EmptyID];
  }

  // Fields
  if (section == OMBPayoutMethodCreditCardSectionPersonal) {
      if (indexPath.row == OMBPayoutMethodCreditCardSectionPersonalRowTitle) {
          [empty setBackgroundColor:[UIColor clearColor]];
          [empty setSelectionStyle:UITableViewCellSelectionStyleNone];

          UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 55.0f)];
          [lbTitle setBackgroundColor:[UIColor clearColor]];
          [lbTitle setTextColor:[UIColor grayMedium]];
          [lbTitle setFont:[UIFont mediumLargeTextFont]];
          [lbTitle setText:@"Personal Information"];
          [lbTitle setTextAlignment:NSTextAlignmentCenter];
          [empty addSubview:lbTitle];
          return empty;
      }
      if (indexPath.row > OMBPayoutMethodCreditCardSectionPersonalRowTitle) {
          static NSString *PersonalID = @"PersonalID";
          OMBLabelTextFieldCell *cell =
          [tableView dequeueReusableCellWithIdentifier: PersonalID];
          if (!cell) {
              cell = [[OMBLabelTextFieldCell alloc] initWithStyle:
                      UITableViewCellStyleDefault reuseIdentifier: PersonalID];
          }
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          [cell setBackgroundColor:[UIColor clearColor]];
          cell.textField.keyboardType = UIKeyboardTypeDefault;
          cell.textField.userInteractionEnabled = YES;
          NSString *imageName;
          NSString *labelString;
          NSString *key;
          if (row == OMBPayoutMethodCreditCardSectionPersonalRowCountry ) {

              [cell setFrameUsingLeftLabelWithFirstCell:YES];
              cell.backgroundColor = [UIColor clearColor];

              imageName         = @"business_icon_black";
              labelString = @"Country";
              key = @"country";
              cell.textField.keyboardType = UIKeyboardTypeDefault;
              cell.textField.textColor = [UIColor textColor];
              cell.textField.font = [UIFont normalTextFontBold];

              cell.textFieldLabel.text = @"Country";
              cell.textFieldLabel.textAlignment = NSTextAlignmentLeft;
              cell.textFieldLabel.font = [UIFont normalTextFont];
              cell.textFieldLabel.textColor = [UIColor grayMedium];
          }
          if (row == OMBPayoutMethodCreditCardSectionPersonalRowZip) {
              [cell setFrameUsingLeftLabelWithFirstCell:NO];
              cell.backgroundColor = [UIColor clearColor];

              imageName         = @"location_icon_black.png";
              labelString = @"Zip";
              key = @"zip";
              cell.textField.keyboardType = UIKeyboardTypeNumberPad;
              cell.textField.textColor = [UIColor textColor];
              cell.textField.font = [UIFont normalTextFontBold];

              cell.textFieldLabel.text = @"Zip Code";
              cell.textFieldLabel.textAlignment = NSTextAlignmentLeft;
              cell.textFieldLabel.font = [UIFont normalTextFont];
              cell.textFieldLabel.textColor = [UIColor grayMedium];
          }


          cell.iconImageView.image = [UIImage image: [UIImage imageNamed: @""]
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

  }

  // Credit Card
  else if (section == OMBPayoutMethodCreditCardSectionCreditCard){
      if (indexPath.row == OMBPayoutMethodCreditCardSectionCreditCardRowTitle) {
          [empty setBackgroundColor:[UIColor clearColor]];
          [empty setSelectionStyle:UITableViewCellSelectionStyleNone];

          UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 55.0f)];
          [lbTitle setBackgroundColor:[UIColor clearColor]];
          [lbTitle setTextColor:[UIColor grayMedium]];
          [lbTitle setFont:[UIFont mediumLargeTextFont]];
          [lbTitle setText:@"Credit Card Information"];
          [lbTitle setTextAlignment:NSTextAlignmentCenter];
          [empty addSubview:lbTitle];
          return empty;
      }
      if (indexPath.row > OMBPayoutMethodCreditCardSectionCreditCardRowTitle) {
          static NSString *CreditCardID = @"CreditCardID";
          OMBLabelTextFieldCell *cell =
          [tableView dequeueReusableCellWithIdentifier: CreditCardID];
          if (!cell) {
              cell = [[OMBLabelTextFieldCell alloc] initWithStyle:
                      UITableViewCellStyleDefault reuseIdentifier: CreditCardID];
          }
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          [cell setBackgroundColor:[UIColor clearColor]];
          cell.textField.keyboardType = UIKeyboardTypeDefault;
          cell.textField.userInteractionEnabled = YES;
          NSString *imageName;
          NSString *labelString;
          NSString *key;
          // Card Number
          if (row == OMBPayoutMethodCreditCardSectionCreditCardRowNumber) {

              [cell setFrameUsingLeftLabelAndIconWithFirstCell:YES];
              cell.backgroundColor = [UIColor clearColor];

              imageName         = @"credit_card_icon.png";
              labelString = @"Card number";
              key = @"card_number";

              cell.textField.keyboardType = UIKeyboardTypeNumberPad;
              cell.textField.textColor = [UIColor textColor];
              cell.textField.font = [UIFont normalTextFontBold];

              cell.textFieldLabel.text = @"Number";
              cell.textFieldLabel.textAlignment = NSTextAlignmentLeft;
              cell.textFieldLabel.font = [UIFont normalTextFont];
              cell.textFieldLabel.textColor = [UIColor grayMedium];

              cell.iconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
                                                   size: cell.iconImageView.bounds.size];

          }
          // Expiry CCV
          else if (row == OMBPayoutMethodCreditCardSectionCreditCardRowExpiration) {

              //imageName = @"globe_icon_black.png";
              imageName         = @"credit_card_icon.png";
              static NSString *LabelTextCellID = @"TwoLabelTextCellID";

              OMBTwoLabelTextFieldCell *cell =
              [tableView dequeueReusableCellWithIdentifier: LabelTextCellID];

              if (!cell) {
                  cell = [[OMBTwoLabelTextFieldCell alloc] initWithStyle:
                          UITableViewCellStyleDefault reuseIdentifier: LabelTextCellID];
                  [cell setFrameUsingLeftLabelIconImageView];
              }

              cell.selectionStyle = UITableViewCellSelectionStyleNone;
              cell.backgroundColor = [UIColor clearColor];

              NSString *firstlabelString = @"mm";
              NSString *thirdlabelString = @"yy";
              NSString *secondlabelString = @"CCV";

              // Expiry
              cell.firstIconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
                                                        size: cell.firstIconImageView.bounds.size];


              cell.firstTextFieldLabel.text = @"Expiry";
              cell.firstTextFieldLabel.textAlignment = NSTextAlignmentLeft;
              cell.firstTextFieldLabel.font = [UIFont normalTextFont];
              cell.firstTextFieldLabel.textColor = [UIColor grayMedium];

              cell.firstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
              cell.firstTextField.delegate  = self;
              cell.firstTextField.textColor = [UIColor textColor];
              cell.firstTextField.font = [UIFont normalTextFontBold];
              cell.firstTextField.indexPath = indexPath;
              cell.firstTextField.keyboardType = UIKeyboardTypeNumberPad;
              cell.firstTextField.placeholder = firstlabelString;
              cell.firstTextField.textAlignment = NSTextAlignmentCenter;
              [cell.firstTextField addTarget: self action: @selector(textFieldDidChange:)
                            forControlEvents: UIControlEventEditingChanged];

              cell.labelSeparator.text = @"/";
              cell.labelSeparator.textAlignment = NSTextAlignmentCenter;
              cell.labelSeparator.textColor = [UIColor textColor];
              cell.labelSeparator.font = [UIFont normalTextFontBold];

              cell.thirdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
              cell.thirdTextField.delegate  = self;
              cell.thirdTextField.textColor = [UIColor textColor];
              cell.thirdTextField.font = [UIFont normalTextFontBold];
              cell.thirdTextField.indexPath = indexPath;
              cell.thirdTextField.keyboardType = UIKeyboardTypeNumberPad;
              cell.thirdTextField.placeholder = thirdlabelString;
              cell.thirdTextField.textAlignment = NSTextAlignmentCenter;
              [cell.thirdTextField addTarget: self action: @selector(textFieldDidChange:)
                            forControlEvents: UIControlEventEditingChanged];

              // CCV
              cell.secondIconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
                                                        size: cell.secondIconImageView.bounds.size];

              cell.secondTextFieldLabel.text = @"CCV";
              cell.secondTextFieldLabel.textAlignment = NSTextAlignmentLeft;
              cell.secondTextFieldLabel.font = [UIFont normalTextFont];
              cell.secondTextFieldLabel.textColor = [UIColor grayMedium];

              cell.secondTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
              cell.secondTextField.delegate  = self;
              cell.secondTextField.textColor = [UIColor textColor];
              cell.secondTextField.font = [UIFont normalTextFontBold];
              cell.secondTextField.indexPath =
              [NSIndexPath indexPathForRow: OMBPayoutMethodCreditCardSectionCreditCardRowCCV
                                 inSection: indexPath.section] ;
              cell.secondTextField.keyboardType = UIKeyboardTypeNumberPad;
              cell.secondTextField.placeholder = secondlabelString;
              cell.secondTextField.textAlignment = NSTextAlignmentCenter;
              [cell.secondTextField addTarget: self action: @selector(textFieldDidChange:)
                             forControlEvents: UIControlEventEditingChanged];
              return cell;
          }

          cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
          cell.textField.delegate  = self;
          cell.textField.indexPath = indexPath;
          cell.textField.placeholder = labelString;
          [cell.textField addTarget: self
                             action: @selector(textFieldDidChange:)
                   forControlEvents: UIControlEventEditingChanged];
          return cell;
      }
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
    return 3;
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

      if (row == OMBPayoutMethodCreditCardSectionPersonalRowTitle) {
          return [OMBLabelTextFieldCell heightForCellWithSectionTitle];
      }
      return [OMBLabelTextFieldCell heightForCellWithLeftLabel];
  }
  // Credit Card
  else if (section == OMBPayoutMethodCreditCardSectionCreditCard) {

      if (row == OMBPayoutMethodCreditCardSectionCreditCardRowTitle) {
          return [OMBLabelTextFieldCell heightForCellWithSectionTitle];
      }
      return [OMBLabelTextFieldCell heightForCellWithLeftLabel];
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
    if (row == OMBPayoutMethodCreditCardSectionPersonalRowCountry ) {
    }
  }
}

@end
