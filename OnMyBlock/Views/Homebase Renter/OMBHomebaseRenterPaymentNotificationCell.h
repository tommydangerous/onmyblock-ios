//
//  OMBHomebaseRenterPaymentNotificationCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBImageTwoLabelCell.h"

@interface OMBHomebaseRenterPaymentNotificationCell : OMBImageTwoLabelCell

@property (nonatomic, strong) UIButton *responseButton;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadData;
- (void) setupForRoommate;
- (void) setupForSelf;

@end
