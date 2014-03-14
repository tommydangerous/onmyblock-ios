//
//  OMBRenterInfoAddPreviousRentalViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoAddPreviousRentalViewController.h"

#import "OMBPreviousRental.h"
#import "OMBLabelSwitchCell.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBRenterApplication.h"
#import "OMBTwoLabelTextFieldCell.h"
#import "OMBViewControllerContainer.h"
#import "UIImage+Resize.h"

@interface OMBRenterInfoAddPreviousRentalViewController ()

@end

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
  onCampus = NO;
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
      // Switch On
      if(onCampus){
        if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowSchool) {
          imageName         = @"school_icon.png";
          placeholderString = @"School";
        }
      }
      // Switch Off
      else{
        // Address
        if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowAddress) {
          imageName         = @"messages_icon_dark.png";
          placeholderString = @"Address";
        }
        // City
        else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowCity) {
          imageName         = @"phone_icon.png";
          placeholderString = @"City";
        }
        // State
        else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowState) {
          imageName         = @"phone_icon.png";
          placeholderString = @"State";
        }
        // Zip
        else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowZip) {
          imageName         = @"phone_icon.png";
          placeholderString = @"Zip";
        }
      }
      // Fields
      // Month rent
      if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowMonthRent) {
        imageName         = @"phone_icon.png";
        placeholderString = @"Rent";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
      }
      // Move-in Date
      else if(row == OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveInDate) {
        imageName         = @"phone_icon.png";
        placeholderString = @"Move in";
        // date picker
      }
      // Move-out Date
      else if(row == OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveOutDate) {
        imageName         = @"phone_icon.png";
        placeholderString = @"Move out";
        // date picker
      }
      // First name
      else if(row == OMBRenterInfoAddPreviousRentalSectionFieldsRowFirstName) {
        imageName         = @"user_icon.png";
        placeholderString = @"First Name";
      }
      // Last name
      else if(row == OMBRenterInfoAddPreviousRentalSectionFieldsRowLastName) {
        imageName         = @"user_icon.png";
        placeholderString = @"Last Name";
      }
      // Email
      else if(row == OMBRenterInfoAddPreviousRentalSectionFieldsRowEmail) {
        imageName         = @"messages_icon_dark.png";
        placeholderString = @"Email";
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
      }
      // Phone
      else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowPhone) {
        imageName         = @"phone_icon.png";
        placeholderString = @"Phone";
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
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
  }
  // Spacing
  else if (section == OMBRenterInfoAddPreviousRentalSectionSpacing) {
    empty.backgroundColor = [UIColor clearColor];
    empty.separatorInset = UIEdgeInsetsMake(0.0f,
      tableView.frame.size.width, 0.0f, 0.0f);
  }
  
  return empty;
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
  if (section == OMBRenterInfoAddPreviousRentalSectionFields){
    return 13;
  }
  else if (section == OMBRenterInfoAddPreviousRentalSectionSpacing)
    return 1;
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger section = indexPath.section;
  
  if (section == OMBRenterInfoAddPreviousRentalSectionFields) {
    // Switch On
    if(onCampus){
      switch (indexPath.row) {
        case OMBRenterInfoAddPreviousRentalSectionFieldsRowAddress:
        case OMBRenterInfoAddPreviousRentalSectionFieldsRowCity:
        case OMBRenterInfoAddPreviousRentalSectionFieldsRowState:
        case OMBRenterInfoAddPreviousRentalSectionFieldsRowZip:
          return 0.0f;
      }
    }
    // Switch Off
    else{
      switch (indexPath.row) {
        case OMBRenterInfoAddPreviousRentalSectionFieldsRowSchool:
          return 0.0f;
      }
    }
    return [OMBLabelTextFieldCell heightForCellWithIconImageView];
  }
  else if (section == OMBRenterInfoAddPreviousRentalSectionSpacing) {
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
  /*[[self renterApplication] createPreviousRentalConnection: modelObject
    delegate: modelObject completion: ^(NSError *error) {
      if (error) {
        [self showAlertViewWithError: error];
      }
      else {
        [[self renterApplication] addPreviousRental: modelObject];
        [self cancel];
      }
      isSaving = NO;
      [[self appDelegate].container stopSpinning];
    }];*/
  
  [[self appDelegate].container startSpinning];
  
#warning DELETE THESE 5 LINES AND UPDATE THE CODE ABOVE
  [modelObject readFromDictionary: valueDictionary];
  [[self renterApplication] addPreviousRental: modelObject];
  [self cancel];
  isSaving = NO;
  [[self appDelegate].container stopSpinning];
}

- (void) switchFields
{
  onCampus = !onCampus;
  [self.table reloadData];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  NSInteger row = textField.indexPath.row;
  NSString *string = textField.text;
  
  if ([string length]) {
    // Switch On
    if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowSchool) {
      [valueDictionary setObject: string forKey: @"school"];//
    }
    // Switch Off
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowAddress) {
      [valueDictionary setObject: string forKey: @"address"];
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowCity) {
      [valueDictionary setObject: string forKey: @"city"];
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowState) {
      [valueDictionary setObject: string forKey: @"state"];
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowZip) {
      [valueDictionary setObject: string forKey: @"zip"];
    }
    // Fields
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowMonthRent) {
      [valueDictionary setObject: string forKey: @"rent"];
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveInDate) {
      [valueDictionary setObject: string forKey: @"move_in"];//
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveOutDate) {
      [valueDictionary setObject: string forKey: @"move_out"];//
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowFirstName) {
      [valueDictionary setObject: string forKey: @"landlord_name"];
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowLastName) {
      [valueDictionary setObject: string forKey: @"landlord_lastname"];//
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowEmail) {
      [valueDictionary setObject: string forKey: @"landlord_email"];
    }
    else if (row == OMBRenterInfoAddPreviousRentalSectionFieldsRowPhone) {
      [valueDictionary setObject: string forKey: @"lease_months"];
    }
  }
}

@end
