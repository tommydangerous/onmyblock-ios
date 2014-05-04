//
//  OMBFeedbackSendEmailConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 5/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFeedbackSendEmailConnection.h"

@implementation OMBFeedbackSendEmailConnection

#pragma mark - Initializer

- (id) initWithEmail: (NSString *) email content: (NSString *) content
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/feedbacks/send_email",
    OnMyBlockAPIURL];
  [self setPostRequestWithString: string parameters: @{
    @"email":   email ? email : @"",
    @"content": content ? content : @""
  }];

  return self;
}

@end
