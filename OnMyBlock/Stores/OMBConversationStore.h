//
//  OMBConversationStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBConversationStore : NSObject

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBConversationStore *) sharedStore;

#pragma mark - Instance Methods

- (void) fetchConversationsAtPage: (NSUInteger) page delegate: (id) delegate
completion: (void (^) (NSError *error)) block;
- (NSUInteger) numberOfConversations;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) removeAllObjects;
- (NSArray *) sortedConversationsWithKey: (NSString *) key 
ascending: (BOOL) ascending;

@end
