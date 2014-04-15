//
//  OMBImageOneLabelCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBImageTwoLabelCell.h"

@interface OMBImageOneLabelCell : OMBImageTwoLabelCell

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setFont: (UIFont *) font;
- (void) setImage: (UIImage *) image text: (NSString *) text;
- (void) setTextColor: (UIColor *) color;

@end
