//
//  OMBCreateListingViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "OMBViewController.h"

@class OMBActivityView;
@class OMBCreateListingPropertyTypeView;
@class TextFieldPadding;

@interface OMBCreateListingViewController : OMBViewController
<MKMapViewDelegate, UIScrollViewDelegate, UITableViewDataSource, 
  UITableViewDelegate, UITextFieldDelegate>
{
  OMBActivityView *activityView;
  UIBarButtonItem *backBarButtonItem;
  UIBarButtonItem *cancelBarButtonItem;
  UIBarButtonItem *nextBarButtonItem;
  UIBarButtonItem *saveBarButtonItem;
  UIView *progressBar;
  UILabel *questionLabel;
  UILabel *stepLabel;
  int stepNumber;

  // Step 1
  UITableView *propertyTypeTableView;
  // Step 2
  TextFieldPadding *cityTextField;
  UIButton *currentLocationButton;
  UIView *locationView;
  MKMapView *map;
  // Step 3
  UITableView *detailsTableView;

  NSMutableDictionary *valuesDictionary;
}

@end
