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
  UIView *bedsView;
  TextFieldPadding *neighborhoodTextField;
  UIScrollView *neighborhoodListView;
  UIView *neighborhoodView;
}

@property (nonatomic, strong) NSMutableDictionary *beds;
@property (nonatomic, strong) OMBMapViewController *mapViewController;
@property (nonatomic, strong) OMBNeighborhood *neighborhood;

@end
