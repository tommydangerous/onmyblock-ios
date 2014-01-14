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
@class OMBTemporaryResidence;
@class TextFieldPadding;

@interface OMBCreateListingViewController : OMBViewController
<CLLocationManagerDelegate, MKMapViewDelegate, UIScrollViewDelegate, 
UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
  OMBActivityView *activityView;
  UIBarButtonItem *backBarButtonItem;
  UIBarButtonItem *cancelBarButtonItem;
  CLLocationManager *locationManager;
  UIBarButtonItem *nextBarButtonItem;
  UIView *progressBar;
  UILabel *questionLabel;
  UIBarButtonItem *saveBarButtonItem;
  UILabel *stepLabel;
  int stepNumber;
  NSTimer *typingTimer;

  // Step 1
  UITableView *propertyTypeTableView;
  // Step 2
  UITableView *cityTableView;
  TextFieldPadding *cityTextField;
  UIButton *currentLocationButton;
  UIView *locationView;
  MKMapView *map;
  // Step 3
  UITableView *detailsTableView;

  NSMutableDictionary *valuesDictionary;
}

@property (nonatomic, strong) NSMutableArray *citiesArray;
@property (nonatomic, strong) OMBTemporaryResidence *temporaryResidence;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setCityTextFieldTextWithString: (NSString *) string;

@end
