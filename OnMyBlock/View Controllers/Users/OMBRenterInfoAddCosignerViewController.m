//
//  OMBRenterInfoAddCosignerViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoAddCosignerViewController.h"

#import "OMBCosigner.h"
#import "OMBLabelSwitchCell.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBRenterApplication.h"
#import "OMBTwoLabelTextFieldCell.h"
#import "OMBViewControllerContainer.h"
#import "UIImage+Resize.h"

@interface OMBRenterInfoAddCosignerViewController ()

@end

@implementation OMBRenterInfoAddCosignerViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.title = @"Add Co-signer";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  [self setupForTable];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  modelObject = [[OMBCosigner alloc] init];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Fields
  // Spacing
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;

  static NSString *EmptyID = @"EmptyID";
  UITableViewCell *empty = [tableView dequeueReusableCellWithIdentifier:
    EmptyID];
  if (!empty) {
    empty = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleDefault reuseIdentifier: EmptyID];
  }
  // Fields
  if (section == OMBRenterInfoAddCosignerSectionFields) {
    // First name, last name
    if (row == OMBRenterInfoAddCosignerSectionFieldsRowFirstNameLastName) {
      static NSString *NameID = @"NameID";
      OMBTwoLabelTextFieldCell *cell =
        [tableView dequeueReusableCellWithIdentifier: NameID];
      if (!cell) {
        cell = [[OMBTwoLabelTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: NameID];
        [cell setFrameUsingIconImageView];
      }
      cell.firstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.firstTextField.delegate  = self;
      cell.firstTextField.indexPath = indexPath;
      cell.firstTextField.placeholder  = @"First name";
      cell.firstIconImageView.image = [UIImage image: [UIImage imageNamed:
        @"user_icon.png"] size: cell.firstIconImageView.bounds.size];
      cell.secondTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.secondTextField.delegate  = self;
      cell.secondTextField.indexPath = indexPath;
      cell.secondTextField.placeholder = @"Last name";
      cell.secondTextField.tag =
        OMBRenterInfoAddCosignerSectionFieldsRowLastName;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell.firstTextField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      [cell.secondTextField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      cell.clipsToBounds = YES;
      return cell;
    }
    else {
      static NSString *LabelTextID = @"LabelTextID";
      OMBLabelTextFieldCell *cell =
        [tableView dequeueReusableCellWithIdentifier: LabelTextID];
      if (!cell) {
        cell = [[OMBLabelTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: LabelTextID];
        [cell setFrameUsingIconImageView];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSString *imageName;
      NSString *placeholderString;
      // Email
      if (row == OMBRenterInfoAddCosignerSectionFieldsRowEmail) {
        imageName         = @"messages_icon_dark.png";
        placeholderString = @"Email";
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
      }
      // Phone
      else if (row == OMBRenterInfoAddCosignerSectionFieldsRowPhone) {
        imageName         = @"phone_icon.png";
        placeholderString = @"Phone";
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
      }
      // Relationship type
      else if (row ==
        OMBRenterInfoAddCosignerSectionFieldsRowRelationshipType) {
        imageName         = @"group_icon.png";
        placeholderString = @"Relationship type";
        // Last row, hide the separator
        cell.separatorInset = UIEdgeInsetsMake(0.0f,
          tableView.frame.size.width, 0.0f, 0.0f);
      }
      cell.iconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
        size: cell.iconImageView.bounds.size];
      cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.textField.delegate  = self;
      cell.textField.indexPath = indexPath;
      cell.textField.placeholder = placeholderString;
      [cell.textField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  // Spacing
  else if (section == OMBRenterInfoAddCosignerSectionSpacing) {
    empty.backgroundColor = [UIColor clearColor];
    empty.separatorInset = UIEdgeInsetsMake(0.0f,
      tableView.frame.size.width, 0.0f, 0.0f);
  }
  empty.clipsToBounds = YES;
  return empty;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (section == OMBRenterInfoAddCosignerSectionFields)
    return 4;
  else if (section == OMBRenterInfoAddCosignerSectionSpacing)
    return 1;
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger section = indexPath.section;

  if (section == OMBRenterInfoAddCosignerSectionFields) {
    return [OMBLabelTextFieldCell heightForCellWithIconImageView];
  }
  else if (section == OMBRenterInfoAddCosignerSectionSpacing) {
    if (isEditing) {
      return OMBKeyboardHeight + textFieldToolbar.frame.size.height;
    }
  }
  return 0.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) save
{
  [super save];
  [[self renterApplication] createModelConnection: modelObject
    delegate: modelObject completion: ^(NSError *error) {
      if (error) {
        [self showAlertViewWithError: error];
      }
      else {
        [[self renterApplication] addCosigner: modelObject];
        [self cancel];
      }
      isSaving = NO;
      [[self appDelegate].container stopSpinning];
    }];
  [[self appDelegate].container startSpinning];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  NSInteger row = textField.indexPath.row;
  NSString *string = textField.text;

  if ([string length]) {
    if (row == OMBRenterInfoAddCosignerSectionFieldsRowFirstNameLastName) {
      if (textField.tag == OMBRenterInfoAddCosignerSectionFieldsRowLastName) {
        [valueDictionary setObject: string forKey: @"lastName"];
      }
      else {
        [valueDictionary setObject: string forKey: @"firstName"];
      }
    }
    else if (row == OMBRenterInfoAddCosignerSectionFieldsRowEmail) {
      [valueDictionary setObject: string forKey: @"email"];
    }
    else if (row == OMBRenterInfoAddCosignerSectionFieldsRowPhone) {
      [valueDictionary setObject: string forKey: @"phone"];
    }
    else if (row == OMBRenterInfoAddCosignerSectionFieldsRowRelationshipType) {
      [valueDictionary setObject: string forKey: @"relationshipType"];
    }
  }
}

@end
