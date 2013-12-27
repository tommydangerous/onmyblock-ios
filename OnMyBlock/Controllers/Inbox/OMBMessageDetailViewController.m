//
//  OMBMessageDetailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMessageDetailViewController.h"

#import "NSString+Extensions.h"
#import "OMBMessage.h"
#import "OMBMessageCollectionViewCell.h"
#import "OMBMessageDetailCollectionViewFlowLayout.h"
#import "OMBMessageInputToolbar.h"
#import "OMBMessageStore.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBMessageDetailViewController

static NSString *CellIdentifier = @"CellIdentifier";

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user     = object;
  messages = [[OMBMessageStore sharedStore] sortedMessagesForUserUID: user.uid];

  self.screenName = @"Message Detail";

  self.title = [user fullName];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view = [[UIView alloc] initWithFrame: screen];

  CGFloat toolbarHeight = 44.0f;

  // Collection view
  _collection = [[UICollectionView alloc] initWithFrame: CGRectMake(0.0f, 0.0f,
    screen.size.width, screen.size.height - toolbarHeight)
      collectionViewLayout: 
        [[OMBMessageDetailCollectionViewFlowLayout alloc] init]];
  _collection.alwaysBounceVertical = YES;
  _collection.clipsToBounds = NO;
  UIView *backgroundView = [[UIView alloc] initWithFrame: _collection.frame];
  backgroundView.backgroundColor = [UIColor backgroundColor];
  _collection.backgroundView = backgroundView;
  _collection.dataSource = self;
  _collection.delegate = self;
  [self.view addSubview: _collection];

  contactBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Contact"
    style: UIBarButtonItemStylePlain target: self 
      action: @selector(showContactMore)];
  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
    style: UIBarButtonItemStylePlain target: self 
      action: @selector(done)];
  self.navigationItem.rightBarButtonItem = contactBarButtonItem;

  // Left padding
  UIBarButtonItem *leftPadding = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemFixedSpace target: nil action: nil];
  // iOS 7 toolbar spacing is 16px; 20px on iPad
  leftPadding.width = 4.0f;
  // Renter application
  UIBarButtonItem *renterApplicationBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Renter Application" 
      style: UIBarButtonItemStylePlain target: self
        action: @selector(showRenterApplication)];
  // Spacing
  UIBarButtonItem *flexibleSpace = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: 
      UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
  // Phone
  UIImage *phoneIcon = [UIImage image: [UIImage imageNamed: @"phone_icon.png"]
    size: CGSizeMake(22.0f, 22.0f)];
  UIBarButtonItem *phoneBarButtonItem = 
    [[UIBarButtonItem alloc] initWithImage: phoneIcon style:
      UIBarButtonItemStylePlain target: self action: @selector(phoneCallUser)];
  // Right padding
  UIBarButtonItem *rightPadding = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemFixedSpace target: nil action: nil];
  // iOS 7 toolbar spacing is 16px; 20px on iPad
  rightPadding.width = 4.0f;

  contactToolbar = [UIToolbar new];
  contactToolbar.clipsToBounds = YES;
  contactToolbar.frame = CGRectMake(0.0f, 20.0f, 
    screen.size.width, toolbarHeight);
  contactToolbar.hidden = YES;
  contactToolbar.items = @[leftPadding, renterApplicationBarButtonItem, 
    flexibleSpace, phoneBarButtonItem, rightPadding];
  contactToolbar.tintColor = [UIColor blueDark];
  [self.view addSubview: contactToolbar];
  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.backgroundColor = [UIColor grayLight].CGColor;
  bottomBorder.frame = CGRectMake(0.0f, contactToolbar.frame.size.height - 1.0f,
    contactToolbar.frame.size.width, 1.0f);
  [contactToolbar.layer addSublayer: bottomBorder];

  // Bottom toolbar
  bottomToolbar = [[OMBMessageInputToolbar alloc] init];
  bottomToolbar.frame = CGRectMake(contactToolbar.frame.origin.x,
    screen.size.height - toolbarHeight, contactToolbar.frame.size.width,
      toolbarHeight);
  bottomToolbar.messageContentTextView.delegate = self;
  [self.view addSubview: bottomToolbar];

  bottomToolbar.cameraBarButtonItem.action = @selector(addImage);
  bottomToolbar.sendBarButtonItem.action   = @selector(send);

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(moveBottomToolbarUp:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(moveBottomToolbarDown:)
      name: UIKeyboardWillHideNotification object: nil];
}

- (void) viewDidLoad
{
  [super viewDidLoad];

  // Before the collection view dequeues a cell, you must tell the collection 
  // view how to create the corresponding view if one does not already exist
  // Register a class for use in creating new collection view cells
  [_collection registerClass: [OMBMessageCollectionViewCell class]
    forCellWithReuseIdentifier: CellIdentifier];
}

#pragma mark - Protocol

