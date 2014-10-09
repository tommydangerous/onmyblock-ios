//
//  OMBMapFilterLocationViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/12/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBNeighborhood;
@class TextFieldPadding;

@interface OMBMapFilterLocationViewController : OMBTableViewController
<
  CLLocationManagerDelegate
>
{
  UISearchBar *searchBar;
  NSMutableArray *neighborhoodArray;
}

@property OMBNeighborhood *selectedNeighborhood;

#pragma mark - Initializer

- (id) initWithSelectedNeighborhood:(OMBNeighborhood *) selectedNeighborhood;

@end
