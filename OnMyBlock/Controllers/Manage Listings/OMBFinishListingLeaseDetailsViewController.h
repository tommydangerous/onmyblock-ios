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
UIPickerViewDelegate, UITextFieldDelegate>
{
  NSDateFormatter *dateFormatter;
  UIActionSheet *deleteActionSheet;
  NSArray *monthLeaseOptions;
  NSArray *leaseTypeOptions;
  NSIndexPath *selectedIndexPath;
}

@end
