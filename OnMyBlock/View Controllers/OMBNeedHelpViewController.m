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
//#import "OMBNeedHelpTextFieldCell.h"
//#import "OMBNeedHelpTwoTextFieldCell.h"
//#import "OMBNeedHelpTitleCell.h"
#import "OMBTextFieldToolbar.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"

#import "OMBLabelTextFieldCell.h"
#import "OMBTwoLabelTextFieldCell.h"
#import "UIImage+Resize.h"

// Categories
#import "NSString+PhoneNumber.h"

// Swift
#import "OnMyBlock-Swift.h"

@interface OMBNeedHelpViewController() <HelpDelegate>
{

}
@end

@implementation OMBNeedHelpViewController

- (id)init
{
  if (!(self = [super init])) return nil;

  self.title = @"Need a place now?";

  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [super setupForTable];
  
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
  aditionalTextView.font = [UIFont normalTextFont];
  aditionalTextView.frame = CGRectMake(padding, padding,
    screen.size.width - (padding * 2), padding * 5);
  aditionalTextView.inputAccessoryView = textFieldToolbar;
  aditionalTextView.textColor = [UIColor textColor];
  
  // About text view placeholder
  aditionalPlaceholder = [UILabel new];
  aditionalPlaceholder.font = aditionalTextView.font;
  aditionalPlaceholder.frame = CGRectMake(5.0f, 8.0f,
    aditionalTextView.frame.size.width, 20.0f);
  aditionalPlaceholder.text = @"Anything else we should know?";
  aditionalPlaceholder.textColor = [UIColor grayLight];
  [aditionalTextView addSubview: aditionalPlaceholder];
  
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
    @"Need to move in soon? Let us know what you're "
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
    @"location"
  ];
  
}

#pragma mark - Protocol

#pragma mark - Protocol HelpDelegate

- (void)createHelpForStudentSucceeded
{
  [self containerStopSpinning];
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

- (void)createHelpForStudentFailed:(NSError *)error {
  [self containerStopSpinning];
  [self showAlertViewWithError:error];
}

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
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSInteger section = indexPath.section;
  NSInteger row     = indexPath.row;
  
  if (section == OMBNeedHelpSectionPhoneCall) {
    [self call];
  }
  if (section == OMBNeedHelpSectionForm) {
    if (row == OMBNeedHelpSectionFormRowBudget) {
      [self showPickerView:budgetPickerView];
    }
    else if (row == OMBNeedHelpSectionFormRowLeaseLength) {
      [self showPickerView:leaseLengthPicker];
    }
  }
  
}

