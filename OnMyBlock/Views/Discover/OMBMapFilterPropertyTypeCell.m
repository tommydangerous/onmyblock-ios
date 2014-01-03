//
//  OMBMapFilterPropertyTypeCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterPropertyTypeCell.h"

@implementation OMBMapFilterPropertyTypeCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.maxButtons = 3;

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
    NSString *string = @"";
    if (i == 0) {
      string = @"Sublet";
    }
    else if (i == 1) {
      string = @"House";
    }
    else if (i == 2) {
      string = @"Apartment";
    }
    [button setTitle: string forState: UIControlStateNormal];
  }
}

@end
