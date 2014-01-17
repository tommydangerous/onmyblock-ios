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
#import "OMBMessageCreateConnection.h"
#import "OMBMessageDetailCollectionViewFlowLayout.h"
#import "OMBMessageInputToolbar.h"
#import "OMBMessageStore.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBMessageDetailViewController

static NSString *CellIdentifier   = @"CellIdentifier";
static NSString *FooterIdentifier = @"FooterIdentifier";
static NSString *HeaderIdentifier = @"HeaderIdentifier";

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user = object;

  _currentPage = _maxPages = 1;
  _fetching    = NO;

  self.screenName  = @"Message Detail";
  self.title       = [user fullName];

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillShow:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillHide:)
      name: UIKeyboardWillHideNotification object: nil];

  return self;
}

- (void) dealloc
{
  // Must dealloc or notifications get sent to zombies
  [[NSNotificationCenter defaultCenter] removeObserver: self];
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
    [[UIBarButtonItem alloc] initWithTitle: @"" // @"Renter Application" 
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
  bottomToolbar.cameraBarButtonItem.target = self;
  bottomToolbar.sendBarButtonItem.action   = @selector(send);
  bottomToolbar.sendBarButtonItem.target   = self;
}

- (void) viewDidLoad
{
  [super viewDidLoad];

  // Before the collection view dequeues a cell, you must tell the collection 
  // view how to create the corresponding view if one does not already exist
  // Register a class for use in creating new collection view cells
  [_collection registerClass: [OMBMessageCollectionViewCell class]
    forCellWithReuseIdentifier: CellIdentifier];

  [_collection registerClass: [UICollectionViewCell class]
    forCellWithReuseIdentifier: HeaderIdentifier];

  // [_collection registerClass: [UICollectionReusableView class]
  //   forSupplementaryViewOfKind: UICollectionElementKindSectionHeader 
  //     withReuseIdentifier: HeaderIdentifier];

  [_collection registerClass: [UICollectionReusableView class]
    forSupplementaryViewOfKind: UICollectionElementKindSectionFooter 
      withReuseIdentifier: FooterIdentifier];
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];

  // _collection.dataSource = nil;
  // _collection.delegate = nil;
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [self assignMessages];
  [_collection reloadData];
  [self scrollToBottomAnimated: NO];

  [self reloadTable];
}

#pragma mark - Protocol

#pragma mark - Protocol UICollectionViewDataSource

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView 
cellForItemAtIndexPath: (NSIndexPath *) indexPath
{
  // if (indexPath.row == 0) {
  //   UICollectionViewCell *cell = 
  //     [collectionView dequeueReusableCellWithReuseIdentifier: 
  //       HeaderIdentifier 
  //       forIndexPath: indexPath];
  //   UILabel *label = (UILabel *) [cell viewWithTag: 9999];
  //   if (!label) {
  //     label = [[UILabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f,
  //       collectionView.frame.size.width, 58.0f)];
  //     label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  //     label.tag  = 9999;
  //     label.text = @"Load Earlier Messages";
  //     label.textAlignment = NSTextAlignmentCenter;
  //     label.textColor = [UIColor blue];
  //     [cell addSubview: label];
  //   }
  //   return cell;
  // }
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
  // Load Earlier Messages
  // return 1 + [_messages count];
  return [_messages count];
}

- (UICollectionReusableView *) collectionView: 
(UICollectionView *) collectionView 
viewForSupplementaryElementOfKind: (NSString *) kind 
atIndexPath: (NSIndexPath *) indexPath
{
  // UICollectionReusableView *reusableView = 
  //   [collectionView dequeueReusableSupplementaryViewOfKind:
  //     UICollectionElementKindSectionHeader 
  //     withReuseIdentifier: HeaderIdentifier forIndexPath: indexPath];

  // if (!reusableView) {
  //   reusableView = [[UICollectionReusableView alloc] initWithFrame:
  //     CGRectMake(0.0f, 0.0f, collectionView.frame.size.width, 44.0f)];
  // }
  // reusableView.backgroundColor = [UIColor redColor];
  // UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f,
  //   reusableView.frame.size.width, reusableView.frame.size.height)];
  // label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  // label.tag  = 9999;
  // label.text = @"Load Earlier Messages";
  // label.textAlignment = NSTextAlignmentCenter;
  // label.textColor = [UIColor blue];
  // [reusableView addSubview: label];
  // return reusableView;
  if ([kind isEqualToString: UICollectionElementKindSectionFooter]) {
    UICollectionReusableView *reusableView = 
      [collectionView dequeueReusableSupplementaryViewOfKind: kind 
        withReuseIdentifier: FooterIdentifier forIndexPath: indexPath];
    if (!reusableView) {
      reusableView = [[UICollectionReusableView alloc] initWithFrame:
        CGRectMake(0.0f, 0.0f, collectionView.frame.size.width, 216.0f)];
    }
    return reusableView;
  }
  return nil;
}

- (NSInteger) numberOfSectionsInCollectionView: 
(UICollectionView *) collectionView
{
  return 1;
}

#pragma mark - Protocol UICollectionViewDelegate

- (void) collectionView: (UICollectionView *) collectionView 
didSelectItemAtIndexPath: (NSIndexPath *) indexPath
{
  // Load Earlier Messages
  // if (indexPath.row == 0) {
  //   [self loadEarlierMessages];
  // }
}

#pragma mark - Protocol UICollectionViewDelegateFlowLayout

- (CGSize) collectionView: (UICollectionView *) collectionView 
layout: (UICollectionViewLayout *) collectionViewLayout 
referenceSizeForFooterInSection: (NSInteger) section
{
  CGFloat height = 0.0f;
  if (isEditing)
    height = 216.0f;
  return CGSizeMake(collectionView.frame.size.width, height);
}

