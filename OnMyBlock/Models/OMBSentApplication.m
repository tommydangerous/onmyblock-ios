//
//  OMBSentApplication.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 5/19/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSentApplication.h"

#import "NSDateFormatter+JSON.h"

@implementation OMBSentApplication

#pragma mark - Methods

#pragma mark - Class Methods

#pragma mark - Public

+ (NSString *)modelName
{
  return @"sent_application";
}

+ (NSString *)resourceName
{
  return [NSString stringWithFormat:@"%@s", [OMBSentApplication modelName]];
}

#pragma mark - Instance Methods

#pragma mark - Public

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

  NSInteger yearDifference = [moveOutComps year] - [moveInComps year];
  moveOutMonth += (12 * yearDifference);

  return moveOutMonth - moveInMonth;
}

- (OMBSentApplicationStatus) status
{
  // Paid
  if (self.paid) {
    return OMBSentApplicationStatusPaid;
  }
  // Accepted
  else if (self.accepted) {
    return OMBSentApplicationStatusAccepted;
  }
  // Declined
  else if (self.declined) {
    return OMBSentApplicationStatusDeclined;
  }
  // Cancelled
  else if (self.cancelled) {
    return OMBSentApplicationStatusCancelled;
  }
  return OMBSentApplicationStatusPending;
}

- (void)readFromDictionary:(NSDictionary *)dictionary
{
  // Sample JSON
  // {
  //   id: 94,
  //   renter_application_id: 2,
  //   residence_id: 218,
  //   created_at: "2014-06-12 12:25:40 -0700",
  //   updated_at: "2014-06-15 09:11:18 -0700",
  //   move_in_date: "2014-08-07 00:00:00 -0700",
  //   move_out_date: "2015-07-09 00:00:00 -0700",
  //   sent: true,
  //   landlord_user_id: 3,
  //   created_source: "web",
  //   accepted: false,
  //   declined: true,
  //   cancelled: false,
  //   accepted_date: null
  // }

  NSDateFormatter *dateFormatter = [NSDateFormatter JSONDateParser];
  [dateFormatter setDateFormatRubyDefault];

  // Accepted
  id accepted = [dictionary objectForKey: @"accepted"];
  if (accepted != [NSNull null])
    self.accepted = [accepted boolValue];

  // Accepted date
  id acceptedDate = [dictionary objectForKey: @"accepted_date"];
  if (acceptedDate != [NSNull null])
    self.acceptedDate = [[dateFormatter dateFromString:
      acceptedDate] timeIntervalSince1970];

  // Cancelled
  id cancelled = [dictionary objectForKey: @"cancelled"];
  if (cancelled != [NSNull null])
    self.cancelled = [cancelled boolValue];

  // Created at
  id createdAt = [dictionary objectForKey: @"created_at"];
  if (createdAt != [NSNull null])
    self.createdAt = [[dateFormatter dateFromString:
      createdAt] timeIntervalSince1970];

  // Declined
  id declined = [dictionary objectForKey: @"declined"];
  if (declined != [NSNull null])
    self.declined = [declined boolValue];

  // Landlord User ID

  // Move in date
  id moveInDate = [dictionary objectForKey: @"move_in_date"];
  if (moveInDate != [NSNull null])
    self.moveInDate = [[dateFormatter dateFromString:
      moveInDate] timeIntervalSince1970];

  // Move out date
  id moveOutDate = [dictionary objectForKey: @"move_out_date"];
  if (moveOutDate != [NSNull null])
    self.moveOutDate = [[dateFormatter dateFromString:
      moveOutDate] timeIntervalSince1970];

  // Renter Application ID

  // Residence ID
  id residenceID = [dictionary objectForKey: @"residence_id"];
  if (residenceID != [NSNull null])
    self.residenceID = [residenceID intValue];

  // Sent
  id sent = [dictionary objectForKey: @"sent"];
  if (sent != [NSNull null])
    self.sent = [sent boolValue];

  // Updated at
  
  // UID
  id uid = [dictionary objectForKey: @"id"];
  if (uid != [NSNull null])
    self.uid = [uid intValue];
}

- (NSString *)modelName
{
  return [OMBSentApplication modelName];
}

- (NSString *)resourceName
{
  return [OMBSentApplication resourceName];
}

@end
