//
//  OMBRenterInfoAddEmploymentViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoAddEmploymentViewController.h"

#import "OMBEmployment.h"
#import "OMBLabelSwitchCell.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBRenterApplication.h"
#import "OMBTwoLabelTextFieldCell.h"
#import "OMBViewControllerContainer.h"
#import "UIImage+Resize.h"

@interface OMBRenterInfoAddEmploymentViewController ()

@end

@implementation OMBRenterInfoAddEmploymentViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;
  
  self.title = @"Add Employment";
  
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
  
  modelObject = [[OMBEmployment alloc] init];
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
  if (section == OMBRenterInfoAddEmploymentSectionFields) {
    
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
    // Company name
    if (row == OMBRenterInfoAddEmploymentSectionFieldsRowCompanyName) {
      imageName         = @"messages_icon_dark.png";
      placeholderString = @"company name";
    }
    // Company website
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowCompanyWebsite) {
      imageName         = @"phone_icon.png";
      placeholderString = @"company website";
    }
    // Start date
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowStartDate) {
      imageName         = @"phone_icon.png";
      placeholderString = @"start date";
    }
    // End date
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowEndDate) {
      imageName         = @"phone_icon.png";
      placeholderString = @"end date";
    }
    // Income
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowIncome) {
      imageName         = @"phone_icon.png";
      placeholderString = @"income";
      cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    // Title
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowTitle) {
      imageName         = @"group_icon.png";
      placeholderString = @"title";
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
    return cell;
    
  }
  // Spacing
  else if (section == OMBRenterInfoAddEmploymentSectionSpacing) {
    empty.backgroundColor = [UIColor clearColor];
    empty.separatorInset = UIEdgeInsetsMake(0.0f,
      tableView.frame.size.width, 0.0f, 0.0f);
  }
  return empty;
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
  if (section == OMBRenterInfoAddEmploymentSectionFields)
    return 6;
  else if (section == OMBRenterInfoAddEmploymentSectionSpacing)
    return 1;
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger section = indexPath.section;
  
  if (section == OMBRenterInfoAddEmploymentSectionFields) {
    return [OMBLabelTextFieldCell heightForCellWithIconImageView];
  }
  else if (section == OMBRenterInfoAddEmploymentSectionSpacing) {
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
  //[super save];
  /*[[self renterApplication] createCosignerConnection: modelObject
    delegate: modelObject completion: ^(NSError *error) {
      if (error) {
        [self showAlertViewWithError: error];
      }
      else {
        [[self renterApplication] addEmployment: modelObject];
        [self cancel];
      }
      isSaving = NO;
      [[self appDelegate].container stopSpinning];
    }];*/
  
  [[self appDelegate].container startSpinning];
  
#warning DELETE THESE 5 LINES AND UPDATE THE CODE ABOVE
  [modelObject readFromDictionary: valueDictionary];
  [[self renterApplication] addEmployment: modelObject];
  [self cancel];
  isSaving = NO;
  [[self appDelegate].container stopSpinning];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  NSInteger row = textField.indexPath.row;
  NSString *string = textField.text;
  
  if ([string length]) {
    if (row == OMBRenterInfoAddEmploymentSectionFieldsRowCompanyName) {
      [valueDictionary setObject: string forKey: @"company_name"];
    }
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowCompanyWebsite) {
      [valueDictionary setObject: string forKey: @"company_website"];
    }
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowEndDate ) {
      [valueDictionary setObject: string forKey: @"end_date"];
    }
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowIncome) {
      [valueDictionary setObject: string forKey: @"income"];
    }
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowStartDate) {
      [valueDictionary setObject: string forKey: @"start_date"];
    }
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowTitle) {
      [valueDictionary setObject: string forKey: @"title"];
    }
  }
}

@end