- (CGFloat)tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  
  // PhoneCall
  if (section == OMBNeedHelpSectionPhoneCall) {
    return [UIScreen mainScreen].bounds.size.height *
      PropertyInfoViewImageHeightPercentage;
  }
  // Detail
  else if (section == OMBNeedHelpSectionDetail) {
    return OMBPadding * 1.5f + detailHeight + OMBPadding * 1.5f;
  }
  // Form
  else if (section == OMBNeedHelpSectionForm) {
    if (row == OMBNeedHelpSectionFormRowAditional) {
      return OMBPadding + aditionalTextView.frame.size.height + OMBPadding;
    }
    else {
      return [OMBLabelTextFieldCell heightForCellWithIconImageView];
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
  return 0.0f;
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // PhoneCall
  // Detail
  // Form
  // Submit
  // Spacing
  return 5;
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
    static NSString *callCellID = @"callCellID";
    OMBNeedHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:
      callCellID];
    if (!cell) {
      cell = [[OMBNeedHelpCell alloc] initWithStyle:UITableViewCellStyleDefault 
        reuseIdentifier:callCellID];
      // cell.secondLabel.font = [UIFont mediumTextFont];
      // cell.secondLabel.text = [self phoneNumberFormated:YES];
      // cell.titleLabel.font  = [UIFont mediumTextFont];
      // cell.titleLabel.text  = @"Call us";
      [cell addCallButton];
      [cell setBackgroundImage:@"lustre-pearl-exterior-31.jpg" withBlur:YES];
    }
    cell.separatorInset = UIEdgeInsetsMake(0.0f,
      tableView.frame.size.width, 0.0f, 0.0f);
    return cell;
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
  else if (section == OMBNeedHelpSectionForm) {
    if (row == OMBNeedHelpSectionFormRowAditional) {
      static NSString *AditionalCellID = @"AditionalCellID";
      UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier: AditionalCellID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: AditionalCellID];
        [aditionalTextView removeFromSuperview];
        [cell.contentView addSubview: aditionalTextView];
      }
      if ([[aditionalTextView.text stripWhiteSpace] length]) {
        aditionalPlaceholder.hidden = YES;
      }
      else {
        aditionalPlaceholder.hidden = NO;
      }
      
      cell.clipsToBounds = YES;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.separatorInset = UIEdgeInsetsMake(0.0f,
        tableView.frame.size.width, 0.0f, 0.0f);
      
      return cell;
    }
    else {
      
      NSString *formCellID = @"formCellID";
      OMBLabelTextFieldCell *cell = [tableView
        dequeueReusableCellWithIdentifier:formCellID];
      if (!cell) {
        cell = [[OMBLabelTextFieldCell alloc] initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:formCellID];
        [cell setFrameUsingIconImageView];
      }
      
      NSString *placeholder = @"";
      NSString *imageName = @"";
      
      cell.textField.keyboardType = UIKeyboardTypeDefault;
      
      if (row == OMBNeedHelpSectionFormRowFirsLastName) {
        
        imageName = @"user_icon.png";
        static NSString *LabelTextCellID = @"TwoLabelTextCellID";
        OMBTwoLabelTextFieldCell *cell =
        [tableView dequeueReusableCellWithIdentifier: LabelTextCellID];
        if (!cell) {
          cell = [[OMBTwoLabelTextFieldCell alloc] initWithStyle:
                  UITableViewCellStyleDefault reuseIdentifier: LabelTextCellID];
          [cell setFrameUsingIconImageView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // First Name
        cell.firstIconImageView.image =
          [UIImage image: [UIImage imageNamed: imageName]
            size: cell.firstIconImageView.frame.size];
        cell.firstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.firstTextField.delegate  = self;
        cell.firstTextField.font = [UIFont normalTextFont];
        cell.firstTextField.indexPath = indexPath;
        cell.firstTextField.placeholder = @"First Name*";
        cell.firstTextField.tag = 1;
        [cell.firstTextField addTarget: self action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
        
        // Last Name
        cell.secondTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.secondTextField.delegate  = self;
        cell.secondTextField.font = cell.firstTextField.font;
        cell.secondTextField.indexPath = indexPath;
        cell.secondTextField.tag = 2;
        cell.secondTextField.placeholder = @"Last Name*";
        [cell.secondTextField addTarget: self action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
        cell.clipsToBounds = YES;
        return cell;
        
      }
      
      // Phone
      else if (row == OMBNeedHelpSectionFormRowPhone) {
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
        imageName = @"phone_icon.png";
        placeholder = @"Phone number*";
      }
      // Email
      else if (row == OMBNeedHelpSectionFormRowEmail) {
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        imageName = @"messages_icon_dark.png";
        placeholder = @"Email*";
      }
      // School
      else if (row == OMBNeedHelpSectionFormRowSchool) {
        imageName = @"school_icon.png";
        placeholder = @"School";
      }
      // Place
      else if (row == OMBNeedHelpSectionFormRowPlace) {
        imageName = @"location_icon_black";
        placeholder = @"Where would you like to live?*";
      }
      // Bedrooms
      else if (row == OMBNeedHelpSectionFormRowBedrooms) {
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        imageName = @"bed_icon_black.png";
        placeholder = @"Number of bedrooms";
      }
      // Budget
      else if (row == OMBNeedHelpSectionFormRowBudget) {
        cell.textField.userInteractionEnabled = NO;
        imageName = @"moneybag_icon_black.png";
        placeholder = @"Budget Range";
      }
      // Lease Length
      else if (row == OMBNeedHelpSectionFormRowLeaseLength) {
        cell.textField.userInteractionEnabled = NO;
        imageName = @"calendar_icon_black.png";
        placeholder = @"Prefered lease Length";
      }
      
      cell.clipsToBounds = YES;
      cell.iconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
        size: cell.iconImageView.frame.size];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.textField.delegate = self;
      cell.textField.font = [UIFont normalTextFont];
      cell.textField.indexPath = indexPath;
      cell.textField.placeholder = placeholder;
      cell.textField.textColor = [UIColor textColor];
      [cell.textField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      
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
  // Form
  else if (section == OMBNeedHelpSectionForm) {
    // FirsLastName
    // Phone
    // Email
    // School
    // Place
    // Bedrooms
    // Budget
    // LeaseLength
    // Aditional
    return 9;
  }
  // Submit
  else if (section == OMBNeedHelpSectionSubmit) {
    return 1;
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
  
  keyboardIsVisible = YES;
  textField.inputAccessoryView = textFieldToolbar;
  
  [self.table beginUpdates];
  [self.table endUpdates];
  [self scrollToRectAtIndexPath:textField.indexPath];
}

- (void)textFieldDidEndEditing:(TextFieldPadding *)textField
{
  
  // Phone format
  if (textField.indexPath.row == OMBNeedHelpSectionFormRowPhone) {
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
//  textView.layer.borderColor = [UIColor blue].CGColor;
//  textView.layer.borderWidth = 1.0f;

  keyboardIsVisible = YES;
  
  NSIndexPath *indexPath = [NSIndexPath
    indexPathForRow: OMBNeedHelpSectionFormRowAditional
      inSection: OMBNeedHelpSectionForm];
  
  [self.table beginUpdates];
  [self.table endUpdates];
  [self scrollToRectAtIndexPath: indexPath];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//  textView.layer.borderWidth = 0.0f;
}

- (void)textViewDidChange:(UITextView *)textView
{
  if ([[textView.text stripWhiteSpace] length]) {
    aditionalPlaceholder.hidden = YES;
  }
  else {
    aditionalPlaceholder.hidden = NO;
  }
  [valuesDictionary setObject:textView.text forKey:@"comment"];
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
  [self.navigationController popViewControllerAnimated:YES];
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
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
      [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: OMBNeedHelpSectionFormRowBudget
          inSection: OMBNeedHelpSectionForm]];
    
    budgetMinString = [self pickerView:budgetPickerView
      titleForRow: auxRowMinBudget forComponent:0];
    
    budgetMaxString = [self pickerView:budgetPickerView
      titleForRow: auxRowMaxBudget forComponent:1];
    
    [valuesDictionary setObject: [NSNumber numberWithInt: 500 * auxRowMinBudget]
        forKey: @"budget"];
    
    [valuesDictionary setObject: [NSNumber numberWithInt: 500 * auxRowMaxBudget]
        forKey: @"budget"];
    
    cell.textField.text = [NSString stringWithFormat:@"%@ - %@",
      budgetMinString, budgetMaxString];

    
  }
  // Lease type
  else if ([leaseLengthPicker superview]) {
    NSString *string = [leaseOptions objectAtIndex: auxRowLease];
   
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
      [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForItem:OMBNeedHelpSectionFormRowLeaseLength
          inSection:OMBNeedHelpSectionForm]];
    
    cell.textField.text = string;
    [valuesDictionary setObject:@(auxRowLease) forKey:@"lease_length"];
  }

}

- (BOOL) hasCompleteFields
{
  // Check for required fields
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
  NSString *phoneNumber = [NSString companyPhoneNumberString];
  if (formated) {
    return [phoneNumber phoneNumberString];
  }
  return phoneNumber;
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
    // [self rememberFormSubmitted];
    Help *help = [[Help alloc] init];
    [help createHelpForStudent:valuesDictionary delegate:self];
    [self containerStartSpinning];
  }
  else {
    UIAlertView *alertView = 
      [[UIAlertView alloc] initWithTitle:@"Almost Finished"
        message: @"Some fields are required (*)" delegate: nil
          cancelButtonTitle: @"Continue" otherButtonTitles: nil];
    [alertView show];
  }
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  
  NSString *key;
  NSString *string = textField.text;
  
  if (textField.indexPath.row == OMBNeedHelpSectionFormRowFirsLastName) {
    if (textField.tag == 1) {
      key = @"first_name";
    }
    else if (textField.tag == 2) {
      key = @"last_name";
    }
  }
  else if (textField.indexPath.row == OMBNeedHelpSectionFormRowPhone) {
    key = @"phone";
  }
  else if (textField.indexPath.row == OMBNeedHelpSectionFormRowEmail) {
    key = @"email";
  }
  else if (textField.indexPath.row == OMBNeedHelpSectionFormRowSchool) {
    key = @"school";
  }
  else if (textField.indexPath.row == OMBNeedHelpSectionFormRowPlace) {
    key = @"location";
  }
  else if (textField.indexPath.row == OMBNeedHelpSectionFormRowBedrooms) {
    key = @"bedrooms";
  }
  
  [valuesDictionary setObject:string forKey:key];
}

@end
