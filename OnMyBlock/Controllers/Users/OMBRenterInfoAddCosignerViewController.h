//
//  OMBRenterInfoAddCosignerViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoAddViewController.h"

// Sections
typedef NS_ENUM(NSInteger, OMBRenterInfoAddCosignerSection) {
  OMBRenterInfoAddCosignerSectionFields,
  OMBRenterInfoAddCosignerSectionSpacing
};

// Rows
// Fields
typedef NS_ENUM(NSInteger, OMBRenterInfoAddCosignerSectionFieldsRow) {
  OMBRenterInfoAddCosignerSectionFieldsRowFirstNameLastName,
  OMBRenterInfoAddCosignerSectionFieldsRowEmail,
  OMBRenterInfoAddCosignerSectionFieldsRowPhone,
  OMBRenterInfoAddCosignerSectionFieldsRowRelationshipType
};

@interface OMBRenterInfoAddCosignerViewController : 
  OMBRenterInfoAddViewController

@end
