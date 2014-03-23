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
  CGRect screen = [UIScreen mainScreen].bounds;
  CGFloat padding = 20.0f;
  
  [super loadView];
  [self setupForTable];
  // Default no
  isCurrentEmployer = NO;
  
  // Fade background
  fadedBackground = [[UIView alloc] init];
  fadedBackground.alpha = 0.0f;
  fadedBackground.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.8f];
  fadedBackground.frame = screen;
  [self.view addSubview: fadedBackground];
  UITapGestureRecognizer *tapGesture =
  [[UITapGestureRecognizer alloc] initWithTarget: self
    action: @selector(hidePickerView)];
  [fadedBackground addGestureRecognizer: tapGesture];
  
  // Picker view container
  pickerViewContainer = [UIView new];
  [self.view addSubview: pickerViewContainer];
  
  // Header for picker view with cancel and done button
  UIView *pickerViewHeader = [[UIView alloc] init];
  pickerViewHeader.backgroundColor = [UIColor grayUltraLight];
  pickerViewHeader.frame = CGRectMake(0.0f, 0.0f,
    screen.size.width, 44.0f);
  [pickerViewContainer addSubview: pickerViewHeader];
  
  pickerViewHeaderLabel = [[UILabel alloc] init];
  pickerViewHeaderLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  pickerViewHeaderLabel.frame = pickerViewHeader.frame;
  pickerViewHeaderLabel.textAlignment = NSTextAlignmentCenter;
  pickerViewHeaderLabel.textColor = [UIColor textColor];
  [pickerViewHeader addSubview: pickerViewHeaderLabel];
  // Cancel button
  UIButton *cancelButton = [UIButton new];
  cancelButton.titleLabel.font = [UIFont fontWithName:
    @"HelveticaNeue-Medium" size: 15];
  CGRect neighborhoodCancelButtonRect = [@"Cancel" boundingRectWithSize:
    CGSizeMake(pickerViewHeader.frame.size.width, pickerViewHeader.frame.size.height)
      font: cancelButton.titleLabel.font];
  cancelButton.frame = CGRectMake(padding, 0.0f,
    neighborhoodCancelButtonRect.size.width, pickerViewHeader.frame.size.height);
  [cancelButton addTarget: self
    action: @selector(cancelPicker)
      forControlEvents: UIControlEventTouchUpInside];
  [cancelButton setTitle: @"Cancel" forState: UIControlStateNormal];
  [cancelButton setTitleColor: [UIColor blueDark]
     forState: UIControlStateNormal];
  [pickerViewHeader addSubview: cancelButton];
  // Done button
  UIButton *doneButton = [UIButton new];
  doneButton.titleLabel.font = cancelButton.titleLabel.font;
  CGRect doneButtonRect = [@"Done" boundingRectWithSize:
    CGSizeMake(pickerViewHeader.frame.size.width,
      pickerViewHeader.frame.size.height)
        font: doneButton.titleLabel.font];
  doneButton.frame = CGRectMake(pickerViewHeader.frame.size.width -
    (padding + doneButtonRect.size.width), 0.0f,
      doneButtonRect.size.width, pickerViewHeader.frame.size.height);
  [doneButton addTarget: self
     action: @selector(donePicker)
       forControlEvents: UIControlEventTouchUpInside];
  [doneButton setTitle: @"Done" forState: UIControlStateNormal];
  [doneButton setTitleColor: [UIColor blueDark]
     forState: UIControlStateNormal];
  [pickerViewHeader addSubview: doneButton];
  
  
  // Move-in picker
  moveInPicker = [UIDatePicker new];
	moveInPicker.backgroundColor = [UIColor whiteColor];
  moveInPicker.datePickerMode = UIDatePickerModeDate;
  moveInPicker.frame = CGRectMake(0.0f,
    pickerViewHeader.frame.origin.y +
      pickerViewHeader.frame.size.height,
        moveInPicker.frame.size.width, moveInPicker.frame.size.height);
  // moveInPicker.minimumDate    = [NSDate date];
  // specify max date
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"dd-MM-yyyy"];
  NSDate *dateFromString1 = [[NSDate alloc] init];
  dateFromString1 = [df dateFromString:@"31-12-2015"];
  // moveInPicker.maximumDate = dateFromString1;
  moveInPicker.date = moveInPicker.maximumDate = [NSDate date];
  
  // Move-out picker
  moveOutPicker = [UIDatePicker new];
	moveOutPicker.backgroundColor = [UIColor whiteColor];
  moveOutPicker.datePickerMode = UIDatePickerModeDate;
  moveOutPicker.frame = moveInPicker.frame;
  // moveOutPicker.minimumDate = [NSDate date];
  // specify max date
  NSDate *dateFromString2 = [[NSDate alloc] init];
  dateFromString2 = [df dateFromString:@"31-12-2015"];
  // moveOutPicker.maximumDate = dateFromString2;
  moveOutPicker.date = moveOutPicker.maximumDate = moveInPicker.maximumDate;
  
  // Picker View Container
  pickerViewContainer.frame = CGRectMake(0.0f, self.view.frame.size.height,
    moveInPicker.frame.size.width,
      pickerViewHeader.frame.size.height +
        moveInPicker.frame.size.height);
  
  // Date formatter
  dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"yyyy-MM-d HH:mm:ss ZZZ";
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
    // Company name and Title
    if (row == OMBRenterInfoAddEmploymentSectionFieldsRowCompanyName) {
      imageName = @"business_icon_black.png";
      static NSString *LabelTextCellID = @"TwoLabelTextCellID";
      OMBTwoLabelTextFieldCell *cell =
        [tableView dequeueReusableCellWithIdentifier: LabelTextCellID];
      if (!cell) {
        cell = [[OMBTwoLabelTextFieldCell alloc] initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier: LabelTextCellID];
        [cell setFrameUsingIconImageView];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
      // Company name
      cell.firstIconImageView.image =
        [UIImage image: [UIImage imageNamed: imageName]
          size: cell.firstIconImageView.frame.size];
      cell.firstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.firstTextField.delegate  = self;
      cell.firstTextField.font = [UIFont normalTextFont];
      cell.firstTextField.indexPath = indexPath;
      cell.firstTextField.placeholder = @"Company";
      [cell.firstTextField addTarget: self action: @selector(textFieldDidChange:)
         forControlEvents: UIControlEventEditingChanged];
      
      // Title
      cell.secondTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.secondTextField.delegate  = self;
      cell.secondTextField.font = cell.firstTextField.font;
      cell.secondTextField.indexPath =
        [NSIndexPath indexPathForRow: OMBRenterInfoAddEmploymentSectionFieldsRowTitle
          inSection: indexPath.section] ;
      cell.secondTextField.placeholder = @"Title";
      [cell.secondTextField addTarget: self action: @selector(textFieldDidChange:)
         forControlEvents: UIControlEventEditingChanged];
      return cell;
      
    }
    // Income
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowIncome) {
      imageName         = @"money_icon_black.png";
      placeholderString = @"Monthly income";
      cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    // Start date
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowStartDate) {
      imageName         = @"calendar_icon_black.png";
      placeholderString = @"Start date";
      cell.selectionStyle = UITableViewCellSelectionStyleDefault;
      cell.textField.userInteractionEnabled = NO;
      if (moveInDate) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"MMMM yyyy";
        cell.textField.text = [dateFormat stringFromDate:
           [NSDate dateWithTimeIntervalSince1970: moveInDate]];
      }
    }
    // End date
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowEndDate) {
      imageName         = @"calendar_icon_black.png";
      placeholderString = @"End date";
      cell.selectionStyle = UITableViewCellSelectionStyleDefault;
      cell.textField.userInteractionEnabled = NO;
      if (moveOutDate) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"MMMM yyyy";
        cell.textField.text = [dateFormat stringFromDate:
          [NSDate dateWithTimeIntervalSince1970: moveOutDate]];
      }
    }
    // Switch
    else if(row == OMBRenterInfoAddEmploymentSectionFieldsRowSwitch){
      static NSString *LabelTextCellID = @"LabelSwitchCellID";
      OMBLabelSwitchCell *cell =
      [tableView dequeueReusableCellWithIdentifier: LabelTextCellID];
      if (!cell) {
        cell = [[OMBLabelSwitchCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: LabelTextCellID];
        [cell setFrameUsingSize: CGSizeMake(self.table.frame.size.width, OMBStandardButtonHeight)];
      }
      
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.textField.hidden = YES;
      cell.textFieldLabel.font = [UIFont normalTextFont];
      cell.textFieldLabel.text = @"This is my current employer";
      [cell addTarget:self action:@selector(switchFields)];
      return cell;
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
    empty.backgroundColor = [UIColor grayUltraLight];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Move-in date
  if(indexPath.row == OMBRenterInfoAddEmploymentSectionFieldsRowStartDate){
    [self.table scrollToRowAtIndexPath: indexPath
      atScrollPosition: UITableViewScrollPositionTop animated: YES];
    [self showPickerView: (UIPickerView *)moveInPicker];
  }
  // Move-out date
  else if (indexPath.row == OMBRenterInfoAddEmploymentSectionFieldsRowEndDate){
    [self.table scrollToRowAtIndexPath: indexPath
      atScrollPosition: UITableViewScrollPositionTop animated: YES];
    [self showPickerView: (UIPickerView *)moveOutPicker];
  }
  
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger section = indexPath.section;
  
  if (section == OMBRenterInfoAddEmploymentSectionFields) {
    if (indexPath.row == OMBRenterInfoAddEmploymentSectionFieldsRowTitle)
      return 0.0f;
    // Current employer
    else if(indexPath.row == OMBRenterInfoAddEmploymentSectionFieldsRowEndDate && isCurrentEmployer)
      return 0.0f;
      
    return [OMBLabelTextFieldCell heightForCellWithIconImageView];
  }
  else if (section == OMBRenterInfoAddEmploymentSectionSpacing) {
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
  
  // [self scrollToRectAtIndexPath: textField.indexPath];

  if (textField.indexPath.row == OMBRenterInfoAddEmploymentSectionFieldsRowTitle)
    [self scrollToRowAtIndexPath:
      [NSIndexPath indexPathForRow:
        OMBRenterInfoAddEmploymentSectionFieldsRowCompanyName
          inSection:textField.indexPath.section]];
  else
    [self scrollToRowAtIndexPath: textField.indexPath];

}

#pragma mark - Methods

#pragma mark - Instance Methods


- (void) cancelPicker
{
  [self updatePicker];
  [self hidePickerView];
}

- (void) donePicker
{
  [self hidePickerView];
  
  // Move-in Date
  if ([moveInPicker superview]) {
    moveInDate = [moveInPicker.date timeIntervalSince1970];
    // compare if move out is earlier than move in
    if([[NSDate dateWithTimeIntervalSince1970: moveOutDate]
        compare:moveInPicker.date] == NSOrderedAscending){
      //change move out
      moveOutDate = [moveInPicker.date timeIntervalSince1970];
    }
    //leaseMonths = [self numberOfMonthsBetweenMovingDates];
  }
  // Move-out Date
  else if ([moveOutPicker superview]) {
    moveOutDate = [moveOutPicker.date timeIntervalSince1970];
    // compare if move in is later than move out
    if([[NSDate dateWithTimeIntervalSince1970: moveInDate]
        compare:moveOutPicker.date] == NSOrderedDescending){
      //change move in
      moveInDate = [moveOutPicker.date timeIntervalSince1970];
    }
    //leaseMonths = [self numberOfMonthsBetweenMovingDates];
  }
  
  [self updatePicker];
}

- (void) hidePickerView
{
  isShowPicker = NO;
  CGRect rect = pickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 0.0f;
    pickerViewContainer.frame = rect;
  }];
}

