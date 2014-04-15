//
//  QVCoordinateQuadTree.h
//  MapCluster
//
//  Created by Tommy DANGerous on 4/14/14.
//  Copyright (c) 2014 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QVQuadTree.h"

@interface QVCoordinateQuadTree : NSObject

@property (strong, nonatomic) MKMapView *mapView;
@property (assign, nonatomic) QVQuadTreeNode *root;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) buildTree;
- (void) buildTreeWithResidences: (NSArray *) array;
- (NSArray *) clusteredAnnotationsWithinMapRect: (MKMapRect) rect
withZoomScale: (double) zoomScale;

@end
