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
  UIView *fadedBackground;
  // Status
  UIView *bottomStatusView;
  UIButton *cancelStatusButton;
  UILabel *descriptionStatusLabel;
  UIButton *reasonTwoButton;
  UIButton *rentedButton;
  UITextField *rentedTextField;
  BOOL isShowingPicker;
  BOOL isShowingStatusView;
  UILabel *titlelabel;
  // Relist
  UIButton *cancelRelistButton;
  UILabel *descriptionRelistLabel;
  UIButton *relistButton;
  UIView *relistView;
  // Date Picker
  NSTimeInterval availableDate;
  UIDatePicker *datePicker;
  UIView *pickerViewContainer;
  UILabel *pickerViewHeaderLabel;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
