//
//  OMBMessageStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMessageStore.h"

#import "OMBMessage.h"
#import "OMBUser.h"

@implementation OMBMessageStore

// #pragma mark - Initializer

// - (id) init
// {
//   if (!(self = [super init])) return nil;

//   messages = [NSMutableDictionary dictionary];

//   return self;
// }

// #pragma mark - Methods

// #pragma mark - Class Methods

// + (OMBMessageStore *) sharedStore
// {
//   static OMBMessageStore *store = nil;
//   if (!store)
//     store = [[OMBMessageStore alloc] init];
//   return store;
// }

// #pragma mark - Instance Methods

// - (void) addMessage: (OMBMessage *) message
// {
//   OMBUser *user = message.sender;
//   if (user.uid == [OMBUser currentUser].uid)
//     user = message.recipient;
//   NSMutableArray *array = [messages objectForKey: 
//     [NSNumber numberWithInt: user.uid]];
//   if (!array) {
//     array = [NSMutableArray array];
//     [messages setObject: array forKey: [NSNumber numberWithInt: user.uid]];
//   }
//   NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i",
//     @"uid", message.uid];
//   if ([[array filteredArrayUsingPredicate: predicate] count] == 0)
//     [array addObject: message];
// }

// - (void) createFakeMessages
// {
//   for (int i = 0; i < 100; i++) {
//     int random = arc4random_uniform(100);
//     OMBMessage *message = [[OMBMessage alloc] init];
//     message.createdAt = [[NSDate date] timeIntervalSince1970];
//     message.content = [NSString stringWithFormat: @"Hey %i", random];
//     for (int n = 0; n < random * 0.5; n++) {
//       message.content = [message.content stringByAppendingString:
//         [NSString stringWithFormat: @"Hey %i", n]];
//     }
//     if (random % 2) {
//       message.createdAt += i;
//     }
//     else {
//       message.createdAt += i * random;
//     }
//     int random2 = arc4random_uniform(100);
//     if (random2 % 2) {
//       message.recipient = [OMBUser fakeUser];
//       message.sender = [OMBUser currentUser];
//     }
//     else {
//       message.recipient = [OMBUser currentUser];
//       message.sender = [OMBUser fakeUser];
//     }
//     int random3 = arc4random_uniform(100);
//     if (random3 % 2) {
//       message.viewed = YES;
//     }
//     else {
//       message.viewed = NO;
//     }
//     message.uid = i + 1;
//     [message calculateSizeForMessageCell];
//     [self addMessage: message];
//   }
// }

// - (NSArray *) mostRecentThreadedMessages
// {
//   NSMutableArray *array = [NSMutableArray array];
//   for (NSNumber *number in [messages allKeys]) {
//     int uid = [number intValue];
//     // Get all the messages between current user and user with uid
//     NSArray *msgs = [self sortedMessagesForUserUID: uid];
//     // Filter only the messages where the uid user is the sender
//     NSPredicate *predicate = [NSPredicate predicateWithFormat: 
//       @"%K == %i", @"sender.uid", uid];
//     msgs = [msgs filteredArrayUsingPredicate: predicate];
//     if ([msgs count])
//       [array addObject: [msgs objectAtIndex: [msgs count] - 1]];
//   }
//   NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"createdAt"
//     ascending: NO];
//   return [array sortedArrayUsingDescriptors: @[sort]];
// }

// - (NSArray *) sortedMessagesForUserUID: (int) uid
// {
//   NSArray *array = [messages objectForKey: [NSNumber numberWithInt: uid]];
//   NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"createdAt"
//     ascending: YES];
//   return [array sortedArrayUsingDescriptors: @[sort]];
// }

@end
