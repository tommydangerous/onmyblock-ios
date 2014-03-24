//
//  OMBMapFilterLocationViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/12/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "OMBTableViewController.h"

@class OMBNeighborhood;
@class TextFieldPadding;

@interface OMBMapFilterLocationViewController : OMBTableViewController
<CLLocationManagerDelegate, UIScrollViewDelegate, UITextFieldDelegate>
{
  TextFieldPadding *filterTextField;
  UIImageView *filterImageView;
  BOOL isEditing;
  UIBarButtonItem *searchBarButtonItem;
  NSDictionary *temporaryNeighborhoods;
}

@property OMBNeighborhood *selectedNeighborhood;


#pragma mark - Initializer

- (id) initWithSelectedNeighborhood:(OMBNeighborhood *) selectedNeighborhood;

@end
