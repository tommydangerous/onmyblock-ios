//
//  OMBNeedHelpViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/18/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBTextFieldToolbar;

// Sections
typedef NS_ENUM(NSInteger, OMBNeedHelpSection){
  OMBNeedHelpSectionPhoneCall,
  OMBNeedHelpSectionDetail,
  OMBNeedHelpSectionFirsLastName,
  OMBNeedHelpSectionPhone,
  OMBNeedHelpSectionEmail,
  OMBNeedHelpSectionSchool,
  OMBNeedHelpSectionPlace,
  OMBNeedHelpSectionBedrooms,
  OMBNeedHelpSectionBudget,
  OMBNeedHelpSectionLeaseLength,
  OMBNeedHelpSectionAditional,
  OMBNeedHelpSectionSubmit,
  OMBNeedHelpSectionSpacing
};

@interface OMBNeedHelpViewController : OMBTableViewController
<
  UIAlertViewDelegate,
  UIPickerViewDataSource,
  UIPickerViewDelegate,
  UITextFieldDelegate,
  UITextViewDelegate
>
{
  UITextView *aditionalTextView;
  NSInteger auxRowLease;
  NSInteger auxRowMinBudget;
  NSInteger auxRowMaxBudget;
  
  UIPickerView *budgetPickerView;
  NSInteger budgetPickerViewRows;
  NSString *budgetMinString;
  NSString *budgetMaxString;
  
  float detailHeight;
  NSString *detailString;
  
  UIView *fadedBackground;
  UIFont *detailFont;
  BOOL isShowPicker;
  NSArray *leaseOptions;
  UIView *pickerViewContainer;
  UILabel *pickerViewHeaderTitle;
  UIPickerView *leaseLengthPicker;
  UIButton *submitButton;
  OMBTextFieldToolbar *textFieldToolbar;
  
  BOOL keyboardIsVisible;
  NSMutableDictionary *valuesDictionary;
  
  NSArray *indexRequired;
}

@end
