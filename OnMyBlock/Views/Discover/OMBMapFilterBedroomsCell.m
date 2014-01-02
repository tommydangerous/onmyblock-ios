//
//  OMBMapFilterBedroomsCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterBedroomsCell.h"

@implementation OMBMapFilterBedroomsCell

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setValueLabelText
{
  [super setValueLabelText];

  if ([self.currentValue intValue] == 0) {
    self.valueLabel.text = @"Studio";
  }
  else {
    self.valueLabel.text = [NSString stringWithFormat: @"%i", 
      [self.currentValue intValue]];
  }
}

@end
