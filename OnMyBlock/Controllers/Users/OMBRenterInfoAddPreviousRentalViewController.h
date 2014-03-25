//
//  OMBRenterInfoAddPreviousRentalViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoAddViewController.h"

// Sections
typedef NS_ENUM(NSInteger, OMBRenterInfoAddPreviousRentalSection) {
  OMBRenterInfoAddPreviousRentalSectionFields,
  OMBRenterInfoAddPreviousRentalSectionSpacing
};

// Rows
// Fields
typedef NS_ENUM(NSInteger, OMBRenterInfoAddPreviousRentalSectionFieldsRow) {
  // Switch
  OMBRenterInfoAddPreviousRentalSectionFieldsRowSwitch,
  // Switch On
  OMBRenterInfoAddPreviousRentalSectionFieldsRowSchool,
  // Switch Off
  OMBRenterInfoAddPreviousRentalSectionFieldsRowAddress,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowCity,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowState,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowZip,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowMonthRent,
  // Fields
  OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveInDate,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveOutDate,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowName,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowEmail,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowPhone,
};

@interface OMBRenterInfoAddPreviousRentalViewController :
  OMBRenterInfoAddViewController <UITextFieldDelegate>
{
  NSDateFormatter *dateFormatter;
  UIView *fadedBackground;
  BOOL isShowPicker;
  NSTimeInterval moveInDate;
  UIDatePicker *moveInPicker;
  NSTimeInterval moveOutDate;
  UIDatePicker *moveOutPicker;
  UIView *pickerViewContainer;
	UILabel *pickerViewHeaderLabel;
  BOOL onCampus;
  //Address
  NSString *address;
  UITableView *addressTableView;
  NSTimer *typingTimer;
}

@property (nonatomic, strong) NSArray *addressArray;

@end