#pragma mark - Protocol UICollectionViewDataSource

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView 
cellForItemAtIndexPath: (NSIndexPath *) indexPath
{
  OMBMessageCollectionViewCell *cell = 
    [collectionView dequeueReusableCellWithReuseIdentifier: CellIdentifier 
      forIndexPath: indexPath];
  OMBMessage *message = [self messageAtIndexPath: indexPath];
  [cell loadMessageData: message];
  
  if (indexPath.row != 
    [collectionView numberOfItemsInSection: indexPath.section] - 1) {
    OMBMessage *nextMessage = [self messageAtIndexPath: 
      [NSIndexPath indexPathForRow: indexPath.row + 1 
        inSection: indexPath.section]];
    // If the next message is from another user
    if (message.sender.uid != nextMessage.sender.uid) {
      // Add the arrow on the speech bubble
      [cell setupForLastMessageFromSameUser];
    }
  }
  else {
    [cell setupForLastMessageFromSameUser];
  }

  return cell;
}

- (NSInteger) collectionView: (UICollectionView *) collectionView 
numberOfItemsInSection: (NSInteger) section
{
  return [messages count];
}

- (NSInteger) numberOfSectionsInCollectionView: 
(UICollectionView *) collectionView
{
  return 1;
}

#pragma mark - Protocol UICollectionViewDelegateFlowLayout

- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
insetForSectionAtIndex: (NSInteger) section
{
  // The margins used to lay out content in a section
  // return UIEdgeInsetsMake(30.0f, 10.0f, 10.0f, 10.0f);
  return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGFloat) collectionView: (UICollectionView *) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
minimumInteritemSpacingForSectionAtIndex: (NSInteger) section
{
  // The minimum spacing to use between items in the same row
  return 0.0f;
}

- (CGFloat) collectionView: (UICollectionView *) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
minimumLineSpacingForSectionAtIndex: (NSInteger) section
{
  // The minimum spacing to use between lines of items in the grid
  // return [OMBMessageCollectionViewCell paddingForCell];
  return 0.0f;
}

- (CGSize) collectionView: (UICollectionView * ) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
sizeForItemAtIndexPath: (NSIndexPath *) indexPath
{
  OMBMessage *message = [self messageAtIndexPath: indexPath];
  // NSAttributedString *aString = [message.content attributedStringWithFont:
  //   [UIFont fontWithName: @"HelveticaNeue-Light" size: 15] 
  //     lineHeight: 22.0f];

  CGRect screen    = [[UIScreen mainScreen] bounds];
  CGFloat padding  = [OMBMessageCollectionViewCell paddingForCell];
  // CGFloat maxWidth = 
  //   [OMBMessageCollectionViewCell maxWidthForMessageContentView];

  // THIS IS SLOWING IT DOWN TREMENDOUSLY
  // CGRect rect = [aString boundingRectWithSize:
  //   CGSizeMake(maxWidth - (padding * 4), 9999)
  //     options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  CGRect rect = CGRectMake(0.0f, 0.0f, message.sizeForMessageCell.width,
    message.sizeForMessageCell.height);

  CGFloat spacing = padding;
  if (indexPath.row != 
    [collectionView numberOfItemsInSection: indexPath.section] - 1) {
    OMBMessage *nextMessage = [self messageAtIndexPath: 
      [NSIndexPath indexPathForRow: indexPath.row + 1 
        inSection: indexPath.section]];
    // If 2 consecutive messages are from the same person
    if (message.sender.uid == nextMessage.sender.uid) {
      // If 2 consecutive messages are within 60 seconds of each other
      if (nextMessage.createdAt - message.createdAt <= 60) {
        spacing = spacing * 0.5;
      }
    }
  }

  return CGSizeMake(screen.size.width, 
    padding + rect.size.height + padding + (padding * 0.5) + spacing);
}

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

- (void) addImage
{
  NSLog(@"ADD IMAGE");
}

- (void) done
{
  [self.navigationItem setRightBarButtonItem: contactBarButtonItem 
    animated: YES];
  [UIView animateWithDuration: 0.15 animations: ^{
    CGRect rect = contactToolbar.frame;
    rect.origin.y = 20.0f;
    contactToolbar.frame = rect;
  } completion: ^(BOOL finished) {
    contactToolbar.hidden = YES;
  }];
}

- (OMBMessage *) messageAtIndexPath: (NSIndexPath *) indexPath
{
  return [messages objectAtIndex: indexPath.row];
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

- (void) phoneCallUser
{
  NSLog(@"PHONE CALL USER");
}

- (void) send
{
  NSLog(@"SEND");
}

- (void) showContactMore
{
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem animated: YES];
  contactToolbar.hidden = NO;
  [UIView animateWithDuration: 0.15 animations: ^{
    CGRect rect = contactToolbar.frame;
    rect.origin.y = 20.0f + 44.0f;
    contactToolbar.frame = rect;
  }];
}

- (void) showRenterApplication
{
  NSLog(@"SHOW RENTER APPLICATION");
}

@end
