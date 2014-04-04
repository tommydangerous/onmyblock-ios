//
//  OMBMapResidenceDetailCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 4/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBResidence;

@interface OMBMapResidenceDetailCell : OMBTableViewCell
{
  UIImageView *coverPhoto;
  UILabel *bedBathLabel;
  UILabel *rentLabel;
  UILabel *titleLabel;
}

@property (nonatomic, strong)  OMBResidence *residence;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidenceData:(OMBResidence *)object;

@end
