//
//  OMBFinishListingLeaseDetailsViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 1/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingSectionViewController.h"

@interface OMBFinishListingLeaseDetailsViewController :
  OMBFinishListingSectionViewController
<UIActionSheetDelegate, UIPickerViewDataSource,
UIPickerViewDelegate>
{
  int auxRow;
  int auxMonthLease;
  NSDateFormatter *dateFormatter;
  UIActionSheet *deleteActionSheet;
  UIView *fadedBackground;
  BOOL isShowPicker;
  NSArray *monthLeaseOptions;
  NSArray *leaseTypeOptions;
  UIView *pickerViewContainer;
	UILabel *pickerViewHeaderLabel;
	UIDatePicker *moveInPicker;
	UIDatePicker *moveOutPicker;
	UIPickerView *monthLeasePicker;
  NSString *leaseTypeDescription;
	UIPickerView *leaseTypePicker;
  CGSize leaseTypeDescriptionSize;
}

@end
