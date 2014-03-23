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
@class OMBObject;
@class OMBPreviousRental;
@class OMBRoommate;

@interface OMBRenterApplication : NSObject

@property (nonatomic) BOOL cats;
@property (nonatomic) NSInteger coapplicantCount;
@property (nonatomic) BOOL dogs;
@property (nonatomic) BOOL facebookAuthenticated;
@property (nonatomic) BOOL hasCosigner;
@property (nonatomic, strong) NSMutableDictionary *legalAnswers;
@property (nonatomic) BOOL linkedinAuthenticated;
@property (nonatomic, strong) NSMutableArray *previousRentals;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addCosigner: (OMBCosigner *) object;
- (void) addEmployment: (OMBEmployment *) object;
- (void) addLegalAnswer: (OMBLegalAnswer *) legalAnswer;
- (void) addPreviousRental: (OMBPreviousRental *) previousRental;
- (void) addRoommate: (OMBRoommate *) object;
- (NSArray *) cosignersSortedByFirstName;
- (void) createCosignerConnection: (OMBCosigner *) cosigner
delegate: (id) delegate completion: (void (^) (NSError *error)) block;
- (void) createModelConnection: (OMBObject *) object
delegate: (id) delegate completion: (void (^) (NSError *error)) block;
- (void) deleteCosignerConnection: (OMBCosigner *) cosigner
delegate: (id) delegate completion: (void (^) (NSError *error)) block;
- (void) deleteModelConnection: (OMBObject *) object
delegate: (id) delegate completion: (void (^) (NSError *error)) block;
- (NSArray *) employmentsSortedByStartDate;
- (void) fetchCosignersForUserUID: (NSUInteger) userUID delegate: (id) delegate
completion: (void (^) (NSError *error)) block;
- (void) fetchListForModel: (id) object userUID: (NSUInteger) userUID 
delegate: (id) delegate completion: (void (^) (NSError *error)) block;
- (OMBLegalAnswer *) legalAnswerForLegalQuestion: 
(OMBLegalQuestion *) legalQuestion;
- (NSArray *) previousRentalsSort;
- (void) readFromCosignerDictionary: (NSDictionary *) dictionary;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) readFromDictionary: (NSDictionary *) dictionary
forModelName: (NSString *) modelName;
- (void) removeAllObjects;
- (void) removeCosigner: (OMBCosigner *) object;
- (void) removeEmployment: (OMBEmployment *) object;
- (void) removeModel: (OMBObject *) object;
- (void) removePreviousRental:(OMBPreviousRental *)object;
- (void) removeRoommate: (OMBRoommate *) roommate;
- (NSArray *) roommatesSort;
- (void) updateWithDictionary: (NSDictionary *) dictionary
completion: (void (^) (NSError *error)) block;

@end
