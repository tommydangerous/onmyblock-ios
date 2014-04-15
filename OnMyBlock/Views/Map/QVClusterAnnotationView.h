//
//  QVClusterAnnotationView.h
//  MapCluster
//
//  Created by Tommy DANGerous on 4/14/14.
//  Copyright (c) 2014 Quantum Ventures. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface QVClusterAnnotationView : MKAnnotationView

@property (assign, nonatomic) NSUInteger count;
@property (nonatomic) BOOL isSelected;

- (void) deselect;
- (void) select;

@end
