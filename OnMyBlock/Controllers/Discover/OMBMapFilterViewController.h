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
  UIButton *currentLocationButton;
  UIBarButtonItem *doneBarButtonItem;
  UIView *fadedBackground;
  BOOL isEditing;
  UITableView *neighborhoodTableView;
  UIView *neighborhoodTableViewContainer;
  UIPickerView *rentPickerView;
  UIView *rentPickerViewContainer;
  UIBarButtonItem *searchBarButtonItem;
  OMBNeighborhood *selectedNeighborhood;
}

@property (nonatomic) BOOL shouldSearch;
@property (nonatomic, strong) NSMutableDictionary *valuesDictionary;

@end
