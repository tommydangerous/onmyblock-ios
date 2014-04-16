//
//  OMBManageListingDetailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableParallaxViewController.h"

@class OMBResidence;

typedef NS_ENUM(NSInteger, OMBManageListingDetailSection) {
  OMBManageListingDetailSectionTop
};

typedef NS_ENUM(NSInteger, OMBManageListingDetailSectionTopRow) {
  OMBManageListingDetailSectionTopRowEdit,
  OMBManageListingDetailSectionTopRowPreview,
  OMBManageListingDetailSectionTopRowStatus
};

@interface OMBManageListingDetailViewController : OMBTableParallaxViewController
{
  UIView *bottomStatus;
  UIButton *cancelStatusButton;
  UILabel *descriptionLabel;
  UIView *fadedBackground;
  UIButton *reasonTwoButton;
  UIButton *rentedButton;
  UITextField *rentedTextField;
  BOOL isShowingPicker;
  UILabel *titlelabel;
  // Date Picker
  NSTimeInterval availableDate;
  UIDatePicker *datePicker;
  UIView *pickerViewContainer;
  UILabel *pickerViewHeaderLabel;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
