//
//  OMBPayoutMethodBillingInfoViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

// Rows
// in section billing info
typedef NS_ENUM(NSInteger, OMBBillingInfoSection) {
  OMBBillingInfoSectionName,
  OMBBillingInfoSectionAddress,
  OMBBillingInfoSectionSpacing
};

typedef NS_ENUM(NSInteger, OMBBillingInfoSectionNameRow){
  OMBBillingInfoSectionNameRowTitle,
  OMBBillingInfoSectionNameRowFirstName,
  OMBBillingInfoSectionNameRowLastName
};

typedef NS_ENUM(NSInteger, OMBBillingInfoSectionAddressRow) {
  OMBBillingInfoSectionAddressRowTitle,
  OMBBillingInfoSectionAddressRowStreet,
  OMBBillingInfoSectionAddressRowCity,
  OMBBillingInfoSectionAddressRowState,
  OMBBillingInfoSectionAddressRowZip
};

@interface OMBPayoutMethodBillingInfoViewController : OMBTableViewController
  <UITextFieldDelegate>
{
  NSMutableDictionary *valueDictionary;
  BOOL isEditing;
}

@end
