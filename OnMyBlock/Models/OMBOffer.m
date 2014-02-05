//
//  OMBOffer.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOffer.h"

#import "NSString+Extensions.h"
#import "OMBAllResidenceStore.h"
#import "OMBResidence.h"
#import "OMBUser.h"
#import "OMBUserStore.h"

NSInteger kMaxHoursForLandlordToAccept = 24;
NSInteger kMaxHoursForStudentToConfirm = 48;

@implementation OMBOffer

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _accepted  = NO;
  _amount    = 0.0f;
  _confirmed = NO;
  _declined  = NO;
  _onHold    = NO;
  _rejected  = NO;

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (BOOL) isExpiredForLandlord
{
  if (!_accepted && !_declined && [self timeLeftForLandlord] < 0)
    return YES;
  return NO;
}

- (BOOL) isExpiredForStudent
{
  if (_accepted && _acceptedDate && [self timeLeftForStudent] < 0)
    return YES;
  return NO;
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  // {
  //   accepted: 0,
  //   amount: "1966.0",
  //   confirmed: 0,
  //   created_at: "2014-01-14 11:56:02 -0800",
  //   declined: 0,
  //   rejected: 0,
  //   residence_id: 161,
  //   updated_at: "2014-01-14 11:56:02 -0800",
  //   user: {
  //     about: "I am an awesome person and I would like to find a friend",
  //     email: "elon@tesla.com",
  //     first_name: "elon",
  //     id: 47,
  //     image_url: "default_user_image.png",
  //     last_name: "elon",
  //     phone: "4081234567",
  //     school: "University of California - Berkeley",
  //     success: 1,
  //     user_type: ""
  //   }
  // }

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat       = @"yyyy-MM-dd HH:mm:ss ZZZ";
  // Accepted
  if ([[dictionary objectForKey: @"accepted"] intValue])
    _accepted = YES;
  else
    _accepted = NO;
  // Accepted date
  if ([dictionary objectForKey: @"accepted_date"] != [NSNull null])
    _acceptedDate = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"accepted_date"]] timeIntervalSince1970];
  // Amount
  _amount = [[dictionary objectForKey: @"amount"] floatValue];
  // Confirmed
  if ([[dictionary objectForKey: @"confirmed"] intValue])
    _confirmed = YES;
  else
    _confirmed = NO;
  // Created at
  if ([dictionary objectForKey: @"created_at"] != [NSNull null])
    _createdAt = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"created_at"]] timeIntervalSince1970];
  // Declined
  if ([[dictionary objectForKey: @"declined"] intValue])
    _declined = YES;
  else
    _declined = NO;
  // Landlord user
  if ([dictionary objectForKey: @"landlord_user"] != [NSNull null]) {
    NSDictionary *userDict = [dictionary objectForKey: @"landlord_user"];
    int userUID = [[userDict objectForKey: @"id"] intValue];
    OMBUser *user = [[OMBUserStore sharedStore] userWithUID: userUID];
    if (!user) {
      user = [[OMBUser alloc] init];
    }
    [user readFromDictionary: userDict];
    _landlordUser = user;
  }
  // Note
  if ([dictionary objectForKey: @"note"] != [NSNull null])
    _note = [dictionary objectForKey: @"note"];
  // On hold
  if ([[dictionary objectForKey: @"on_hold"] intValue])
    _onHold = YES;
  else
    _onHold = NO;
  // Rejected
  if ([[dictionary objectForKey: @"rejected"] intValue])
    _rejected = YES;
  else
    _rejected = NO;
  // Residence
  if ([dictionary objectForKey: @"residence"] != [NSNull null]) {
    NSDictionary *resDict = [dictionary objectForKey: @"residence"];
    NSInteger residenceUID = [[resDict objectForKey: @"id"] intValue];
    OMBResidence *res = [[OMBAllResidenceStore sharedStore] residenceForUID:
      residenceUID];
    if (!res) {
      res = [[OMBResidence alloc] init];
    }
    [res readFromResidenceDictionary: resDict];
    _residence = res;
  }
  // Updated at
  if ([dictionary objectForKey: @"updated_at"] != [NSNull null])
    _updatedAt = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"updated_at"]] timeIntervalSince1970];
  // UID
  if ([dictionary objectForKey: @"id"] != [NSNull null])
    _uid = [[dictionary objectForKey: @"id"] intValue];
  // User
  if ([dictionary objectForKey: @"user"] != [NSNull null]) {
    NSDictionary *userDict = [dictionary objectForKey: @"user"];
    int userUID = [[userDict objectForKey: @"id"] intValue];
    OMBUser *user = [[OMBUserStore sharedStore] userWithUID: userUID];
    if (!user) {
      user = [[OMBUser alloc] init];
      [user readFromDictionary: userDict];
    }
    _user = user;
  }
}

