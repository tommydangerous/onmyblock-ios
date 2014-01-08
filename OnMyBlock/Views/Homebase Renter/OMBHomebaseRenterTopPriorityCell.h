//
//  OMBHomebaseRenterTopPriorityCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBImageTwoLabelCell.h"

@interface OMBHomebaseRenterTopPriorityCell : OMBImageTwoLabelCell
{
  UILabel *dateTimeLabel;
}

@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UIButton *yesButton;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadData;

@end
