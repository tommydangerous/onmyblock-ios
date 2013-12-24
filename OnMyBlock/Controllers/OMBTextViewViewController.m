//
//  OMB_textViewViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTextViewViewController.h"

#import "UIColor+Extensions.h"

@implementation OMBTextViewViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Text View Controller";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Save"
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(save)];

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.view = [[UIView alloc] initWithFrame: screen];

  _textView = [UITextView new];
  _textView.contentInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, -20.0f);
  _textView.delegate = self;
  _textView.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  _textView.frame = CGRectMake(0.0f, 0.0f, screen.size.width,
    screen.size.height - 216.0f);
  _textView.textColor = [UIColor textColor];
  [self.view addSubview: _textView];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];
  [_textView becomeFirstResponder];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) dismiss
{
  [self.navigationController popViewControllerAnimated: YES];
}

- (void) save
{
  // Subclasses implement this
  [self dismiss];
}

@end
