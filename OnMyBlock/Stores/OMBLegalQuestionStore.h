//
//  OMBLegalQuestionStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBLegalQuestion;

@interface OMBLegalQuestionStore : NSObject

@property (nonatomic, strong) NSMutableDictionary *legalQuestions;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBLegalQuestionStore *) sharedStore;

#pragma mark - Instance Methods

#pragma mark - Public

- (void) addLegalQuestion: (OMBLegalQuestion *) object;
- (NSUInteger) legalQuestionsCount;
- (void) fetchLegalQuestionsWithCompletion: (void (^)(NSError *)) block;
- (NSArray *) questionsSortedByQuestion;

@end
