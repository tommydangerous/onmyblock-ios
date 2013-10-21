//
//  OMBPropertyInfoView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class OMBResidence;

@interface OMBPropertyInfoView : UIView
{
  UILabel *addressLabel;
  UIImageView *arrowImageView;
  UILabel *bedBathLabel;
  OMBResidence *residence;
  UILabel *rentLabel;
}

@property (nonatomic, strong) UIImageView *imageView;

#pragma mark - Methods

#pragma mark Instance Methods

- (void) loadResidenceData: (OMBResidence *) object;

@end