- (void) removePickers
{
  [moveInPicker removeFromSuperview];
  [moveOutPicker removeFromSuperview];
}

- (void) save
{
  [super save];
  [[self renterApplication] createModelConnection: modelObject
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
    }];
  [[self appDelegate].container startSpinning];

}

- (void) scrollToRowAtIndexPath: (NSIndexPath *) indexPath
{
  [self.table scrollToRowAtIndexPath: indexPath
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void) showPickerView:(UIPickerView *)pickerView
{
  [self.view endEditing:YES];
  
  NSString *titlePicker = @"";
  [self removePickers];
  if ((UIPickerView *)moveInPicker == pickerView) {
		titlePicker = @"Move-in Date";
		[pickerViewContainer addSubview:moveInPicker];
	}
  if ((UIPickerView *)moveOutPicker == pickerView) {
		titlePicker = @"Move-out Date";
		[pickerViewContainer addSubview:moveOutPicker];
	}
	pickerViewHeaderLabel.text = titlePicker;
  isShowPicker = YES;
  CGRect rect = pickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height -
  pickerViewContainer.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 1.0f;
    pickerViewContainer.frame = rect;
  }];
}

- (void) switchFields
{
  isCurrentEmployer = !isCurrentEmployer;
  if (isCurrentEmployer)
    [valueDictionary setObject: [NSNull null] forKey: @"endDate"];
  [self.table reloadRowsAtIndexPaths:
    @[[NSIndexPath indexPathForRow:OMBRenterInfoAddEmploymentSectionFieldsRowEndDate
      inSection:OMBRenterInfoAddEmploymentSectionFields]]
        withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  NSInteger row = textField.indexPath.row;
  NSString *string = textField.text;
  
  if ([string length]) {
    if (row == OMBRenterInfoAddEmploymentSectionFieldsRowCompanyName) {
      [valueDictionary setObject: string forKey: @"companyName"];
    }
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowTitle) {
      [valueDictionary setObject: string forKey: @"title"];
    }
    else if (row == OMBRenterInfoAddEmploymentSectionFieldsRowIncome) {
      [valueDictionary setObject: string forKey: @"income"];
    }
  }
}

- (void) updatePicker
{
  // Move-in date picker
  [moveInPicker setDate:
    [NSDate dateWithTimeIntervalSince1970: moveInDate]
      animated: NO];
  
  // Move-out date picker
  [moveOutPicker setDate:
    [NSDate dateWithTimeIntervalSince1970: moveOutDate]
      animated: NO];
  
  [valueDictionary setObject: [NSNumber numberWithDouble: moveInDate] 
    forKey: @"startDate"];
  if (isCurrentEmployer)
    [valueDictionary setObject: [NSNull null] forKey: @"endDate"];
  else
    [valueDictionary setObject: [NSNumber numberWithDouble: moveOutDate] 
      forKey: @"endDate"];
  
  [self.table reloadRowsAtIndexPaths:
   @[[NSIndexPath indexPathForRow: OMBRenterInfoAddEmploymentSectionFieldsRowStartDate inSection: OMBRenterInfoAddEmploymentSectionFields],
     [NSIndexPath indexPathForRow: OMBRenterInfoAddEmploymentSectionFieldsRowEndDate inSection: OMBRenterInfoAddEmploymentSectionFields]]
      withRowAnimation: UITableViewRowAnimationNone];
}

@end
