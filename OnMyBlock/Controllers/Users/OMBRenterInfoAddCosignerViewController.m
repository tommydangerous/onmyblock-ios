//
//  OMBRenterInfoAddCosignerViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoAddCosignerViewController.h"

#import "OMBLabelTextFieldCell.h"
#import "OMBTwoLabelTextFieldCell.h"
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
  if (!empty)
    empty = [[UITableViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: EmptyID];
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
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
      }
      // Phone
      else if (row == OMBRenterInfoAddCosignerSectionFieldsRowPhone) {
        imageName         = @"phone_icon.png";
        placeholderString = @"Phone";
      }
      // Relationship type
      else if (row == 
        OMBRenterInfoAddCosignerSectionFieldsRowRelationshipType) {
        imageName         = @"group_icon.png";
        placeholderString = @"Relationship type";
      }
      cell.iconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
        size: cell.iconImageView.bounds.size];
      cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.textField.delegate  = self;
      cell.textField.indexPath = indexPath;
      cell.textField.placeholder = placeholderString;
      [cell.textField addTarget: self action: @selector(textFieldDidChange:)
        forControlEvents: UIControlEventEditingChanged];
      return cell;
    }
  }
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
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;

  if (section == OMBRenterInfoAddCosignerSectionFields) {
    return OMBStandardButtonHeight;
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

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  NSInteger row = textField.indexPath.row;
}

@end
