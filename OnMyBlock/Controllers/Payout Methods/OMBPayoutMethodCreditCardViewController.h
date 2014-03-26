//
//  OMBPayoutMethodCreditCardViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

// Sections
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSection) {
  OMBPayoutMethodCreditCardSectionPersonal,
  OMBPayoutMethodCreditCardSectionEmpty,
  OMBPayoutMethodCreditCardSectionCreditCard,
  OMBPayoutMethodCreditCardSectionSpacingKeyboard
};

// OMBPayoutMethodCreditCardSectionPersonal
typedef NS_ENUM(NSInteger, OMBPayoutMethodCreditCardSectionPersonalRow) {
  OMBPayoutMethodCreditCardSectionPersonalRowBilling,
  OMBPayoutMethodCreditCardSectionPersonalRowZip
};

// OMBPayoutMethodCreditCardSectionCreditCard
typedef NS_ENUM(NSInteger, OMBPayoutMethodCreditCardSectionCreditCardRow) {
  OMBPayoutMethodCreditCardSectionCreditCardRowNumber,
  OMBPayoutMethodCreditCardSectionCreditCardRowExpiration,
  OMBPayoutMethodCreditCardSectionCreditCardRowCCV
};

@interface OMBPayoutMethodCreditCardViewController : OMBTableViewController
<UITextFieldDelegate>
{
  UIBarButtonItem *cancelBarButton;
  UIBarButtonItem *doneBarButton;
  BOOL isEditing;
  UIToolbar *textFieldToolbar;
}

@end
