//
//  OMBRenterInfoAddRoommateViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/17/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoAddViewController.h"

// Sections
typedef NS_ENUM(NSInteger, OMBRenterInfoAddRoommateSection) {
  OMBRenterInfoAddRoommateSectionFields,
  OMBRenterInfoAddRoommateSectionSpacing
};
typedef NS_ENUM(NSInteger, OMBRenterInfoAddRoommateSearchSection) {
  OMBRenterInfoAddRoommateSearchSectionResults,
  OMBRenterInfoAddRoommateSearchSectionSpacing
};

// Rows
// Fields
typedef NS_ENUM(NSInteger, OMBRenterInfoAddRoommateSectionFieldsRow) {
  OMBRenterInfoAddRoommateSectionFieldsRowFirstName,
  OMBRenterInfoAddRoommateSectionFieldsRowLastName,
  OMBRenterInfoAddRoommateSectionFieldsRowEmail
};

@interface OMBRenterInfoAddRoommateViewController :
  OMBRenterInfoAddViewController

@end
