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
@class OMBRoommate;

@interface OMBRenterApplication : NSObject

@property (nonatomic) BOOL cats;
@property (nonatomic) NSInteger coapplicantCount;
@property (nonatomic) BOOL dogs;
@property (nonatomic) BOOL facebookAuthenticated;
@property (nonatomic) BOOL hasCosigner;
@property (nonatomic, strong) NSMutableDictionary *legalAnswers;
@property (nonatomic) BOOL linkedinAuthenticated;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addCosigner: (OMBCosigner *) object;
- (void) addEmployment: (OMBEmployment *) object;
- (void) addLegalAnswer: (OMBLegalAnswer *) legalAnswer;
- (void) addModel: (OMBObject *) object;
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
- (void) fetchListForResourceName: (NSString *) resourceName
userUID: (NSUInteger) userUID delegate: (id) delegate
completion: (void (^) (NSError *error)) block;
- (void) fetchSentApplicationsWithDelegate: (id) delegate
completion: (void (^) (NSError *error)) block;
- (OMBLegalAnswer *) legalAnswerForLegalQuestion:
(OMBLegalQuestion *) legalQuestion;
- (NSArray *) objectsWithModelName: (NSString *) modelName
sortedWithKey: (NSString *) key ascending: (BOOL)  ascending;
- (void) readFromCosignerDictionary: (NSDictionary *) dictionary;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) readFromDictionary: (NSDictionary *) dictionary
forModelName: (NSString *) modelName;
- (void) removeAllObjects;
- (void) removeCosigner: (OMBCosigner *) object;
- (void) removeEmployment: (OMBEmployment *) object;
- (void) removeModel: (OMBObject *) object;
- (void) removeRoommate: (OMBRoommate *) roommate;
- (NSArray *) roommatesSort;
- (NSArray *) sentApplicationsSortedByKey: (NSString *) key
ascending: (BOOL) ascending;
- (void) updateWithDictionary: (NSDictionary *) dictionary
completion: (void (^) (NSError *error)) block;

@end
