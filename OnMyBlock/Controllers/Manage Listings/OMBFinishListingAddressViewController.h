//
//  OMBFinishListingAddressViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "OMBFinishListingSectionViewController.h"

@class AMBlurView;
@class TextFieldPadding;

@interface OMBFinishListingAddressViewController : 
  OMBFinishListingSectionViewController
<CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate>
{
  NSString *address;
  UITableView *addressTableView;
  TextFieldPadding *addressTextField;
  AMBlurView *addressTextFieldView;
  NSString *city;
  UIButton *currentLocationButton;
  CGFloat latitude;
  CLLocationManager *locationManager;
  CGFloat longitude;
  MKMapView *map;
  NSString *state;
  UITableView *textFieldTableView;
  NSTimer *typingTimer;
  NSString *unit;
  NSString *zip;
}

@property (nonatomic, strong) NSArray *addressArray;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setMapViewRegion: (CLLocationCoordinate2D) coordinate 
withMiles: (CGFloat) miles animated: (BOOL) animated;

@end
