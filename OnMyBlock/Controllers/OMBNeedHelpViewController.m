//
//  OMBNeedHelpViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/18/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBNeedHelpViewController.h"

#import "NSString+Extensions.h"
#import "NSString+OnMyBlock.h"
#import "NSString+PhoneNumber.h"
#import "OMBAlertViewBlur.h"
#import "OMBMapViewController.h"
#import "OMBNeedHelpCell.h"
#import "OMBNeedHelpTextFieldCell.h"
#import "OMBNeedHelpTwoTextFieldCell.h"
#import "OMBNeedHelpTitleCell.h"
#import "OMBTextFieldToolbar.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"

@implementation OMBNeedHelpViewController

- (id)init
{
  if (!(self = [super init]))
    return nil;
  
  self.title = @"Need a place now?";
  
  return self;
}

- (void)loadView
{
  [super loadView];
  
  CGRect screen = [UIScreen mainScreen].bounds;
  float padding = OMBPadding;
  
  fadedBackground = [[UIView alloc] init];
  fadedBackground.alpha = 0.0f;
  fadedBackground.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.8f];
  fadedBackground.frame = screen;
  [self.view addSubview: fadedBackground];
  UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget: self
      action: @selector(hidePickerView)];
  [fadedBackground addGestureRecognizer: tapGesture];
  
  // Action button
  submitButton = [UIButton new];
  submitButton.backgroundColor = [UIColor blueAlpha: 0.8f];
  submitButton.clipsToBounds = YES;
  submitButton.frame = CGRectMake(OMBPadding,
    OMBPadding, (self.view.frame.size.width - 2 * OMBPadding),
        OMBStandardButtonHeight);
  submitButton.layer.cornerRadius = OMBCornerRadius;
  submitButton.titleLabel.font = [UIFont mediumTextFont];
  [submitButton addTarget:self action:@selector(submit)
    forControlEvents:UIControlEventTouchUpInside];
  [submitButton setBackgroundImage: [UIImage imageWithColor:
    [UIColor blueHighlightedAlpha: 0.8f]]
      forState: UIControlStateHighlighted];
  [submitButton setTitle: @"Submit" forState: UIControlStateNormal];
  [submitButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  
  // Textfield toolbar
  textFieldToolbar = [OMBTextFieldToolbar new];
  textFieldToolbar.cancelBarButtonItem.action = @selector(cancel);
  textFieldToolbar.cancelBarButtonItem.target = self;
  textFieldToolbar.doneBarButtonItem.action   = @selector(done);
  textFieldToolbar.doneBarButtonItem.target   = self;
  textFieldToolbar.frame = CGRectMake(0.0f, 0.0f,
    screen.size.width, OMBStandardHeight);
  
  // Aditional Text
  aditionalTextView = [UITextView new];
  aditionalTextView.backgroundColor = UIColor.whiteColor;
  aditionalTextView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
  aditionalTextView.delegate = self;
  aditionalTextView.font = [UIFont normalSmallTextFont];
  aditionalTextView.frame = CGRectMake(padding, padding,
    screen.size.width - (padding * 2), padding * 5);
  aditionalTextView.inputAccessoryView = textFieldToolbar;
  aditionalTextView.layer.cornerRadius = OMBCornerRadius;
  aditionalTextView.textColor = [UIColor textColor];
  
  // Picker view container
  pickerViewContainer = [UIView new];
  [self.view addSubview: pickerViewContainer];
  
  // Header for picker view with cancel and done button
  UIView *pickerViewHeader = [[UIView alloc] init];
  pickerViewHeader.backgroundColor = [UIColor grayUltraLight];
  pickerViewHeader.frame = CGRectMake(0.0f, 0.0f,
    screen.size.width, 44.0f);
  [pickerViewContainer addSubview: pickerViewHeader];
  
  pickerViewHeaderTitle = [[UILabel alloc] init];
  pickerViewHeaderTitle.font = [UIFont normalTextFontBold];
  pickerViewHeaderTitle.frame = pickerViewHeader.frame;
  pickerViewHeaderTitle.text = @"";
  pickerViewHeaderTitle.textAlignment = NSTextAlignmentCenter;
  pickerViewHeaderTitle.textColor = [UIColor textColor];
  [pickerViewHeader addSubview: pickerViewHeaderTitle];
  
  // Cancel button
  UIButton *cancelButton = [UIButton new];
  cancelButton.titleLabel.font = [UIFont normalTextFontBold];
  CGRect cancelButtonRect = [@"Cancel" boundingRectWithSize:
    CGSizeMake(pickerViewHeader.frame.size.width, pickerViewHeader.frame.size.height)
      font: cancelButton.titleLabel.font];
  cancelButton.frame = CGRectMake(padding, 0.0f,
    cancelButtonRect.size.width, pickerViewHeader.frame.size.height);
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
  
  // Lease type picker
  leaseLengthPicker = [[UIPickerView alloc] init];
  leaseLengthPicker.backgroundColor = [UIColor whiteColor];
  leaseLengthPicker.dataSource = self;
  leaseLengthPicker.delegate   = self;
  leaseLengthPicker.frame = CGRectMake(0.0f,
    pickerViewHeader.frame.origin.y +
      pickerViewHeader.frame.size.height,
        leaseLengthPicker.frame.size.width,
          leaseLengthPicker.frame.size.height);
  
  budgetPickerViewRows = 8000 / 500;
  budgetPickerView = [[UIPickerView alloc] init];
  budgetPickerView.backgroundColor = [UIColor whiteColor];
  budgetPickerView.dataSource = self;
  budgetPickerView.delegate   = self;
  
  auxRowMinBudget = 0;
  auxRowMaxBudget = [self pickerView:budgetPickerView
    numberOfRowsInComponent:1] - 1;
  
	budgetMinString = [self pickerView:
    budgetPickerView titleForRow: auxRowMinBudget forComponent:0];
	budgetMaxString = [self pickerView:
    budgetPickerView titleForRow: auxRowMaxBudget forComponent:1];
  
	[budgetPickerView selectRow: auxRowMinBudget inComponent: 0 animated: NO];
  [budgetPickerView selectRow: auxRowMaxBudget inComponent: 1 animated: NO];
  
  budgetPickerView.frame = CGRectMake(0.0f,
    pickerViewHeader.frame.origin.y +
      pickerViewHeader.frame.size.height,
        budgetPickerView.frame.size.width, budgetPickerView.frame.size.height);
  
  float widthSeparator = 70.f;
  UILabel *pickerSeparator = [[UILabel alloc] init];
  pickerSeparator.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  pickerSeparator.frame =
    CGRectMake((budgetPickerView.frame.size.width - widthSeparator) * 0.5f,
      (budgetPickerView.frame.size.height - widthSeparator) * 0.5f,
        widthSeparator, widthSeparator);
  pickerSeparator.text = @"-";
  pickerSeparator.textAlignment = NSTextAlignmentCenter;
  pickerSeparator.textColor = [UIColor textColor];
  [budgetPickerView addSubview:pickerSeparator];
  
  pickerViewContainer.frame =
    CGRectMake(0.0f, self.view.frame.size.height,
      leaseLengthPicker.frame.size.width,
        pickerViewHeader.frame.size.height +
          leaseLengthPicker.frame.size.height);
  
  
    alertViewBlur = [OMBAlertViewBlur new];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  valuesDictionary = [NSMutableDictionary dictionary];
  
  // Lease Length
  leaseOptions =
    @[
      @"Month to month",@"1 month lease",@"2 months lease",
      @"3 months lease",@"4 months lease",@"5 months lease",
      @"6 months lease",@"7 months lease",@"8 months lease",
      @"9 months lease",@"10 months lease",@"11 months lease",
      @"12 months lease"
    ];
  
  // Detail
  detailString =
    @"Need to move in soon? Tell us know what you're "
    @"looking for and we'll help you find a place now.";
  
  detailFont = [UIFont mediumTextFontBold];
  
  detailHeight = [detailString boundingRectWithSize:
    CGSizeMake(self.table.frame.size.width - (20.f * 2), 9999)
      font: detailFont].size.height;
  
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  // Fields required
  indexRequired = @[
    @"first_name",
    @"last_name",
    @"phone",
    @"email",
    @"place"
  ];
  
}