- (OMBOfferStatusForLandlord) statusForLandlord
{
  if (_rejected) {
    return OMBOfferStatusForLandlordRejected;
  }
  else if (_confirmed) {
    return OMBOfferStatusForLandlordConfirmed;
  }
  else if (_accepted) {
    if ([self isExpiredForStudent]) {
      return OMBOfferStatusForLandlordExpired;
    }
    else {
      return OMBOfferStatusForLandlordAccepted;
    }
  }
  else if (_onHold) {
    return OMBOfferStatusForLandlordOnHold;
  }
  else if (_declined) {
    return OMBOfferStatusForLandlordDeclined;
  }
  else if ([self isExpiredForLandlord]) {
    return OMBOfferStatusForLandlordExpired;
  }
  return OMBOfferStatusForLandlordResponseRequired;
}

- (OMBOfferStatusForStudent) statusForStudent
{
  if (_rejected) {
    return OMBOfferStatusForStudentRejected;
  }
  else if (_confirmed) {
    return OMBOfferStatusForStudentConfirmed;
  }
  else if (_accepted) {
    if ([self isExpiredForStudent]) {
      return OMBOfferStatusForStudentExpired;
    }
    else {
      return OMBOfferStatusForStudentAccepted;
    }
  }
  else if (_onHold) {
    return OMBOfferStatusForStudentOnHold;
  }
  else if (_declined) {
    return OMBOfferStatusForStudentDeclined;
  }
  else if ([self isExpiredForLandlord]) {
    return OMBOfferStatusForStudentExpired;
  }
  return OMBOfferStatusForStudentWaitingForLandlordResponse;
}

- (NSString *) statusStringForLandlord
{
  switch ([self statusForStudent]) {
    case OMBOfferStatusForLandlordRejected: {
      return @"student rejected";
      break;
    }
    case OMBOfferStatusForLandlordConfirmed: {
      return @"student confirmed";
      break;
    }
    case OMBOfferStatusForLandlordAccepted: {
      return @"waiting for student response";
      break;
    }
    case OMBOfferStatusForLandlordOnHold: {
      return @"on hold";
      break;
    }
    case OMBOfferStatusForLandlordDeclined: {
      return @"declined";
      break;
    }
    case OMBOfferStatusForLandlordResponseRequired: {
      return @"response required";
      break;
    }
    case OMBOfferStatusForLandlordExpired: {
      return @"offer expired";
      break;
    }
    default:
      break;
  }
  return @"";
}

- (NSString *) statusStringForStudent
{
  switch ([self statusForStudent]) {
    case OMBOfferStatusForStudentRejected: {
      return @"rejected";
      break;
    }
    case OMBOfferStatusForStudentConfirmed: {
      return @"move-in confirmed";
      break;
    }
    case OMBOfferStatusForStudentAccepted: {
      return @"response required";
      break;
    }
    case OMBOfferStatusForStudentOnHold: {
      return @"on hold";
      break;
    }
    case OMBOfferStatusForStudentDeclined: {
      return @"landlord declined";
      break;
    }
    case OMBOfferStatusForStudentWaitingForLandlordResponse: {
      return @"waiting for landlord response";
      break;
    }
    case OMBOfferStatusForStudentExpired: {
      return @"offer expired";
      break;
    }
    default:
      break;
  }
  return @"";
}

- (NSInteger) timeLeftForLandlord
{
  NSInteger secondsInADay = 60 * 60 * kMaxHoursForLandlordToAccept;
  NSInteger aDayFromCreatedAt = _createdAt + secondsInADay;
  return aDayFromCreatedAt - [[NSDate date] timeIntervalSince1970];
}

- (NSInteger) timeLeftForStudent
{
  NSInteger secondsInADay = 60 * 60 * kMaxHoursForStudentToConfirm;
  return (_acceptedDate + secondsInADay) - 
    [[NSDate date] timeIntervalSince1970];
}

- (CGFloat) timeLeftPercentageForLandlord
{
  return [self timeLeftForLandlord] / 
    (CGFloat) (60 * 60 * kMaxHoursForLandlordToAccept);
}

- (CGFloat) timeLeftPercentageForStudent
{
  return [self timeLeftForStudent] / 
    (CGFloat) (60 * 60 * kMaxHoursForStudentToConfirm);
}

- (NSString *) timeLeftStringForLandlord
{
  return [NSString timeRemainingShortFormatWithAllUnitsInterval:
    _createdAt + (60 * 60 * kMaxHoursForLandlordToAccept)];
}

- (NSString *) timeLeftStringForStudent
{
  return [NSString timeRemainingShortFormatWithAllUnitsInterval:
    _acceptedDate + (60 * 60 * kMaxHoursForStudentToConfirm)];
}

- (CGFloat) totalAmount
{
  CGFloat deposit = 0.0f;
  if (_residence.deposit)
    deposit = _residence.deposit;
  return _amount + deposit;
}

@end
