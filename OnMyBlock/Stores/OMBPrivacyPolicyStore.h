//
//  OMBPrivacyPolicyStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBPrivacyPolicyStore : NSObject

@property (nonatomic, strong) NSArray *sections;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBPrivacyPolicyStore *) sharedStore;

@end
