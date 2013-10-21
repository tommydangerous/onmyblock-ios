//
//  OMBPropertyInfoView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPropertyInfoView.h"

#import "OMBProperty.h"
#import "UIColor+Extensions.h"

@implementation OMBPropertyInfoView

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed: 1 green: 1 blue: 1 
      alpha: 0.8];
    self.frame = CGRectMake(0, screen.size.height, screen.size.width, 100);

    // Rent
    rentLabel = [[UILabel alloc] init];
    rentLabel.backgroundColor = [UIColor clearColor];
    rentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 27];
    rentLabel.frame = CGRectMake(100, 0, (screen.size.width - 100), 50);
    rentLabel.textColor = [UIColor textColor];
    [self addSubview: rentLabel];
  }
  return self;
}

#pragma mark - Methods

#pragma mark Instance Methods

- (void) loadPropertyData: (OMBProperty *) object
{
  property = object;
  rentLabel.text = [NSString stringWithFormat: @"%@", 
    [property rentToCurrencyString]];
}

@end
