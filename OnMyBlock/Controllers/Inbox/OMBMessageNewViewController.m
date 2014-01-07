//
//  OMBMessageNewViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMessageNewViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "OMBMessageCollectionViewCell.h"
#import "OMBMessageInputToolbar.h"
#import "UIColor+Extensions.h"

@implementation OMBMessageNewViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"New Message";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view = [[UIView alloc] initWithFrame: screen];

  CGFloat padding = [OMBMessageCollectionViewCell paddingForCell];
  CGFloat toolbarHeight = 44.0f;

  self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
      style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];

  // To view
  AMBlurView *toView = [AMBlurView new];
  toView.frame = CGRectMake(0.0f, 20.0f + toolbarHeight, 
    screen.size.width, toolbarHeight);
  [self.view addSubview: toView];
  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.backgroundColor = [UIColor grayLight].CGColor;
  bottomBorder.frame = CGRectMake(0.0f, toView.frame.size.height - 1.0f,
    toView.frame.size.width, 1.0f);
  [toView.layer addSublayer: bottomBorder];

  // To label
  UILabel *toLabel = [UILabel new];
  toLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  toLabel.text = @"To:";
  toLabel.textColor = [UIColor grayMedium];
  CGRect toLabelRect = [toLabel.text boundingRectWithSize: 
    CGSizeMake(screen.size.width, toolbarHeight) font: toLabel.font];
  toLabel.frame = CGRectMake(padding, 0.0f, toLabelRect.size.width,
    toolbarHeight);
  [toView addSubview: toLabel];

  // To text field
  toTextField = [UITextField new];
  toTextField.delegate = self;
  toTextField.font = toLabel.font;
  CGFloat toTextFieldOriginX = toLabel.frame.origin.x + 
    toLabel.frame.size.width + padding;
  toTextField.frame = CGRectMake(toTextFieldOriginX, toLabel.frame.origin.y, 
    toView.frame.size.width - (toTextFieldOriginX + padding), 
      toLabel.frame.size.height);
  toTextField.textColor = [UIColor blueDark];
  [toView addSubview: toTextField];

  // Bottom toolbar
  bottomToolbar = [[OMBMessageInputToolbar alloc] init];
  bottomToolbar.frame = CGRectMake(0.0f, 
    screen.size.height - (toolbarHeight + 216.0f), 
      screen.size.width, toolbarHeight);
  bottomToolbar.messageContentTextView.delegate = self;
  [self.view addSubview: bottomToolbar];

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(moveBottomToolbarUp:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(moveBottomToolbarDown:)
      name: UIKeyboardWillHideNotification object: nil];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [toTextField becomeFirstResponder];
}

#pragma mark - Protocol

#pragma mark - Protocol UITextViewDelegate

- (void) textViewDidChange: (UITextView *) textView
{
  UIFont *sendFont = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  if ([[textView.text stripWhiteSpace] length]) {
    [bottomToolbar.sendBarButtonItem setTitleTextAttributes: @{
      NSFontAttributeName: sendFont,
      NSForegroundColorAttributeName: [UIColor blueDark]
    } forState: UIControlStateNormal];
  }
  else {
    [bottomToolbar.sendBarButtonItem setTitleTextAttributes: @{
      NSFontAttributeName: sendFont,
      NSForegroundColorAttributeName: [UIColor grayMedium]
    } forState: UIControlStateNormal];
  }
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat lineHeight = 20.0f;
  CGFloat padding = 
    bottomToolbar.messageContentTextView.textContainerInset.left;
  CGRect rect = [textView.text boundingRectWithSize: 
    CGSizeMake(bottomToolbar.messageContentTextView.frame.size.width - 
      (padding * 2), 200.0f) font: bottomToolbar.messageContentTextView.font];
  CGRect textViewRect = bottomToolbar.messageContentTextView.frame;
  if (rect.size.height > lineHeight) {
    textViewRect.size.height = padding + rect.size.height + padding;
  }
  else {
    textViewRect.size.height = padding + lineHeight + padding;
  }
  bottomToolbar.messageContentTextView.frame = textViewRect;

  CGRect toolbarRect = bottomToolbar.frame;
  toolbarRect.size.height = 
    bottomToolbar.messageContentTextView.frame.size.height + (44.0f - 32.0f);
  toolbarRect.origin.y = screen.size.height - 
    (toolbarRect.size.height + 216.0f);
  bottomToolbar.frame = toolbarRect;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancel
{
  [self.navigationController dismissViewControllerAnimated: YES
    completion: nil];
}

- (void) moveBottomToolbarDown: (NSNotification *) notification
{
  NSTimeInterval duration = [[notification.userInfo objectForKey: 
    UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration: duration delay: 0.0f 
    options: UIViewAnimationOptionCurveEaseOut animations: 
    ^{
      CGRect screen = [[UIScreen mainScreen] bounds];
      CGRect rect = bottomToolbar.frame;
      rect.origin.y = screen.size.height - bottomToolbar.frame.size.height;
      bottomToolbar.frame = rect;
    } 
    completion: nil
  ];
}

- (void) moveBottomToolbarUp: (NSNotification *) notification
{
  NSTimeInterval duration = [[notification.userInfo objectForKey: 
    UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration: duration delay: 0.0f 
    options: UIViewAnimationOptionCurveEaseOut animations: 
    ^{
      CGRect screen = [[UIScreen mainScreen] bounds];
      CGRect rect = bottomToolbar.frame;
      rect.origin.y = screen.size.height - 
        (bottomToolbar.frame.size.height + 216.0f);
      bottomToolbar.frame = rect;
    } 
    completion: nil
  ];
}

@end
