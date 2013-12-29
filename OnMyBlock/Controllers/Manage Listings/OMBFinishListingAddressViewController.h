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
<MKMapViewDelegate, UITextFieldDelegate>
{
  UITableView *addressTableView;
  TextFieldPadding *addressTextField;
  AMBlurView *addressTextFieldView;
  UIButton *currentLocationButton;
  MKMapView *map;
  
  UITableView *textFieldTableView;
}

@end
