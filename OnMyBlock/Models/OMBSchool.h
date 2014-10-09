//
//  OMBSchool.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBSchool : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *realName;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void)readFromQBox:(NSDictionary *)dic;
- (NSString *)realName;

@end
