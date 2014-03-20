//
//  OMBMapFilterViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBMapFilterLocationViewController;
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
  OMBMapFilterLocationViewController *filterViewController;
  CLLocationManager *locationManager;
  NSMutableDictionary *moveInDates;
  UITableView *neighborhoodTableView;
  UIView *neighborhoodTableViewContainer;
	UILabel *pickerViewHeaderLabel;
	UIPickerView *rentPickerView;
  NSInteger rentPickerViewRows;
  UIView *pickerViewContainer;
  UIBarButtonItem *searchBarButtonItem;
  OMBNeighborhood *selectedNeighborhood;
  NSDictionary *temporaryNeighborhoods;
}

@property (nonatomic) BOOL shouldSearch;
@property (nonatomic, strong) NSMutableDictionary *valuesDictionary;

@end