#pragma mark - Protocol

#pragma mark - Protocol UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView
  clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Protocol UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  // Budget
  if (pickerView == budgetPickerView) {
    return 2;
  }
  // Lease Length
  if (pickerView == leaseLengthPicker) {
    return 1;
  }
  
  return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
  numberOfRowsInComponent:(NSInteger)component
{
  // Budget
  if (pickerView == budgetPickerView) {
    return budgetPickerViewRows;
  }
  // Lease Length
  else if (pickerView == leaseLengthPicker) {
    return leaseOptions.count;
  }
  
  return 0;
}

#pragma mark - Protocol UIPickerViewDelegate

- (void) pickerView: (UIPickerView *) pickerView
  didSelectRow: (NSInteger) row inComponent: (NSInteger) component
{
  
  if (pickerView == budgetPickerView) {
    
    if (component == 0) {
      auxRowMinBudget = row;
    }
    else if (component == 1) {
      auxRowMaxBudget = row;
    }
    
  }
  // Month Lease
  if (pickerView == leaseLengthPicker) {
    auxRowLease = (int)row;
  }
  
}

- (CGFloat) pickerView: (UIPickerView *) pickerView
 rowHeightForComponent: (NSInteger) component
{
  return 44.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
  titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  // Lease Length
  if (pickerView == leaseLengthPicker) {
    return [leaseOptions objectAtIndex:row];
  }
  else if (pickerView == budgetPickerView) {
    if (row == 0) {
      return @"Any";
    }
    
    NSString *string = [NSString numberToCurrencyString: 500 * row];
    if (row == [pickerView numberOfRowsInComponent: component] - 1) {
      string = [string stringByAppendingString: @"+"];
    }
    return string;
  }
  
  return @"";
}

