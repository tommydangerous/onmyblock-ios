//
//  OMBResidenceAddPersonalNoteViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceAddPersonalNoteViewController.h"

@implementation OMBResidenceAddPersonalNoteViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Personal Note";

  return self;
}

@end
