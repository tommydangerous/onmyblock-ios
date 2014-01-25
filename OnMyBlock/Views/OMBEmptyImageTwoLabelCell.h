//
//  OMBEmptyImageTwoLabelCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBImageThreeLabelCell.h"

@interface OMBEmptyImageTwoLabelCell : OMBImageThreeLabelCell

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setBottomLabelText: (NSString *) string;
- (void) setMiddleLabelText: (NSString *) string;
- (void) setObjectImageViewImage: (UIImage *) image;
- (void) setTopLabelText: (NSString *) string;

@end