// - (CGSize) collectionView: (UICollectionView *) collectionView 
// layout: (UICollectionViewLayout *) collectionViewLayout 
// referenceSizeForHeaderInSection: (NSInteger) section
// {
//   return CGSizeMake(collectionView.frame.size.width, 44.0f);
// }

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
  // Load Earlier Messages
  // if (indexPath.row == 0) {
  //   CGFloat height = 58.0f;
  //   if (_currentPage == _maxPages)
  //     height = 0.0f;
  //   return CGSizeMake(collectionView.frame.size.width, height);
  // }
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
  if (message.sizeForMessageCell.width == 0.0f &&
    message.sizeForMessageCell.height == 0.0f) {
    [message calculateSizeForMessageCell];
  }
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

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  if (scrollView.contentOffset.y + 216.0f < startingPoint.y) {
    [self.view endEditing: YES];
    startingPoint = scrollView.contentOffset;
  }
}

- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
  startingPoint = scrollView.contentOffset;
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

- (void) assignMessages
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: 
    @"createdAt" ascending: YES];
  _messages = [[[OMBUser currentUser] messagesWithUser: 
    user] sortedArrayUsingDescriptors: @[sort]];
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

- (void) keyboardWillHide: (NSNotification *) notification
{
  NSTimeInterval duration = [[notification.userInfo objectForKey: 
    UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration: duration delay: 0.0f 
    options: UIViewAnimationOptionCurveEaseOut animations: ^{
      CGRect screen = [[UIScreen mainScreen] bounds];
      CGRect rect = bottomToolbar.frame;
      rect.origin.y = screen.size.height - bottomToolbar.frame.size.height;
      bottomToolbar.frame = rect;
    } 
    completion: nil
  ];

  isEditing = NO;
  [_collection reloadData];
}

- (void) keyboardWillShow: (NSNotification *) notification
{
  NSTimeInterval duration = [[notification.userInfo objectForKey: 
    UIKeyboardAnimationDurationUserInfoKey] doubleValue];

  [UIView animateWithDuration: duration delay: 0.0f 
    options: UIViewAnimationOptionCurveEaseOut animations: ^{
      CGRect screen = [[UIScreen mainScreen] bounds];
      CGRect rect = bottomToolbar.frame;
      rect.origin.y = screen.size.height - 
        (bottomToolbar.frame.size.height + 216.0f);
      bottomToolbar.frame = rect;
    } 
    completion: nil
  ];

  isEditing = YES;
  [_collection reloadData];

  if ([_collection.collectionViewLayout collectionViewContentSize].height >
    _collection.frame.size.height) {

    CGPoint contentOffset = _collection.contentOffset;
    contentOffset.y += 216.0f;
    [_collection setContentOffset: contentOffset animated: YES];
  }
}

- (void) loadEarlierMessages
{
  // NEED TO FIGURE OUT HOW TO MAKE A HEADER SUPPLEMENTARY VIEW
  // THAT DOESN'T DISAPPEAR, SO WE CAN LOAD EARLIER MESSAGES
  if (_currentPage < _maxPages) {
    _currentPage += 1;
    [self reloadTable];
  }
}

- (OMBMessage *) messageAtIndexPath: (NSIndexPath *) indexPath
{
  // Account for the Load Earlier Messages cell
  // return [_messages objectAtIndex: indexPath.row - 1];
  return [_messages objectAtIndex: indexPath.row];
}

- (void) phoneCallUser
{
  NSString *string = [@"telprompt:" stringByAppendingString: user.phone];
  [[UIApplication sharedApplication] openURL: [NSURL URLWithString: string]];
}

- (void) reloadTable
{
  BOOL firstTime = NO;
  // if ([_messages count] == 0)
  //   firstTime = YES;
  if ([[[OMBUser currentUser] messagesWithUser: user] count] == 0)
    firstTime = YES;

  [[OMBUser currentUser] fetchMessagesAtPage: _currentPage withUser: user
    delegate: self completion: ^(NSError *error) {
      [self assignMessages];
      [_collection reloadData];
      if (firstTime) {
        [self scrollToBottomAnimated: NO];
      }
    }
  ];
}

- (void) scrollToBottomAnimated: (BOOL) animated
{
  CGFloat bottom = 
    [_collection.collectionViewLayout collectionViewContentSize].height
      - (_collection.frame.size.height - 
        (bottomToolbar.frame.size.height + 20.0f));
  if (isEditing)
    bottom -= bottomToolbar.frame.size.height + 20.0f;
  if (bottom < 0)
    bottom = 0;
  [_collection setContentOffset: CGPointMake(0.0f, bottom) animated: animated];
}

- (void) send
{
  OMBMessage *message = [[OMBMessage alloc] init];
  message.content   = bottomToolbar.messageContentTextView.text;
  message.createdAt = [[NSDate date] timeIntervalSince1970];
  message.recipient = user;
  message.sender    = [OMBUser currentUser];
  message.uid       = 9999 + arc4random_uniform(100);
  message.updatedAt = [[NSDate date] timeIntervalSince1970];
  [[OMBUser currentUser] addMessage: message];

  [self assignMessages];
  [_collection reloadData];

  // When there is only one message, it doesn't show
  // Only after you come back to this view does it show
  // Don't know why...

  if ([_collection.collectionViewLayout collectionViewContentSize].height >
    _collection.frame.size.height) {
    
    [self scrollToBottomAnimated: YES];
  }

  bottomToolbar.messageContentTextView.text = @"";
  [self textViewDidChange: bottomToolbar.messageContentTextView];

  [[[OMBMessageCreateConnection alloc] initWithMessage: message] start];
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
