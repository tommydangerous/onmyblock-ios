//
//  OMBRadialGradient.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 4/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

@interface OMBRadialGradient : UIView
{
  NSArray *colors;
  BOOL direction;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame
         withColors:(NSArray *)arrayColors
             onLeft:(BOOL)left;

@end
