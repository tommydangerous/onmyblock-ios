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
<CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate,
  UIScrollViewDelegate>
{
  UIButton *currentLocationButton;
  UIBarButtonItem *doneBarButtonItem;
  UIView *fadedBackground;
  BOOL isEditing;
  CLLocationManager *locationManager;
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
