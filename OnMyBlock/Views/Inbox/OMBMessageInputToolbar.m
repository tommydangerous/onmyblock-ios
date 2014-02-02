//
//  OMBMessageInputToolbar.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMessageInputToolbar.h"

#import "NSString+Extensions.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBMessageInputToolbar

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];

  // Left padding negative
  UIBarButtonItem *leftPaddingNegative = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemFixedSpace target: nil action: nil];
  // iOS 7 toolbar spacing is 16px; 20px on iPad
  leftPaddingNegative.width = -6.0f; // final width = 10

//  // Camera
//  UIImage *cameraIcon = [UIImage image: [UIImage imageNamed: @"camera_icon.png"]
//    size: CGSizeMake(26.0f, 26.0f)];
//  _cameraBarButtonItem = 
//    [[UIBarButtonItem alloc] initWithImage: cameraIcon style:
//      UIBarButtonItemStylePlain target: nil action: nil];

  // Text view
  _messageContentTextView = [[UITextView alloc] init];
  _messageContentTextView.backgroundColor = [UIColor whiteColor];
  _messageContentTextView.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  _messageContentTextView.layer.borderColor = [UIColor grayLight].CGColor;
  _messageContentTextView.layer.borderWidth = 1.0f;
  _messageContentTextView.layer.cornerRadius = 5.0f;
  _messageContentTextView.showsVerticalScrollIndicator = NO;
  _messageContentTextView.textColor = [UIColor textColor];
  _messageContentTextView.textContainer.lineFragmentPadding = 0;
  _messageContentTextView.textContainerInset = UIEdgeInsetsMake(6, 6, 6, 6);
  UIBarButtonItem *messageContentBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView: _messageContentTextView];

  // Send
  UIFont *sendFont = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  _sendBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Send" 
      style: UIBarButtonItemStylePlain target: nil action: nil];
  [_sendBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: sendFont,
    NSForegroundColorAttributeName: [UIColor grayMedium]
  } forState: UIControlStateNormal];

  // Right padding negative
  UIBarButtonItem *rightPaddingNegative = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemFixedSpace target: nil action: nil];
  // iOS 7 toolbar spacing is 16px; 20px on iPad
  rightPaddingNegative.width = -6.0f; // final width = 10

  // Set the frame for the message context text field
  CGRect sendRect = [_sendBarButtonItem.title boundingRectWithSize:
    CGSizeMake(screen.size.width, 44.0f) font: sendFont];
  _messageContentTextView.frame = CGRectMake(0.0f, 0.0f, screen.size.width - 
    ( 10 + 10 + sendRect.size.width + 10), 6 + 20.0f + 6);

  self.items = @[
    leftPaddingNegative,
//    _cameraBarButtonItem,
    messageContentBarButtonItem,
    _sendBarButtonItem,
    rightPaddingNegative
  ];
  self.tintColor = [UIColor grayMedium];

  return self;
}

@end
