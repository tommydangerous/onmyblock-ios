//
//  OMBPropertyInfoView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBResidence;
@class OMBResidencePartialView;

@interface OMBPropertyInfoView : UIView

@property (nonatomic, weak) OMBResidence *residence;
@property (nonatomic, strong) OMBResidencePartialView *residencePartialView;

#pragma mark - Methods

#pragma mark Instance Methods

- (void) loadResidenceData: (OMBResidence *) object;

@end
