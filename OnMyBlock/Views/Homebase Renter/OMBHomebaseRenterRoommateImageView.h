//
//  OMBHomebaseRenterRoommateImageView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBCenteredImageView;

@interface OMBHomebaseRenterRoommateImageView : UIView

@property (nonatomic, strong) UIButton *addRoommateButton;
@property (nonatomic, strong) OMBCenteredImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setupForAddRoommate;

@end