- (CGFloat) pickerView: (UIPickerView *) pickerView
  widthForComponent: (NSInteger) component
{
  // Budget
  if (pickerView == budgetPickerView) {
    return (self.view.frame.size.width - 20.f) * .5f;
  }
  // Lease Length
  else if (pickerView == leaseLengthPicker) {
    return pickerView.bounds.size.width - 40.0f;
  }
  
  return 0.0f;
}

#pragma mark - Protocol UITableViewDelegate

- (void)tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  
  if (section == OMBNeedHelpSectionPhoneCall) {
    [self call];
  }
  if (section == OMBNeedHelpSectionBudget && row == 1) {
    [self showPickerView:budgetPickerView];
  }
  else if (section == OMBNeedHelpSectionLeaseLength && row == 1) {
    [self showPickerView:leaseLengthPicker];
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  
  // PhoneCall
  if (section == OMBNeedHelpSectionPhoneCall) {
    if (row == 0) {
      return [UIScreen mainScreen].bounds.size.height *
        PropertyInfoViewImageHeightPercentage;
    }
  }
  // Detail
  else if (section == OMBNeedHelpSectionDetail) {
    if (row == 0) {
      return OMBPadding * 1.5f + detailHeight + OMBPadding * 1.5f;
    }
  }
  // Submit
  else if (section == OMBNeedHelpSectionSubmit) {
    return OMBPadding + submitButton.frame.size.height + OMBPadding;
  }
  // Spacing
  else if (section == OMBNeedHelpSectionSpacing) {
    if (keyboardIsVisible) {
      return OMBKeyboardHeight + textFieldToolbar.frame.size.height;
    }
  }
  
  // Title Form
  else if (row == 0) {
    return [OMBNeedHelpTitleCell heightForCell];
  }
  // Firs & Last Name
  else if (section == OMBNeedHelpSectionFirsLastName) {
    return [OMBNeedHelpTwoTextFieldCell heightForCell];
  }
  // Phone
  else if (section == OMBNeedHelpSectionPhone ||
           section == OMBNeedHelpSectionEmail ||
           section == OMBNeedHelpSectionSchool ||
           section == OMBNeedHelpSectionPlace ||
           section == OMBNeedHelpSectionBedrooms) {
    return [OMBNeedHelpTextFieldCell heightForCell];
  }
  // Budget
  else if (section == OMBNeedHelpSectionBudget) {
    return [OMBNeedHelpTextFieldCell heightForCell];
  }
  // LeaseLength
  else if (section == OMBNeedHelpSectionLeaseLength) {
    return [OMBNeedHelpTextFieldCell heightForCell];
  }
  // Aditional
  else if (section == OMBNeedHelpSectionAditional) {
    return OMBPadding + aditionalTextView.frame.size.height + OMBPadding;
  }
  
  return 0.0f;
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // PhoneCall
  // Detail
  // FirsLastName
  // Phone
  // Email
  // School
  // Place
  // Bedrooms
  // Budget
  // LeaseLength
  // Aditional
  // Submit
  // Spacing
  return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  float padding = OMBPadding;
  
  static NSString *emptyCellID = @"emptyCellID";
  UITableViewCell *emptyCell = [tableView
    dequeueReusableCellWithIdentifier:emptyCellID];
  
  if (!emptyCell) {
    emptyCell = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleDefault reuseIdentifier:emptyCellID];
  }
  
  // Phone Call
  if (section == OMBNeedHelpSectionPhoneCall) {
    
    if (row == 0) {
      static NSString *callCellID = @"callCellID";
      OMBNeedHelpCell *cell = [tableView
        dequeueReusableCellWithIdentifier:callCellID];
      
      if (!cell) {
        cell = [[OMBNeedHelpCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:callCellID];
        cell.titleLabel.text = @"Call us";
        cell.secondLabel.text = [self phoneNumberFormated:YES];
        [cell setBackgroundImage:@"ios_house" withBlur:YES];
      }
      
      return cell;
    }
  }
  // Detail
  else if (section == OMBNeedHelpSectionDetail) {
    static NSString *detailCellID = @"detailCellID";
    UITableViewCell *cell = [tableView
      dequeueReusableCellWithIdentifier: detailCellID];
    
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier: detailCellID];
      
      UILabel *label = [UILabel new];
      label.font = detailFont;
      label.frame = CGRectMake(padding, padding * 1.5f,
        tableView.frame.size.width - (padding * 2),
          detailHeight);
      label.numberOfLines = 0;
      label.text = detailString;
      label.textAlignment = NSTextAlignmentCenter;
      label.textColor = UIColor.whiteColor;
      [cell.contentView addSubview: label];
    }
    
    cell.backgroundColor = [UIColor blue];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0.0f,
      tableView.frame.size.width, 0.0f, 0.0f);
    cell.clipsToBounds = YES;
    return cell;

  }
  // Form
  // Firs & Last Name
  else if (section == OMBNeedHelpSectionFirsLastName) {
    if (row == 0) {
      NSString *titleFirstLastID = @"titleFirstLastID";
      OMBNeedHelpTitleCell *cell =
        [tableView dequeueReusableCellWithIdentifier:titleFirstLastID];
      if (!cell) {
        cell = [[OMBNeedHelpTitleCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:titleFirstLastID];
      }
      cell.titleLabel.text = @"First Name*\t\t\t   Last Name*";
      
      return cell;
    }
    else {
      NSString *firstLastID = @"firstLastID";
      OMBNeedHelpTwoTextFieldCell *cell = [tableView
        dequeueReusableCellWithIdentifier:firstLastID];
      if (!cell) {
        cell = [[OMBNeedHelpTwoTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:firstLastID];
      }
      cell.textField.delegate = self;
      cell.textField.indexPath = indexPath;
      cell.textField.keyboardType = UIKeyboardTypeDefault;
      cell.textField.tag = 1;
      [cell.textField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      
      cell.secondTextField.delegate = self;
      cell.secondTextField.indexPath = indexPath;
      cell.secondTextField.keyboardType = UIKeyboardTypeDefault;
      cell.secondTextField.tag = 2;
      [cell.secondTextField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      
      return cell;
    }
  }
  // Phone
  else if (section == OMBNeedHelpSectionPhone) {
    if (row == 0) {
      NSString *titlePhoneNumberID = @"titlePhoneNumberID";
      OMBNeedHelpTitleCell *cell =
        [tableView dequeueReusableCellWithIdentifier:titlePhoneNumberID];
      if (!cell) {
        cell = [[OMBNeedHelpTitleCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:titlePhoneNumberID];
      }
      cell.titleLabel.text = @"Phone number*";
      
      return cell;
    }
    else {
      NSString *phoneCellID = @"phoneCellID";
      OMBNeedHelpTextFieldCell *cell = [tableView
        dequeueReusableCellWithIdentifier:phoneCellID];
      if (!cell) {
        cell = [[OMBNeedHelpTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:phoneCellID];
      }
      cell.textField.delegate = self;
      cell.textField.indexPath = indexPath;
      cell.textField.keyboardType = UIKeyboardTypePhonePad;
      [cell.textField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      
      return cell;
    }
  }
  // Email
  else if (section == OMBNeedHelpSectionEmail) {
    if (row == 0) {
      NSString *titleEmailID = @"titleEmailID";
      OMBNeedHelpTitleCell *cell = [tableView
        dequeueReusableCellWithIdentifier:titleEmailID];
      if (!cell) {
        cell = [[OMBNeedHelpTitleCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:titleEmailID];
      }
      cell.titleLabel.text = @"Email*";
      
      return cell;
    }
    else {
      NSString *emailCellID = @"emailCellID";
      OMBNeedHelpTextFieldCell *cell = [tableView
        dequeueReusableCellWithIdentifier:emailCellID];
      if (!cell) {
        cell = [[OMBNeedHelpTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:emailCellID];
      }
      cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
      cell.textField.delegate = self;
      cell.textField.indexPath = indexPath;
      cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
      [cell.textField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      
      return cell;
    }
  }
  // School
  else if (section == OMBNeedHelpSectionSchool) {
    if (row == 0) {
      NSString *titleSchoolID = @"titleSchoolID";
      OMBNeedHelpTitleCell *cell = [tableView
        dequeueReusableCellWithIdentifier:titleSchoolID];
      if (!cell) {
        cell = [[OMBNeedHelpTitleCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:titleSchoolID];
      }
      cell.titleLabel.text = @"School";
      
      return cell;
    }
    else {
      NSString *schoolCellID = @"schoolCellID";
      OMBNeedHelpTextFieldCell *cell = [tableView
        dequeueReusableCellWithIdentifier:schoolCellID];
      if (!cell) {
        cell = [[OMBNeedHelpTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:schoolCellID];
      }
      cell.textField.delegate = self;
      cell.textField.indexPath = indexPath;
      cell.textField.keyboardType = UIKeyboardTypeDefault;
      [cell.textField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      
      return cell;
    }
  }
  // Place
  else if (section == OMBNeedHelpSectionPlace) {
    if (row == 0) {
      NSString *titlePlaceID = @"titlePlaceID";
      OMBNeedHelpTitleCell *cell =
        [tableView dequeueReusableCellWithIdentifier:titlePlaceID];
      if (!cell) {
        cell = [[OMBNeedHelpTitleCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:titlePlaceID];
      }
      cell.titleLabel.text = @"Where would you like to live?*";
      
      return cell;
    }
    else {
      NSString *placeCellID = @"placeCellID";
      OMBNeedHelpTextFieldCell *cell = [tableView
        dequeueReusableCellWithIdentifier:placeCellID];
      if (!cell) {
        cell = [[OMBNeedHelpTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:placeCellID];
      }
      cell.textField.delegate = self;
      cell.textField.indexPath = indexPath;
      [cell.textField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      
      return cell;
    }
  }
  // Bedrooms
  else if (section == OMBNeedHelpSectionBedrooms) {
    if (row == 0) {
      NSString *titleBedroomsID = @"titleBedroomsID";
      OMBNeedHelpTitleCell *cell = [tableView
        dequeueReusableCellWithIdentifier:titleBedroomsID];
      if (!cell) {
        cell = [[OMBNeedHelpTitleCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:titleBedroomsID];
      }
      cell.titleLabel.text = @"Number of bedrooms";
      
      return cell;
    }
    else {
      NSString *bedroomCellID = @"bedroomCellID";
      OMBNeedHelpTextFieldCell *cell = [tableView
        dequeueReusableCellWithIdentifier:bedroomCellID];
      if (!cell) {
        cell = [[OMBNeedHelpTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:bedroomCellID];
      }
      cell.textField.delegate = self;
      cell.textField.indexPath = indexPath;
      cell.textField.keyboardType = UIKeyboardTypeNumberPad;
      [cell.textField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      
      return cell;
    }
  }
  // Budget
  else if (section == OMBNeedHelpSectionBudget) {
    if (row == 0) {
      NSString *titleBudgetID = @"titleBudgetID";
      OMBNeedHelpTitleCell *cell =
      [tableView dequeueReusableCellWithIdentifier:titleBudgetID];
      if (!cell) {
        cell = [[OMBNeedHelpTitleCell alloc] initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:titleBudgetID];
      }
      cell.titleLabel.text = @"Budget Range";
      
      return cell;
    }
    else {
      NSString *budgetID = @"budgetID";
      OMBNeedHelpTextFieldCell *cell = [tableView
        dequeueReusableCellWithIdentifier:budgetID];
      if (!cell) {
        cell = [[OMBNeedHelpTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:budgetID];
      }
      
      cell.textField.indexPath = indexPath;
      cell.textField.userInteractionEnabled = NO;
      
      return cell;
    }
  }
  // Lease Length
  else if (section == OMBNeedHelpSectionLeaseLength) {
    if (row == 0) {
      NSString *titleLeaseID = @"titleLeaseID";
      OMBNeedHelpTitleCell *cell = [tableView
        dequeueReusableCellWithIdentifier:titleLeaseID];
      if (!cell) {
        cell = [[OMBNeedHelpTitleCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:titleLeaseID];
      }
      cell.titleLabel.text = @"Prefered lease length";
      
      return cell;
    }
    else {
      NSString *leaseID = @"leaseID";
      OMBNeedHelpTextFieldCell *cell = [tableView
         dequeueReusableCellWithIdentifier:leaseID];
      if (!cell) {
        cell = [[OMBNeedHelpTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:leaseID];
      }
      cell.textField.indexPath = indexPath;
      cell.textField.userInteractionEnabled = NO;
      
      return cell;
    }
  }
  // Aditional
  else if (section == OMBNeedHelpSectionAditional) {
    if (row == 0) {
      NSString *titleAditionalID = @"titleAditionalID";
      OMBNeedHelpTitleCell *cell = [tableView
        dequeueReusableCellWithIdentifier:titleAditionalID];
      if (!cell) {
        cell = [[OMBNeedHelpTitleCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:titleAditionalID];
      }
      cell.titleLabel.text = @"Anything else we should know?";
      
      return cell;
    }
    else {
      static NSString *AditionalCellID = @"AditionalCellID";
      UITableViewCell *cell = [tableView
        dequeueReusableCellWithIdentifier: AditionalCellID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: AditionalCellID];
        [aditionalTextView removeFromSuperview];
        [cell.contentView addSubview: aditionalTextView];
      }
      
      cell.backgroundColor = [UIColor grayUltraLight];
      cell.clipsToBounds = YES;
      cell.separatorInset = UIEdgeInsetsMake(0.0f,
        tableView.frame.size.width, 0.0f, 0.0f);
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
      return cell;
    }
  }
  // Submit
  else if (section == OMBNeedHelpSectionSubmit) {
    static NSString *submitCellID = @"submitCellID";
    UITableViewCell *cell = [tableView
      dequeueReusableCellWithIdentifier:submitCellID];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier: submitCellID];
      [cell.contentView addSubview:submitButton];
    }
    
    cell.backgroundColor = [UIColor grayUltraLight];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0.0f,
      tableView.frame.size.width, 0.0f, 0.0f);
    cell.clipsToBounds = YES;
    
    return cell;
  }
  // Spacing
  else if (section == OMBNeedHelpSectionSpacing) {
    
    emptyCell.backgroundColor = UIColor.clearColor;
    emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    emptyCell.separatorInset = UIEdgeInsetsMake(0.0f,
      tableView.frame.size.width, 0.0f, 0.0f);
    return emptyCell;
  }
  
  return emptyCell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
  
  // Phone Call
  if (section == OMBNeedHelpSectionPhoneCall) {
    return 1;
  }
  // Detail
  else if (section == OMBNeedHelpSectionDetail) {
    return 1;
  }
  // Submit
  else if (section == OMBNeedHelpSectionSubmit) {
    return 1;
  }
  // Form
  else if (section == OMBNeedHelpSectionFirsLastName ||
           section == OMBNeedHelpSectionPhone ||
           section == OMBNeedHelpSectionEmail ||
           section == OMBNeedHelpSectionSchool ||
           section == OMBNeedHelpSectionPlace ||
           section == OMBNeedHelpSectionBedrooms ||
           section == OMBNeedHelpSectionBudget ||
           section == OMBNeedHelpSectionLeaseLength ||
           section == OMBNeedHelpSectionAditional) {
    // Title
    // Field
    return 2;
  }
  // Spacing
  else if (section == OMBNeedHelpSectionSpacing) {
    return 1;
  }
  
  return 0;
}

#pragma mark - Protocol UITextFieldDelegate

- (void)textFieldDidBeginEditing:(TextFieldPadding *)textField
{
  textField.layer.borderColor = [UIColor blue].CGColor;
  textField.layer.borderWidth = 1.f;
  
  keyboardIsVisible = YES;
  textField.inputAccessoryView = textFieldToolbar;
  
  [self.table beginUpdates];
  [self.table endUpdates];
  [self scrollToRectAtIndexPath:textField.indexPath];
}

- (void)textFieldDidEndEditing:(TextFieldPadding *)textField
{
  textField.layer.borderWidth = 0.0f;
  
  // Phone format
  if (textField.indexPath.section == OMBNeedHelpSectionPhone) {
    if ([[textField.text phoneNumberString] length]) {
      textField.text = [textField.text phoneNumberString];
      [valuesDictionary setObject:textField.text forKey:@"phone"];
    }
  }
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self done];
  return YES;
}

#pragma mark - Protocol UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  textView.layer.borderColor = [UIColor blue].CGColor;
  textView.layer.borderWidth = 1.0f;
  
  keyboardIsVisible = YES;
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:
    1 inSection: OMBNeedHelpSectionAditional];
  
  [self.table beginUpdates];
  [self.table endUpdates];
  [self scrollToRectAtIndexPath: indexPath];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
  textView.layer.borderWidth = 0.0f;
}

- (void)textViewDidChange:(UITextView *)textView
{
  [valuesDictionary setObject:textView.text forKey:@"aditional"];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) call
{
  NSString *phone = [@"telprompt://"
    stringByAppendingString:[self phoneNumberFormated:NO]];
  
  NSURL *url = [NSURL URLWithString:phone];
   [[UIApplication sharedApplication] openURL:url];
}

- (void) cancel
{
  [self done];
}

- (void) cancelPicker
{
  [self hidePickerView];
}

- (void) closeAlertView
{
  [alertViewBlur close];
}

- (void) done
{
  keyboardIsVisible = NO;
  [self.view endEditing:YES];
  
  [self.table beginUpdates];
  [self.table endUpdates];
}

- (void) donePicker
{
  [self hidePickerView];
  
  // Budget
  if ([budgetPickerView superview]) {
    OMBNeedHelpTextFieldCell *cell = (OMBNeedHelpTextFieldCell *)
      [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: 1
          inSection: OMBNeedHelpSectionBudget]];
  
    budgetMinString = [self pickerView:budgetPickerView
      titleForRow: auxRowMinBudget forComponent:0];
    
    budgetMaxString = [self pickerView:budgetPickerView
      titleForRow: auxRowMaxBudget forComponent:1];
    
    [valuesDictionary setObject: [NSNumber numberWithInt: 500 * auxRowMinBudget]
        forKey: @"minRent"];
    
    [valuesDictionary setObject: [NSNumber numberWithInt: 500 * auxRowMaxBudget]
        forKey: @"maxRent"];
    
    cell.textField.text = [NSString stringWithFormat:@"%@ - %@",
      budgetMinString, budgetMaxString];

    
  }
  // Lease type
  else if ([leaseLengthPicker superview]) {
    NSString *string = [leaseOptions objectAtIndex: auxRowLease];
   
    OMBNeedHelpTextFieldCell *cell = (OMBNeedHelpTextFieldCell *)
      [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForItem:1
          inSection:OMBNeedHelpSectionLeaseLength]];
    
    cell.textField.text = string;
    [valuesDictionary setObject:@(auxRowLease) forKey:@"lease_length"];
  }

}

- (BOOL) hasCompleteFields
{
  
  // Search for empty textfields in required fields
//  for (NSNumber *number in indexRequired) {
//    NSInteger section = [number integerValue];
//    
//    UITableViewCell *cell = [self.table
//      cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section]];
//    
//    if ([cell isKindOfClass:[OMBNeedHelpTextFieldCell class]]) {
//      
//      int lenght = [((OMBNeedHelpTextFieldCell *)cell).textField.text length];
//      
//      if (lenght == 0) {
//        return NO;
//      }
//    }
//    else if ([cell isKindOfClass:[OMBNeedHelpTwoTextFieldCell class]]) {
//      
//      int lenght1 = [((OMBNeedHelpTwoTextFieldCell *)cell).textField.text length];
//      int lenght2 = [((OMBNeedHelpTwoTextFieldCell *)cell).secondTextField.text length];
//      
//      if (lenght1 == 0 || lenght2 ==0) {
//        return NO;
//      }
//    }
//  }
  
  for (NSString *key in indexRequired) {
    
    if ([valuesDictionary objectForKey: key]) {
      if (![[valuesDictionary objectForKey: key] length]) {
        return NO;
      }
    }
    else {
      return NO;
    }
  }
  
  return YES;
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

- (NSString *)phoneNumberFormated:(BOOL)formated
{
  if (formated) {
    return @"(650) 331-7819";
  }
  
  return @"6503317819";
}

- (void) removePickers
{
  [leaseLengthPicker removeFromSuperview];
  [budgetPickerView removeFromSuperview];
}

- (void) rememberFormSubmitted
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject: [NSNumber numberWithBool: YES]
    forKey: OMBUserDefaultsSentFormHelp];

  [defaults synchronize];
}

- (void) scrollToRectAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect rect = [self.table rectForRowAtIndexPath: indexPath];
  rect.origin.y -= (OMBPadding * 2.5f + textFieldToolbar.frame.size.height);
  [self.table setContentOffset: rect.origin animated: YES];
}

- (void) showPickerView:(UIPickerView *)pickerView
{
  [self.view endEditing:YES];
  keyboardIsVisible = NO;
  
  [self.table beginUpdates];
  [self.table endUpdates];
  
  NSString *titlePicker = @"";
  [self removePickers];
  
  // Lease Length
  if ((UIPickerView *)leaseLengthPicker == pickerView) {
		titlePicker = @"Lease Length";
		[pickerViewContainer addSubview:leaseLengthPicker];
	}
  // Budget
  else if ((UIPickerView *)budgetPickerView == pickerView) {
		titlePicker = @"Budget";
		[pickerViewContainer addSubview:budgetPickerView];
	}
  
	pickerViewHeaderTitle.text = titlePicker;
  isShowPicker = YES;
  
  CGRect rect = pickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height -
    pickerViewContainer.frame.size.height;
  
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 1.0f;
    pickerViewContainer.frame = rect;
  }];
}

- (void) submit
{
  
  if ([self hasCompleteFields]) {
    
    // TODO: send data
    [self rememberFormSubmitted];
    
    [alertViewBlur setTitle: @"Thank you!"];
    [alertViewBlur setMessage: @"We'll contact you with the "
      "perfect college pad soon."];
    [alertViewBlur setConfirmButtonTitle: @"Okay"];
    [alertViewBlur addTargetForConfirmButton: self
      action: @selector(closeAlertView)];
    [alertViewBlur showInView: self.view withDetails: NO];
    [alertViewBlur showOnlyConfirmButton];
    [alertViewBlur hideQuestionButton];

  }
  else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Almost Finished"
      message: @"Some fields are required (*)" delegate: nil
        cancelButtonTitle: @"Continue" otherButtonTitles: nil];
    [alertView show];
  }
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  
  NSString *key;
  NSString *string = textField.text;
  
  if (textField.indexPath.section == OMBNeedHelpSectionFirsLastName) {
    if (textField.tag == 1) {
      key = @"first_name";
    }
    else if (textField.tag == 2) {
      key = @"last_name";
    }
  }
  else if (textField.indexPath.section == OMBNeedHelpSectionPhone) {
    key = @"phone";
  }
  else if (textField.indexPath.section == OMBNeedHelpSectionEmail) {
    key = @"email";
  }
  else if (textField.indexPath.section == OMBNeedHelpSectionSchool) {
    key = @"school";
  }
  else if (textField.indexPath.section == OMBNeedHelpSectionPlace) {
    key = @"place";
  }
  else if (textField.indexPath.section == OMBNeedHelpSectionBedrooms) {
    key = @"bedrooms";
  }
  
  [valuesDictionary setObject:string forKey:key];
  
}

@end
