//
//  OMBOffer.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOffer.h"

#import <Parse/Parse.h>

#import "NSString+Extensions.h"
#import "NSString+OnMyBlock.h"
#import "OMBAllResidenceStore.h"
#import "OMBPayoutTransaction.h"
#import "OMBResidence.h"
#import "OMBUser.h"
#import "OMBUserStore.h"

NSInteger kMaxHoursForLandlordToAccept = 24 * 4;
NSInteger kMaxHoursForStudentToConfirm = 24 * 7;
CGFloat kOfferDownPaymentPercentage    = 0.1;

#if __ENVIRONMENT__ == 1
  NSInteger kWebServerTimeOffsetInSeconds = 0;
#else
  // The web server's time is ahead
  NSInteger kWebServerTimeOffsetInSeconds = 60 + 37;
#endif

NSString *const OMBOfferNotificationPaidWithVenmo =
  @"OMBOfferNotificationPaidWithVenmo";
NSString *const OMBOfferNotificationProcessingWithServer =
  @"OMBOfferNotificationProcessingWithServer";
NSString *const OMBOfferNotificationVenmoAppSwitchCancelled =
  @"OMBOfferNotificationVenmoAppSwitchCancelled";

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

#pragma mark - Class Methods

+ (CGFloat) downPaymentPercentage
{
  return kOfferDownPaymentPercentage;
}

#pragma mark - Instance Methods

- (CGFloat) downPaymentAmount
{

  return [self totalAmount] * [OMBOffer downPaymentPercentage];
}

- (BOOL) isExpiredForLandlord
{
  if (
    !_accepted &&
    !_acceptedDate &&
    !_confirmed &&
    !_declined &&
    !_rejected &&
    [self timeLeftForLandlord] < 0) {

    return YES;
  }
  return NO;
}

- (BOOL) isExpiredForStudent
{
  if (
    _accepted &&
    _acceptedDate &&
    !_confirmed &&
    !_declined &&
    !_rejected &&
    [self timeLeftForStudent] < 0) {

    return YES;
  }
  return NO;
}

- (NSInteger) numberOfMonthsBetweenMovingDates
{
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSUInteger unitFlags = (NSDayCalendarUnit | NSMonthCalendarUnit |
    NSWeekdayCalendarUnit | NSYearCalendarUnit);

  NSDateComponents *moveInComps = [calendar components: unitFlags
    fromDate: [NSDate dateWithTimeIntervalSince1970: _moveInDate]];
  [moveInComps setDay: 1];
  NSDateComponents *moveOutComps = [calendar components: unitFlags
    fromDate: [NSDate dateWithTimeIntervalSince1970: _moveOutDate]];
  [moveOutComps setDay: 1];

  NSInteger moveInMonth  = [moveInComps month];
  NSInteger moveOutMonth = [moveOutComps month];
  NSLog(@"%i", moveInMonth);
  NSLog(@"%i", moveOutMonth);

  NSInteger yearDifference = [moveOutComps year] - [moveInComps year];
  moveOutMonth += (12 * yearDifference);

  return moveOutMonth - moveInMonth;
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

  // Move in date
  if ([dictionary objectForKey: @"move_in_date"] != [NSNull null])
    _moveInDate = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"move_in_date"]] timeIntervalSince1970];

  // Move out date
  if ([dictionary objectForKey: @"move_out_date"] != [NSNull null])
    _moveOutDate = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"move_out_date"]] timeIntervalSince1970];

  // Note
  if ([dictionary objectForKey: @"note"] != [NSNull null])
    _note = [dictionary objectForKey: @"note"];
  // On hold
  if ([[dictionary objectForKey: @"on_hold"] intValue])
    _onHold = YES;
  else
    _onHold = NO;

  // Payout Transaction
  if ([dictionary objectForKey: @"payout_transaction"] != [NSNull null]) {
    OMBPayoutTransaction *object = [[OMBPayoutTransaction alloc] init];
    [object readFromDictionary:
      [dictionary objectForKey: @"payout_transaction"]];
    _payoutTransaction = object;
  }

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

- (CGFloat) remainingBalanceAmount
{
  return [self totalAmount] - [self downPaymentAmount];
}

- (void) sendPushNotificationAccepted
{
  NSString *alert = [NSString stringWithFormat:
    @"Your offer for %@ has been accepted!",
      [self.residence.address capitalizedString]];
  PFPush *push = [[PFPush alloc] init];
  [push expireAfterTimeInterval: 60 * 60 * 24 * 7];
  [push setChannel: [OMBUser pushNotificationChannelForOffersPlaced:
    self.user.uid]];
  [push setData: @{
    @"alert": alert,
    @"badge": ParseBadgeIncrement,
    @"offer_id": [NSNumber numberWithInt: self.uid]
  }];
  [push sendPushInBackground];
}

