//
//  OMBRenterInfoAddPreviousRentalViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoAddPreviousRentalViewController.h"

#import "OMBGoogleMapsReverseGeocodingConnection.h"
#import "OMBPreviousRental.h"
#import "OMBLabelSwitchCell.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBRenterApplication.h"
#import "OMBTwoLabelTextFieldCell.h"
#import "OMBViewControllerContainer.h"
#import "NSString+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBRenterInfoAddPreviousRentalViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.title = @"Add Rental History";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  [self setupForTable];
  // Default no
  onCampus = NO;

  CGRect screen = [UIScreen mainScreen].bounds;
  CGFloat padding = 20.0f;

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

  // List of address results
  CGFloat addressTableViewHeight =
    self.table.frame.size.height - (OMBKeyboardHeight + textFieldToolbar.frame.size.height) -
      [OMBLabelTextFieldCell heightForCellWithIconImageView] * 2;
  addressTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f,
    [OMBLabelTextFieldCell heightForCellWithIconImageView] * 2,
      self.view.frame.size.width, addressTableViewHeight)
        style: UITableViewStylePlain];
  addressTableView.backgroundColor = [UIColor whiteColor];
  addressTableView.dataSource = self;
  addressTableView.delegate = self;
  addressTableView.hidden = YES;
  addressTableView.separatorColor  = [UIColor grayLight];
  addressTableView.separatorInset  = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  addressTableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
  addressTableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
  [self.view addSubview: addressTableView];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  modelObject = [[OMBPreviousRental alloc] init];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  if(tableView == self.table){
    // Fields
    // Spacing
    return 2;
  }
  else if(tableView == addressTableView)
    return 1;

  return 1;
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
  if(tableView == self.table){
    // Fields
    if (section == OMBRenterInfoAddPreviousRentalSectionFields) {
      if(row == OMBRenterInfoAddPreviousRentalSectionFieldsRowSwitch){
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
        cell.textFieldLabel.text = @"This is on-campus";
        [cell addTarget:self action:@selector(switchFields)];
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
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.userInteractionEnabled = YES;
        NSString *imageName;
        NSString *placeholderString;
        NSString *key;
        // Switch On
        if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowSchool) {
          imageName         = @"school_icon.png";
          placeholderString = @"School";
          key = @"school";
        }
        // Switch Off
        // Address
        if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowAddress) {
          imageName         = @"location_icon_black.png";
          placeholderString = @"Address";
          key = @"address";
        }
        // City
        else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowCity) {
          imageName         = @"map_marker_icon.png";
          placeholderString = @"City";
          key = @"city";
        }
        // State and Zip
        else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowState) {
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

          // State
          cell.firstIconImageView.image =
            [UIImage image: [UIImage imageNamed: imageName]
              size: cell.firstIconImageView.frame.size];
          cell.firstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
          cell.firstTextField.delegate  = self;
          cell.firstTextField.font = [UIFont normalTextFont];
          cell.firstTextField.indexPath = indexPath;
          cell.firstTextField.placeholder = @"State";
          cell.firstTextField.text = [valueDictionary objectForKey:@"state"];
          [cell.firstTextField addTarget: self action: @selector(textFieldDidChange:)
            forControlEvents: UIControlEventEditingChanged];

          // Zip
          cell.secondTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
          cell.secondTextField.delegate  = self;
          cell.secondTextField.font = cell.firstTextField.font;
          cell.secondTextField.indexPath =
          [NSIndexPath indexPathForRow: OMBRenterInfoAddPreviousRentalSectionFieldsRowZip
            inSection: indexPath.section] ;
          cell.secondTextField.placeholder = @"Zip";
          cell.secondTextField.text = [valueDictionary objectForKey:@"zip"];
          [cell.secondTextField addTarget: self action: @selector(textFieldDidChange:)
            forControlEvents: UIControlEventEditingChanged];
          cell.clipsToBounds = YES;
          return cell;

        }
        // Month rent
        else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowMonthRent) {
          imageName         = @"rent_icon_black.png";
          placeholderString = @"Rent";
          key = @"rent";
          cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }

        NSString *landlord = onCampus? @"Reference's " : @"Landlord's ";
        // Fields
        // Move-in Date
        if(row == OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveInDate) {
          imageName         = @"calendar_icon_black.png";
          key = @"";
          placeholderString = @"Move in";
          cell.selectionStyle = UITableViewCellSelectionStyleDefault;
          cell.textField.text = @"";
          cell.textField.userInteractionEnabled = NO;
          if (moveInDate) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            dateFormat.dateFormat = @"MMMM yyyy";
            cell.textField.text = [dateFormat stringFromDate:
              [NSDate dateWithTimeIntervalSince1970: moveInDate]];
          }
        }
        // Move-out Date
        else if(row == OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveOutDate) {
          imageName         = @"calendar_icon_black.png";
          key = @"";
          placeholderString = @"Move out";
          cell.selectionStyle = UITableViewCellSelectionStyleDefault;
          cell.textField.text = @"";
          cell.textField.userInteractionEnabled = NO;
          if (moveOutDate) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            dateFormat.dateFormat = @"MMMM yyyy";
            cell.textField.text = [dateFormat stringFromDate:
              [NSDate dateWithTimeIntervalSince1970: moveOutDate]];
          }
        }
        // Full name
        else if(row == OMBRenterInfoAddPreviousRentalSectionFieldsRowName) {
          imageName         = @"user_icon.png";
          key               = @"landlordName";
          placeholderString = [landlord stringByAppendingString: @"full name"];
        }
        // Email
        else if(row == OMBRenterInfoAddPreviousRentalSectionFieldsRowEmail) {
          imageName         = @"messages_icon_dark.png";
          key               = @"landlordEmail";
          placeholderString = [landlord stringByAppendingString: @"email"];
          cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        }
        // Phone
        else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowPhone) {
          imageName         = @"phone_icon.png";
          key               = @"landlordPhone";
          placeholderString = [landlord stringByAppendingString: @"phone"];
          cell.textField.keyboardType = UIKeyboardTypePhonePad;
        }
        cell.iconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
          size: cell.iconImageView.bounds.size];

        if(key.length)
          cell.textField.text =[valueDictionary objectForKey: key];

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
    else if (section == OMBRenterInfoAddPreviousRentalSectionSpacing) {
      empty.backgroundColor = [UIColor grayUltraLight];
      empty.separatorInset = UIEdgeInsetsMake(0.0f,
        tableView.frame.size.width, 0.0f, 0.0f);
    }
  }
  // Address table view
  else if (tableView == addressTableView){
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellIdentifier];
    if (!cell)
      cell = [[UITableViewCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];

    // If this is not the last row ("Address Form")
    if (indexPath.row <
        [tableView numberOfRowsInSection: indexPath.section] - 1 &&
        indexPath.row < [_addressArray count]) {
      NSDictionary *dict = [_addressArray objectAtIndex: indexPath.row];
      cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
        size: 15];
      cell.textLabel.text = [dict objectForKey: @"formatted_address"];
      cell.textLabel.textColor = [UIColor textColor];
    }
    else {
      cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
        size: 15];
      cell.textLabel.text = @"Use address form";
      cell.textLabel.textColor = [UIColor blue];
    }
    cell.clipsToBounds = YES;
    return cell;
  }
  empty.clipsToBounds = YES;
  return empty;
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
  if(tableView == self.table){
    if (section == OMBRenterInfoAddPreviousRentalSectionFields)
      return 12;
    else if (section == OMBRenterInfoAddPreviousRentalSectionSpacing)
      return 1;
  }
  else if(tableView == addressTableView){
    return [_addressArray count] + 1;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"%i",indexPath.row);
  if(tableView == self.table){
    // Move-in date
    if(indexPath.row == OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveInDate){
      [self.table scrollToRowAtIndexPath: indexPath
        atScrollPosition: UITableViewScrollPositionTop animated: YES];
      [self showPickerView: (UIPickerView *)moveInPicker];
    }
    // Move-out date
    else if (indexPath.row == OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveOutDate){
      [self.table scrollToRowAtIndexPath: indexPath
         atScrollPosition: UITableViewScrollPositionTop animated: YES];
      [self showPickerView: (UIPickerView *)moveOutPicker];
    }
  }
  else if (tableView == addressTableView) {
    if (indexPath.row <
       [tableView numberOfRowsInSection: indexPath.section] - 1) {
      NSString *formattedAddress = [[_addressArray objectAtIndex:
        indexPath.row] objectForKey: @"formatted_address"];
      [self setAddressInfoFromString: formattedAddress];
    }
    [self showAddressForm];
  }

  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger section = indexPath.section;

  if(tableView == self.table){
    if (section == OMBRenterInfoAddPreviousRentalSectionFields) {

      switch (indexPath.row) {
          // Switch On
        case OMBRenterInfoAddPreviousRentalSectionFieldsRowAddress:
        case OMBRenterInfoAddPreviousRentalSectionFieldsRowCity:
        case OMBRenterInfoAddPreviousRentalSectionFieldsRowState:
        case OMBRenterInfoAddPreviousRentalSectionFieldsRowMonthRent:
          if(onCampus)
            return 0.0f;
          break;
          // Switch Off
        case OMBRenterInfoAddPreviousRentalSectionFieldsRowSchool:
          if(!onCampus)
            return 0.0f;
      }

      // Two Fields in one row
      if(indexPath.row == OMBRenterInfoAddPreviousRentalSectionFieldsRowZip)
        return 0.0f;

      return [OMBLabelTextFieldCell heightForCellWithIconImageView];
    }
    else if (section == OMBRenterInfoAddPreviousRentalSectionSpacing) {
      if (isEditing) {
        return OMBKeyboardHeight + textFieldToolbar.frame.size.height;
      }
    }
  }
  else if(tableView == addressTableView){
    return 44.0f;
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

  if (textField.indexPath.row == OMBRenterInfoAddPreviousRentalSectionFieldsRowZip)
    [self scrollToRowAtIndexPath:
      [NSIndexPath indexPathForRow:
        OMBRenterInfoAddPreviousRentalSectionFieldsRowState
          inSection:textField.indexPath.section]];
  else
    [self scrollToRowAtIndexPath: textField.indexPath];

}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancelFromInputAccessoryView
{
  [self.view endEditing: YES];
  isEditing = NO;
  [self.table beginUpdates];
  [self.table endUpdates];
  addressTableView.hidden = YES;
}

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
  if (!onCampus)
    [valueDictionary removeObjectForKey: @"school"];
  [super save];
  [[self renterApplication] createModelConnection: modelObject
    delegate: modelObject completion: ^(NSError *error) {
      if (error) {
        [self showAlertViewWithError: error];
      }
      else {
        [[self renterApplication] addModel: modelObject];
        [self cancel];
      }
      isSaving = NO;
      [self containerStopSpinning];
    }];
  [self containerStartSpinning];
}

