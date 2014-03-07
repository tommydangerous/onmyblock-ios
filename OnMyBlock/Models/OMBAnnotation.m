//
//  OMBAnnotation.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBAnnotation.h"

@implementation OMBAnnotation

#pragma mark - Setters

- (void) setCoordinate: (CLLocationCoordinate2D) coord
{
  _coordinate = coord;
}

- (void) setTitle: (NSString *) string
{
  _title = string;
}

#pragma mark - Override

#pragma mark - Override NSObject

- (NSUInteger) hash
{
  if (self.residenceUID)
    return self.residenceUID;
  return [super hash];
}

- (BOOL) isEqual: (id) anObject
{
  if ([anObject isKindOfClass: [OMBAnnotation class]]) {
    if (self.residenceUID) {
      if (self.residenceUID == [(OMBAnnotation *) anObject residenceUID]) {
        return YES;
      }
    } 
  }
  return [super hash] == [anObject hash];
}

@end
