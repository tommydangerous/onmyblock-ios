//
//  OMBFinishListingDescriptionViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingDescriptionViewController.h"

#import "NSString+Extensions.h"
#import "UIColor+Extensions.h"

@implementation OMBFinishListingDescriptionViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  self.screenName = self.title = @"Description";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  CGRect screen = [[UIScreen mainScreen] bounds];

  CGFloat originY = 20.0f + 44.0f;
  CGFloat padding = 10.0f;

  descriptionTextView = [UITextView new];
  descriptionTextView.autocorrectionType = UITextAutocorrectionTypeYes;
  descriptionTextView.delegate = self;
  descriptionTextView.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  descriptionTextView.frame = CGRectMake(padding, originY + padding, 
    screen.size.width - (padding * 2), 
      screen.size.height - (originY + padding + padding + 216.0f));
  descriptionTextView.textColor = [UIColor textColor];
  [self.view addSubview: descriptionTextView];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];
  [descriptionTextView becomeFirstResponder];
}

#pragma mark - Protocol

#pragma mark - Protocol UITextViewDelegate

- (void) textViewDidChange: (UITextView *) textView
{
  if ([[textView.text stripWhiteSpace] length]) {
    saveBarButtonItem.enabled = YES;
  }
  else {
    saveBarButtonItem.enabled = NO;
  }
}

@end
