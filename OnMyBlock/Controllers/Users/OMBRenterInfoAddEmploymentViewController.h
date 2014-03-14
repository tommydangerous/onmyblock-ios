//
//  OMBRenterInfoAddEmploymentViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoAddViewController.h"

// Sections
typedef NS_ENUM(NSInteger, OMBRenterInfoAddEmploymentSection) {
  OMBRenterInfoAddEmploymentSectionFields,
  OMBRenterInfoAddEmploymentSectionSpacing
};

// Rows
// Fields
typedef NS_ENUM(NSInteger, OMBRenterInfoAddEmploymentSectionFieldsRow) {
  OMBRenterInfoAddEmploymentSectionFieldsRowCompanyName,
  OMBRenterInfoAddEmploymentSectionFieldsRowCompanyWebsite,
  OMBRenterInfoAddEmploymentSectionFieldsRowIncome,
  OMBRenterInfoAddEmploymentSectionFieldsRowStartDate,
  OMBRenterInfoAddEmploymentSectionFieldsRowEndDate,
  OMBRenterInfoAddEmploymentSectionFieldsRowTitle
};

@interface OMBRenterInfoAddEmploymentViewController :
  OMBRenterInfoAddViewController

@end
