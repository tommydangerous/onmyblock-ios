//
//  OMBRenterApplication.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBCosigner;
@class OMBEmployment;
@class OMBLegalAnswer;
@class OMBLegalQuestion;
@class OMBPreviousRental;

@interface OMBRenterApplication : NSObject

@property (nonatomic) BOOL cats;
@property (nonatomic, strong) NSMutableArray *cosigners;
@property (nonatomic) BOOL dogs;
@property (nonatomic, strong) NSMutableArray *employments;
@property (nonatomic, strong) NSMutableDictionary *legalAnswers;
@property (nonatomic, strong) NSMutableArray *previousRentals;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addCosigner: (OMBCosigner *) cosigner;
- (void) addEmployment: (OMBEmployment *) employment;
- (void) addLegalAnswer: (OMBLegalAnswer *) legalAnswer;
- (void) addPreviousRental: (OMBPreviousRental *) previousRental;
- (NSArray *) cosignersSortedByFirstName;
- (NSArray *) employmentsSortedByStartDate;
- (OMBLegalAnswer *) legalAnswerForLegalQuestion: 
(OMBLegalQuestion *) legalQuestion;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) removeAllObjects;

@end
