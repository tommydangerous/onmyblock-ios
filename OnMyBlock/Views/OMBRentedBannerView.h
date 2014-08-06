//
//  OMBRentedBannerView.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 7/21/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

@interface OMBRentedBannerView : UIView

@property (nonatomic, strong) UILabel *availableLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void)loadDateAvailable:(NSTimeInterval)timeInterval;

@end
