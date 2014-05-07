//
//  OMBAnnotationView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

@interface OMBAnnotationView : MKAnnotationView
{
  UIView *insideView;
  UILabel *label;
}

#pragma mark - Instance Methods

- (void) deselect;
- (void) loadAnnotation: (id <MKAnnotation>) annotation;
- (void) select;

@end