- (void) scrollToRowAtIndexPath: (NSIndexPath *) indexPath
{
  [self.table scrollToRowAtIndexPath: indexPath
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void) setAddressInfoFromString: (NSString *) string
{
  // Address
  NSArray *words = [string componentsSeparatedByString: @","];
  if ([words count] >= 1) {
    [valueDictionary setObject:[[words objectAtIndex: 0] stripWhiteSpace] forKey:@"address"];
  }
  if ([words count] >= 2) {
    [valueDictionary setObject:[[words objectAtIndex: 1] stripWhiteSpace] forKey:@"city"];
  }
  if ([words count] >= 3) {
    NSString *stateZip = [words objectAtIndex: 2];
    // State
    NSRegularExpression *stateRegEx =
      [NSRegularExpression regularExpressionWithPattern: @"([A-Za-z]+)"
        options: 0 error: nil];
    NSArray *stateMatches = [stateRegEx matchesInString: stateZip
      options: 0 range: NSMakeRange(0, [stateZip length])];
    if ([stateMatches count]) {
      NSTextCheckingResult *stateResult = [stateMatches objectAtIndex: 0];
      [valueDictionary setObject: [stateZip substringWithRange: stateResult.range] forKey:@"state"];
    }

    // Zip
    NSRegularExpression *zipRegEx =
      [NSRegularExpression regularExpressionWithPattern: @"([0-9-]+)"
        options: 0 error: nil];
    NSArray *zipMatches = [zipRegEx matchesInString: stateZip
      options: 0 range: NSMakeRange(0, [stateZip length])];
    if ([zipMatches count]) {
      NSTextCheckingResult *zipResult = [zipMatches objectAtIndex: 0];
      [valueDictionary setObject: [stateZip substringWithRange: zipResult.range] forKey:@"zip"];
    }
  }
}

- (void) showAddressForm
{
  addressTableView.hidden = YES;
  [self.table reloadData];
  //saveBarButtonItem.enabled = YES;
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

- (void) startGooglePlacesConnection
{
  NSString *city  = [valueDictionary objectForKey: @"city"];
  NSString *state = [valueDictionary objectForKey: @"state"];
  if (![city length])
    city = @"";
  if (![state length])
    state = @"CA";
  // Search for places via Google
  OMBGoogleMapsReverseGeocodingConnection *conn =
  [[OMBGoogleMapsReverseGeocodingConnection alloc] initWithAddress:
    [valueDictionary objectForKey:@"address"] city: city state: state];
  conn.completionBlock = ^(NSError *error) {
    [addressTableView reloadData];
  };
  conn.delegate = self;
  [conn start];
}

- (void) switchFields
{
  onCampus = !onCampus;
  [self.table reloadData];

  /*[self.table reloadRowsAtIndexPaths:
    @[[NSIndexPath indexPathForRow:OMBRenterInfoAddPreviousRentalSectionFieldsRowSchool inSection:OMBRenterInfoAddPreviousRentalSectionFields],
      [NSIndexPath indexPathForRow:OMBRenterInfoAddPreviousRentalSectionFieldsRowAddress inSection:OMBRenterInfoAddPreviousRentalSectionFields],
      [NSIndexPath indexPathForRow:OMBRenterInfoAddPreviousRentalSectionFieldsRowCity inSection:OMBRenterInfoAddPreviousRentalSectionFields],
      [NSIndexPath indexPathForRow:OMBRenterInfoAddPreviousRentalSectionFieldsRowState inSection:OMBRenterInfoAddPreviousRentalSectionFields],
      [NSIndexPath indexPathForRow:OMBRenterInfoAddPreviousRentalSectionFieldsRowZip inSection:OMBRenterInfoAddPreviousRentalSectionFields],
      [NSIndexPath indexPathForRow:OMBRenterInfoAddPreviousRentalSectionFieldsRowMonthRent inSection:OMBRenterInfoAddPreviousRentalSectionFields]]
      withRowAnimation:UITableViewRowAnimationFade];*/

  //[self.table reloadSections:[NSIndexSet indexSetWithIndex:OMBRenterInfoAddPreviousRentalSectionFields]
    // withRowAnimation:UITableViewRowAnimationFade ];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  NSInteger row = textField.indexPath.row;
  NSString *string = textField.text;

  if ([string length]) {
    // Switch On
    if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowSchool) {
      // New atrribute
      [valueDictionary setObject: string forKey: @"school"];
    }
    // Switch Off
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowCity) {
      [valueDictionary setObject: string forKey: @"city"];
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowState) {
      [valueDictionary setObject: string forKey: @"state"];
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowZip) {
      [valueDictionary setObject: string forKey: @"zip"];
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowMonthRent) {
      [valueDictionary setObject: string forKey: @"rent"];
    }
    // Fields
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowName) {
      [valueDictionary setObject: string forKey: @"landlordName"];
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowEmail) {
      [valueDictionary setObject: string forKey: @"landlordEmail"];
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowPhone) {
      [valueDictionary setObject: string forKey: @"landlordPhone"];
    }
  }

  if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowAddress) {
    [self scrollToRowAtIndexPath: textField.indexPath];
    [valueDictionary setObject: string forKey: @"address"];
    NSInteger length = [[textField.text stripWhiteSpace] length];
    if (length) {
      //saveBarButtonItem.enabled = NO;
      //[self.navigationItem setRightBarButtonItem: saveBarButtonItem
      //  animated: YES];
      textField.clearButtonMode = UITextFieldViewModeAlways;
      textField.rightViewMode   = UITextFieldViewModeNever;
      // Show address table view
      addressTableView.hidden = NO;

      // Stop timer
      [typingTimer invalidate];
      // Start timer
      typingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5f target: self
        selector: @selector(startGooglePlacesConnection) userInfo: nil
          repeats: NO];
    }
    else {
      //[self.navigationItem setRightBarButtonItem: nil animated: YES];
      textField.clearButtonMode = UITextFieldViewModeNever;
      textField.rightViewMode   = UITextFieldViewModeAlways;
      addressTableView.hidden = YES;
    }
  }
  NSLog(@"DICTIONARY :  %@",[valueDictionary description]);
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
    forKey: @"moveInDate"];
  [valueDictionary setObject: [NSNumber numberWithDouble: moveOutDate]
    forKey: @"moveOutDate"];

  //[self.table reloadData];
  [self.table reloadRowsAtIndexPaths:
    @[[NSIndexPath indexPathForRow:OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveInDate
          inSection:OMBRenterInfoAddPreviousRentalSectionFields],
        [NSIndexPath indexPathForRow:OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveOutDate
           inSection:OMBRenterInfoAddPreviousRentalSectionFields]]
       withRowAnimation:UITableViewRowAnimationFade];

}

@end

