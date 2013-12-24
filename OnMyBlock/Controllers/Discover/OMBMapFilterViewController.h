//
//  OMBMapFilterViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBNeighborhood;

@interface OMBMapFilterViewController : OMBTableViewController
<UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>
{
  UIBarButtonItem *doneBarButtonItem;
  UIView *fadedBackground;
  BOOL isEditing;
  UITableView *neighborhoodTableView;
  UIView *neighborhoodTableViewContainer;
  UIView *pickerViewBackground;
  UIPickerView *rentPickerView;
  UIBarButtonItem *searchBarButtonItem;
  OMBNeighborhood *selectedNeighborhood;
}

@end
