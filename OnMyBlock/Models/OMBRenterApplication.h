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
@property (nonatomic) NSInteger coapplicantCount;
@property (nonatomic) BOOL dogs;
@property (nonatomic, strong) NSMutableArray *employments;
@property (nonatomic) BOOL facebookAuthenticated;
@property (nonatomic) BOOL hasCosigner;
@property (nonatomic, strong) NSMutableDictionary *legalAnswers;
@property (nonatomic) BOOL linkedinAuthenticated;
@property (nonatomic, strong) NSMutableArray *previousRentals;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addCosigner: (OMBCosigner *) cosigner;
- (void) addEmployment: (OMBEmployment *) employment;
- (void) addLegalAnswer: (OMBLegalAnswer *) legalAnswer;
- (void) addPreviousRental: (OMBPreviousRental *) previousRental;
- (NSArray *) cosignersSortedByFirstName;
- (void) createCosignerConnection: (OMBCosigner *) cosigner
delegate: (id) delegate completion: (void (^) (NSError *error)) block;
- (void) deleteCosignerConnection: (OMBCosigner *) cosigner
delegate: (id) delegate completion: (void (^) (NSError *error)) block;
- (NSArray *) employmentsSortedByStartDate;
- (void) fetchCosignersForUserUID: (NSUInteger) userUID delegate: (id) delegate
completion: (void (^) (NSError *error)) block;
- (OMBLegalAnswer *) legalAnswerForLegalQuestion: 
(OMBLegalQuestion *) legalQuestion;
- (NSArray *) previousRentalsSort;
- (void) readFromCosignerDictionary: (NSDictionary *) dictionary;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) removeAllObjects;
- (void) removeCosigner: (OMBCosigner *) cosigner;
- (void) removeEmployment: (OMBEmployment *) employment;
- (void) removePreviousRental:(OMBPreviousRental *)object;
- (void) updateWithDictionary: (NSDictionary *) dictionary
completion: (void (^) (NSError *error)) block;

@end
