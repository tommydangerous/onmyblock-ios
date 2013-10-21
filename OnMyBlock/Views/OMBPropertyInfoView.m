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

    // Bedrooms
    bedroomsLabel = [[UILabel alloc] init];
    bedroomsLabel.backgroundColor = [UIColor clearColor];
    bedroomsLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
    bedroomsLabel.frame = CGRectMake(100, 50, (screen.size.width - 100), 25);
    bedroomsLabel.textColor = [UIColor textColor];
    [self addSubview: bedroomsLabel];
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
  NSString *bedsString = @"beds";
  if (property.bedrooms == 1)
    bedsString = @"bed";
  NSString *bedsNumberString;
  if (property.bedrooms == (int) property.bedrooms) {
    bedsNumberString = [NSString stringWithFormat: @"%i", 
      (int) property.bedrooms];
  }
  else {
    bedsNumberString = [NSString stringWithFormat: @"%f",
      property.bedrooms];
  }
  bedroomsLabel.text = [NSString stringWithFormat: @"%@ %@", 
    bedsNumberString, bedsString];
}

@end
