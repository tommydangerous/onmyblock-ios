//
//  OMBAnnotationView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface OMBAnnotationView : MKAnnotationView
{
  UILabel *label;
}

#pragma mark - Instance Methods

- (void) loadAnnotation: (id <MKAnnotation>) object;

@end
