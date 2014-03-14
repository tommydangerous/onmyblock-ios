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
  // Fields
  OMBRenterInfoAddPreviousRentalSectionFieldsRowMonthRent,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveInDate,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowMoveOutDate,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowFirstName,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowLastName,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowEmail,
  OMBRenterInfoAddPreviousRentalSectionFieldsRowPhone,
};

@interface OMBRenterInfoAddPreviousRentalViewController :
  OMBRenterInfoAddViewController
{
  BOOL onCampus;
}

@end
