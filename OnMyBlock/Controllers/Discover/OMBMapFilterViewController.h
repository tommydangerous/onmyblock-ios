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
@class TextFieldPadding;

@interface OMBMapFilterViewController : OMBTableViewController
<CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate,
  UIScrollViewDelegate, UITextFieldDelegate>
{
  UIPickerView *availabilityPickerView;
  NSCalendar *calendar;
  UIButton *currentLocationButton;
  UIView *fadedBackground;
  TextFieldPadding *filterTextField;
  UIImageView *filterImageView;
  BOOL isEditing;
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
