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
<UIActionSheetDelegate, UIPickerViewDataSource, 
UIPickerViewDelegate, UITextFieldDelegate>
{
  UIActionSheet *deleteActionSheet;
  NSArray *leaseTypeOptions;
  NSArray *propertyTypeOptions;
  NSIndexPath *selectedIndexPath;
}

@end
