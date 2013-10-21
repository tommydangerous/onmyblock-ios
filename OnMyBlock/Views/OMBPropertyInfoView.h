//
//  OMBPropertyInfoView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBProperty;

@interface OMBPropertyInfoView : UIView
{
  OMBProperty *property;
  UILabel *rentLabel;
}

#pragma mark - Methods

#pragma mark Instance Methods

- (void) loadPropertyData: (OMBProperty *) object;

@end
