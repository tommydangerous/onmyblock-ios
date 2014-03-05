//
//  OMBFinishListingOtherDetailsViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingSectionViewController.h"

@interface OMBFinishListingOtherDetailsViewController : 
  OMBFinishListingSectionViewController
<UIActionSheetDelegate, UIAlertViewDelegate, UIPickerViewDataSource, 
UIPickerViewDelegate, UITextFieldDelegate>
{
  int auxRow;
  UIActionSheet *deleteActionSheet;
	UITextField *editingTextField;
  UIView *fadedBackground;
  BOOL isShowPicker;
  UIView *pickerViewContainer;
	UILabel *pickerViewHeaderLabel;
  NSArray *propertyTypeOptions;
  UIPickerView *propertyTypePicker;
	NSString *savedTextFieldString;
  NSIndexPath *selectedIndexPath;
	UIToolbar *textFieldToolbar;
}

@end
