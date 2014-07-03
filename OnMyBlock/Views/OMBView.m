//
//  OMBView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBView.h"

@implementation OMBView

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void) mixpanelTrack: (NSString *) eventName 
properties: (NSDictionary *) dictionary
{
  if (__ENVIRONMENT__ == 3) {
    [[Mixpanel sharedInstance] track: eventName properties: dictionary];
  }
  else {
    NSLog(@"%@: %@", eventName, dictionary);
  }
}

@end
