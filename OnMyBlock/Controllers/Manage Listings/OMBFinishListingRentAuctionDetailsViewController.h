//
//  OMBFinishListingRentAuctionDetailsViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingSectionViewController.h"

@class TextFieldPadding;

@interface OMBFinishListingRentAuctionDetailsViewController : 
  OMBFinishListingSectionViewController
<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
  UITableView *auctionTableView;
  NSArray *durationOptions;
  BOOL refreshTableView;
  UILabel *fixedRentalPriceLabel;
  TextFieldPadding *fixedRentalPriceTextField;
  UIView *fixedRentalPriceView;
  UISegmentedControl *segmentedControl;
  NSIndexPath *selectedIndexPath;
  BOOL showMore;
}

@end
