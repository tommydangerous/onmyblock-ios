//
//  OMBAnnotation.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBAnnotationView;

@interface OMBAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) OMBAnnotationView *annotationView;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic) NSUInteger residenceUID;

#pragma mark - Setters

- (void) setCoordinate: (CLLocationCoordinate2D) coord;
- (void) setTitle: (NSString *) string;

@end
