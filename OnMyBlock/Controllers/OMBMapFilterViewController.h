//
//  OMBMapFilterViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/22/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBMapViewController;
@class OMBNeighborhood;
@class TextFieldPadding;

@interface OMBMapFilterViewController : OMBViewController
<UITextFieldDelegate>
{
  UIView *availableOnView;
  TextFieldPadding *availableOnTextField;
  UIView *bathButtons;
  UIView *bathView;
  UIView *bedButtons;
  UIView *bedsView;
  TextFieldPadding *neighborhoodTextField;
  TextFieldPadding *maxRentTextField;
  UIScrollView *maxRentListView;
  TextFieldPadding *minRentTextField;
  UIScrollView *minRentListView;
  UIScrollView *neighborhoodListView;
  UIView *neighborhoodView;
  UIView *rentView;
  UIScrollView *scroll;
}

@property (nonatomic, strong) NSNumber *bath;
@property (nonatomic, strong) NSMutableDictionary *beds;
@property (nonatomic, strong) NSArray *bedsArray;
@property (nonatomic, strong) OMBMapViewController *mapViewController;
@property (nonatomic, strong) NSNumber *maxRent;
@property (nonatomic, strong) NSNumber *minRent;
@property (nonatomic, strong) OMBNeighborhood *neighborhood;

@end
