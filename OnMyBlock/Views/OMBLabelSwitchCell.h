//
//  OMBLabelSwitchCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBLabelTextFieldCell.h"

@interface OMBLabelSwitchCell : OMBLabelTextFieldCell

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addTarget: (id) target action: (SEL) selector;
- (void) setFrameUsingSize: (CGSize) size;
@end
