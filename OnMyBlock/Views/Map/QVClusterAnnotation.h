//
//  QVClusterAnnotation.h
//  MapCluster
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QVClusterAnnotationView;

@interface QVClusterAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) QVClusterAnnotationView *annotationView;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSArray *coordinates;
@property (assign, nonatomic) NSInteger count;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *title;
@property (nonatomic) bool rented;

#pragma mark - Initializer

- (id) initWithCoordinate: (CLLocationCoordinate2D) coordinate
count: (NSInteger) count;
- (id) initWithCoordinate: (CLLocationCoordinate2D) coordinate
count: (NSInteger) count coordinates: (NSArray *) array;

@end
