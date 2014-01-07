//
//  OMBEmploymentAddViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/9/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBEmploymentAddViewController.h"

#import "OMBEmployment.h"
#import "OMBEmploymentCreateConnection.h"
#import "OMBRenterApplicationAddModelCell.h"

@implementation OMBEmploymentAddViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MMMM d, yyyy";

  self.screenName = self.title = @"Add Employment";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  _companyNameTextField    = [[TextFieldPadding alloc] init];
  _companyWebsiteTextField = [[TextFieldPadding alloc] init];
  _endDateTextField        = [[TextFieldPadding alloc] init];
  _incomeTextField         = [[TextFieldPadding alloc] init];
  _startDateTextField      = [[TextFieldPadding alloc] init];
  _titleTextField          = [[TextFieldPadding alloc] init];
  textFieldArray = @[
    _companyNameTextField, 
    _companyWebsiteTextField,
    _titleTextField,
    _incomeTextField,
    _startDateTextField,
    _endDateTextField
  ];

  _companyNameTextField.placeholder     = @"Company name (required)";
  _companyWebsiteTextField.placeholder  = @"Company website";
  _companyWebsiteTextField.keyboardType = UIKeyboardTypeURL;
  _endDateTextField.userInteractionEnabled = NO;
  _endDateTextField.textAlignment       = NSTextAlignmentRight;
  _incomeTextField.placeholder          = @"Income (per month)";
  _incomeTextField.keyboardAppearance   = UIKeyboardAppearanceDark;
  _incomeTextField.keyboardType         = UIKeyboardTypeDecimalPad;
  _startDateTextField.placeholder       = @"Month/Day/Year";
  _startDateTextField.userInteractionEnabled = NO;
  _startDateTextField.textAlignment     = _endDateTextField.textAlignment;
  _titleTextField.placeholder           = @"Title";

  _endDatePicker   = [[UIDatePicker alloc] init];
  _endDatePicker.datePickerMode = UIDatePickerModeDate;
  _endDatePicker.maximumDate = [NSDate date];
  [_endDatePicker addTarget: self action: @selector(dateChanged:)
    forControlEvents: UIControlEventValueChanged];
  _startDatePicker = [[UIDatePicker alloc] init];
  _startDatePicker.datePickerMode = _endDatePicker.datePickerMode;
  _startDatePicker.maximumDate = [NSDate date];
  [_startDatePicker addTarget: self action: @selector(dateChanged:)
    forControlEvents: UIControlEventValueChanged];
  
  [self setFrameForTextFields];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  if (indexPath.section == 0) {
    OMBRenterApplicationAddModelCell *cell = 
      [self.table dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell) {
      cell = [[OMBRenterApplicationAddModelCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // The indexes of the date picker
    if (indexPath.row < 5) {
      [cell setTextField: [textFieldArray objectAtIndex: indexPath.row]];
    }
    // Start date picker
    else if (indexPath.row == 5) {
      [cell.contentView addSubview: _startDatePicker];
    }
    // End date
    else if (indexPath.row == 6) {
      [cell setTextField: [textFieldArray objectAtIndex: indexPath.row - 1]];
    }
    // End date picker
    else if (indexPath.row == 7) {
      [cell.contentView addSubview: _endDatePicker];
    }
    CGRect screen     = [[UIScreen mainScreen] bounds];
    float screenWidth = screen.size.width;
    // If the row is the start and end date text field
    if (indexPath.row == 4 || indexPath.row == 6) {
      float padding = 20.0f;
      UILabel *label = [[UILabel alloc] init];
      label.font = _startDateTextField.font;
      label.textColor = _startDateTextField.textColor;
      CGRect rect = [@"Start date" boundingRectWithSize:
        CGSizeMake(320, _startDateTextField.frame.size.height)
          options: NSStringDrawingUsesLineFragmentOrigin
            attributes: @{ NSFontAttributeName: _startDateTextField.font }
              context: nil];
      label.frame = CGRectMake(padding, 0, rect.size.width,
        _startDateTextField.frame.size.height);
      CGRect rect2 = _startDateTextField.frame;
      rect2.origin.x = label.frame.origin.x + label.frame.size.width + padding;
      rect2.size.width = screenWidth - 
        (padding + label.frame.size.width + padding + padding);
      label.text = @"Start date";
      _startDateTextField.frame = rect2;
      [cell.contentView addSubview: label];
      if (indexPath.row == 4) {
        label.text = @"Start date";
      }
      else if (indexPath.row == 6) {
        label.text = @"End date";
      }
    }
    // Top and bottom borders than span across the entire screen
    if (indexPath.row == 0) {
      CALayer *topBorder = [CALayer layer];
      topBorder.backgroundColor = self.table.separatorColor.CGColor; 
      topBorder.frame = CGRectMake(0.0f, 0.0f, screenWidth, 0.5f);
      [cell.contentView.layer addSublayer: topBorder];
    }
    // Income, end date text field, or end date picker
    else if (indexPath.row == 3 || indexPath.row == 6 || indexPath.row == 7) {
      CALayer *bottomBorder = [CALayer layer];
      bottomBorder.backgroundColor = self.table.separatorColor.CGColor;
      float originY = 216.0f - 0.5f;
      // End date text field
      if (indexPath.row == 3 || indexPath.row == 6)
        originY = 44.0f - 0.5f;
      bottomBorder.frame = CGRectMake(0.0f, originY, screenWidth, 0.5f);
      [cell.contentView.layer addSublayer: bottomBorder];
    }
    return cell;
  }
  UITableViewCell *emptyCell = [[UITableViewCell alloc] init];
  emptyCell.backgroundColor = [UIColor clearColor];
  emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  NSInteger number = [super tableView: tableView 
    numberOfRowsInSection: section];
  // Add 2 rows for the date pickers for start and end date
  if (section == 0)
    number += 2;
  return number;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // If clicked start date or end date text field
  if (indexPath.row == 4 || indexPath.row == 6) {
    isEditing = NO;
    // If not editing the end date and not editing the start date
    if (!isEditingEndDate && !isEditingStartDate) {
      [self showClearAndDoneBarButtonItems];
    }
    [self.table beginUpdates];
    // Start date
    if (indexPath.row == 4) {
      isEditingEndDate   = NO;
      isEditingStartDate = !isEditingStartDate;
    }
    // End date
    else if (indexPath.row == 6) {
      isEditingEndDate   = !isEditingEndDate;
      isEditingStartDate = NO;
    }
    // If user is not editing the end date or the start date
    if (!isEditingEndDate && !isEditingStartDate)
      [self showCancelAndSaveBarButtonItems];
    [self.table endUpdates];
    [self.table scrollToRowAtIndexPath: 
      [NSIndexPath indexPathForRow: indexPath.row - 1 inSection: 0]
        atScrollPosition: UITableViewScrollPositionTop animated: YES];
    [self.view endEditing: YES];
  }
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.section == 0) {
    if (indexPath.row == 5 || indexPath.row == 7) {
      if ((indexPath.row == 5 && isEditingStartDate) ||
        (indexPath.row == 7 && isEditingEndDate)) {
        return 216.0f;
      }        
    }
    else {
      return _companyNameTextField.frame.size.height;
    }
  }
  else if (indexPath.section == 1) {
    if (isEditing)
      return 216.0f;
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  [self showCancelAndSaveBarButtonItems];
  isEditing = YES;
  [self.table beginUpdates];
  isEditingEndDate   = NO;
  isEditingStartDate = NO;
  [self.table endUpdates];
  int row = [textFieldArray indexOfObject: textField];
  [self.table scrollToRowAtIndexPath: 
    [NSIndexPath indexPathForRow: row inSection: 0]
      atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) clear
{
  if (isEditingEndDate)
    _endDateTextField.text = @"";
  else if (isEditingStartDate)
    _startDateTextField.text = @"";
}

- (void) dateChanged: (UIDatePicker *) datePicker
{
  NSDate *date = datePicker.date;
  NSString *dayString = [dateFormatter stringFromDate: date];
  if (datePicker == _endDatePicker) {
    _endDateTextField.text = dayString;
  }
  else if (datePicker == _startDatePicker) {
    _startDateTextField.text = dayString;
  }
}

- (void) done
{
  [self showCancelAndSaveBarButtonItems];
  [self.table beginUpdates];
  isEditingEndDate   = NO;
  isEditingStartDate = NO;
  [self.table endUpdates];
}

- (void) save
{
  NSArray *array = @[_companyNameTextField];
  if ([self validateFieldsInArray: array])
    return;
  // Save the model
  OMBEmployment *employment = [[OMBEmployment alloc] init];
  employment.companyName = [_companyNameTextField.text lowercaseString];
  employment.companyWebsite = [_companyWebsiteTextField.text lowercaseString];
  if ([_endDateTextField.text length] > 0) {
    NSDate *date  = [dateFormatter dateFromString: _endDateTextField.text];
    employment.endDate  = [date timeIntervalSince1970];
  }
  if ([_incomeTextField.text length] > 0)
    employment.income = [_incomeTextField.text floatValue];
  if ([_startDateTextField.text length] > 0) {
    NSDate *date = [dateFormatter dateFromString: _startDateTextField.text];
    employment.startDate = [date timeIntervalSince1970];
  }
  employment.title = [_titleTextField.text lowercaseString];
  // Check to see if the end date is less than the start date
  if (employment.endDate && employment.startDate) {
    if (employment.endDate < employment.startDate) {
      NSTimeInterval tempEndDate   = employment.endDate;
      NSTimeInterval tempStartDate = employment.startDate;
      employment.endDate   = tempStartDate;
      employment.startDate = tempEndDate;
    }
  }
  // Add the employment
  [[OMBUser currentUser] addEmployment: employment];
  // Create connection
  [[[OMBEmploymentCreateConnection alloc] initWithEmployment: 
    employment] start];
  [self cancel];
}

@end
