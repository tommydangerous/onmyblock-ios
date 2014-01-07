//
//  OMBMapFilterBathroomsCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterBathroomsCell.h"

@implementation OMBMapFilterBathroomsCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.maxButtons = 4;

  [self setupButtons];
  [self setupButtonTitles];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setupButtonTitles
{
  for (int i = 0; i < self.maxButtons; i++) {
    UIButton *button = [self.buttons objectAtIndex: i];
    NSString *string = [NSString stringWithFormat: @"%i", i + 1];
    if (i == self.maxButtons - 1) {
      string = [string stringByAppendingString: @"+"];
    }
    [button setTitle: string forState: UIControlStateNormal];
  }
}

@end
