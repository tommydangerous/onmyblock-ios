//
//  OMBResidenceDetailDescriptionCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailCell.h"

@interface OMBResidenceDetailDescriptionCell : OMBResidenceDetailCell

@property (nonatomic, strong) UILabel *descriptionLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadData: (NSString *) string;

@end