- (OMBOfferStatusForLandlord) statusForLandlord
{
  if (_rejected) {
    return OMBOfferStatusForLandlordRejected;
  }
  else if (_confirmed) {
    if (_payoutTransaction) {
      if (_payoutTransaction.paid) {
        return OMBOfferStatusForLandlordOfferPaid;
      }
      else if (_payoutTransaction.expired) {
        return OMBOfferStatusForLandlordOfferPaidExpired;
      }
      else {
        return OMBOfferStatusForLandlordConfirmed;
      }
    }
    else {
      return OMBOfferStatusForLandlordConfirmed;
    }
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
    if (_payoutTransaction) {
      if (_payoutTransaction.paid) {
        return OMBOfferStatusForStudentOfferPaid;
      }
      else if (_payoutTransaction.expired) {
        return OMBOfferStatusForStudentOfferPaidExpired;
      }
      else {
        return OMBOfferStatusForStudentConfirmed;
      }
    }
    else {
      return OMBOfferStatusForStudentConfirmed;
    }
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
      return @"applicant rejected";
      break;
    }
    case OMBOfferStatusForLandlordConfirmed: {
      return @"applicant confirmed - paid";
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
    case OMBOfferStatusForLandlordOfferPaid: {
      return @"student confirmed & paid";
      break;
    }
    case OMBOfferStatusForLandlordOfferPaidExpired: {
      return @"student took too long to pay";
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
      return @"confirmed - not paid";
      break;
    }
    case OMBOfferStatusForStudentAccepted: {
      return @"confirmation required";
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
      return @"waiting for response";
      break;
    }
    case OMBOfferStatusForStudentExpired: {
      return @"offer expired";
      break;
    }
    case OMBOfferStatusForStudentOfferPaid: {
      return @"confirmed & paid";
      break;
    }
    case OMBOfferStatusForStudentOfferPaidExpired: {
      return @"took too long to pay";
      break;
    }
    default:
      break;
  }
  return @"";
}

- (NSInteger) timeLeftForLandlord
{
  NSInteger seconds  = 60 * 60 * kMaxHoursForLandlordToAccept;
  NSInteger deadline = _createdAt + seconds;
  // Account for the server being ahead 1 minute and 20 seconds
  deadline -= kWebServerTimeOffsetInSeconds;
  return deadline - [[NSDate date] timeIntervalSince1970];
}

- (NSInteger) timeLeftForStudent
{
  NSInteger seconds  = 60 * 60 * kMaxHoursForStudentToConfirm;
  NSInteger deadline = _acceptedDate + seconds;
  // Account for the server being ahead 1 minute and 20 seconds
  deadline -= kWebServerTimeOffsetInSeconds;
  return deadline - [[NSDate date] timeIntervalSince1970];
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
  NSInteger seconds  = 60 * 60 * kMaxHoursForLandlordToAccept;
  NSInteger deadline = _createdAt + seconds;
  // Account for the server being ahead 1 minute and 20 seconds
  deadline -= kWebServerTimeOffsetInSeconds;
  return [NSString timeRemainingShortFormatWithAllUnitsInterval: deadline];
}

- (NSString *) timeLeftStringForStudent
{
  NSInteger seconds  = 60 * 60 * kMaxHoursForStudentToConfirm;
  NSInteger deadline = _acceptedDate + seconds;
  // Account for the server being ahead 1 minute and 20 seconds
  deadline -= kWebServerTimeOffsetInSeconds;
  return [NSString timeRemainingShortFormatWithAllUnitsInterval: deadline];
}

- (NSString *) timelineStringForLandlord
{
  return [NSString stringWithFormat: @"%i hours", kMaxHoursForLandlordToAccept];
}

- (NSString *) timelineStringForStudent
{
  NSString *unit = @"hour";
  NSUInteger i = kMaxHoursForStudentToConfirm;
  NSUInteger week = 1 * 24 * 7;
  NSUInteger day  = 1 * 24;
  // NSUInteger hour = 1;
  if (kMaxHoursForStudentToConfirm >= week) {
    unit = @"week";
    i = kMaxHoursForStudentToConfirm / week;
  }
  else if (kMaxHoursForStudentToConfirm >= day) {
    unit = @"day";
    i = kMaxHoursForStudentToConfirm / day;
  }
  if (i != 1)
    unit = [unit stringByAppendingString: @"s"];
  return [NSString stringWithFormat: @"%i %@", i, unit];
}

- (CGFloat) totalAmount
{
  return self.amount + [self.residence deposit];
}

@end
