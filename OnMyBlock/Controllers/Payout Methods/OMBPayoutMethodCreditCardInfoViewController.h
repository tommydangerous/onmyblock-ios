//
//  OMBPayoutMethodCreditCardInfoViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"
// Rows
// in section credi card info

typedef NS_ENUM(NSInteger, OMBCreditCardSection){
  OMBCreditCardInfoSection,
  OMBCreditCardSpacingSection
};

typedef NS_ENUM(NSInteger, OMBCreditCardInfoSectionRow) {
  OMBCreditCardInfoSectionRowTitle,
  OMBCreditCardInfoSectionRowCardNumber,
  OMBCreditCardInfoSectionRowExpirationMonth,
  OMBCreditCardInfoSectionRowExpirationYear,
  OMBCreditCardInfoSectionRowCCV,
  OMBCreditCardInfoSectionRowSpacing
};

@interface OMBPayoutMethodCreditCardInfoViewController : OMBTableViewController
  <UITextFieldDelegate>
{
  NSMutableDictionary *valueDictionary;
  BOOL isEditing;
}

@end
