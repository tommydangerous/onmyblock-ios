//
//  OMBMapFilterViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBNeighborhood;
@class AMBlurView;
@interface OMBMapFilterViewController : OMBTableViewController
<CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate,
  UIScrollViewDelegate>
{
  UIPickerView *availabilityPickerView;
  NSCalendar *calendar;
  UIButton *currentLocationButton;
  UIView *fadedBackground;
  BOOL isEditing;
  CLLocationManager *locationManager;
  NSMutableDictionary *moveInDates;
  UITableView *neighborhoodTableView;
  UIView *neighborhoodTableViewContainer;
	UILabel *pickerViewHeaderLabel;
	UIPickerView *rentPickerView;
  UIView *pickerViewContainer;
  UIBarButtonItem *searchBarButtonItem;
  OMBNeighborhood *selectedNeighborhood;
}

@property (nonatomic) BOOL shouldSearch;
@property (nonatomic, strong) NSMutableDictionary *valuesDictionary;

@end
