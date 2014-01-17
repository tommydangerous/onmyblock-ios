//
//  OMBResidenceStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBMapViewController;
@class OMBResidence;

@interface OMBResidenceStore : NSObject

@property (nonatomic, strong) OMBMapViewController *mapViewController;
@property (nonatomic, strong) NSMutableDictionary *residences;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBResidenceStore *) sharedStore;

#pragma mark Instance Methods

- (void) addResidence: (OMBResidence *) residence;
- (void) fetchPropertiesWithParameters: (NSDictionary *) parameters
completion: (void (^)(NSError *error)) completion;
- (NSArray *) propertiesFromAnnotations: (NSSet *) annotations 
sortedBy: (NSString *) string ascending: (BOOL) ascending;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) readFromPropertiesDictionary: (NSDictionary *) dictionary;

@end
