//
//  OMBMapFilterBathroomsCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterBathroomsCell.h"

@implementation OMBMapFilterBathroomsCell

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setValueLabelText
{
  [super setValueLabelText];

  self.valueLabel.text = [NSString stringWithFormat: @"%i", 
    [self.currentValue intValue]];
}

@end
