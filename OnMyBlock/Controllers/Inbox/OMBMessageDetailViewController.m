//
//  OMBMessageDetailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMessageDetailViewController.h"

#import "NSString+Extensions.h"
#import "NSUserDefaults+OnMyBlock.h"
#import "OMBActivityViewFullScreen.h"
#import "OMBConversation.h"
#import "OMBMessage.h"
#import "OMBMessageCollectionViewCell.h"
#import "OMBMessageDetailCollectionViewFlowLayout.h"
#import "OMBMessageInputToolbar.h"
#import "OMBMessagesLastFetchedWithUserConnection.h"
#import "OMBMessageStore.h"
#import "OMBOffer.h"
#import "OMBOtherUserProfileViewController.h"
#import "OMBResidence.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Resize.h"

@interface OMBMessageDetailViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITextViewDelegate>
{
  OMBActivityViewFullScreen *activityViewFullScreen;
  OMBMessageInputToolbar *bottomToolbar;
  UIBarButtonItem *contactBarButtonItem;
  OMBConversation *conversation;
  UIToolbar *contactToolbar;
  BOOL isEditing;
  BOOL isFetching;
  BOOL isFirstTime;
  NSTimeInterval lastFetched;
  UIBarButtonItem *phoneBarButtonItem;
  UIBarButtonItem *renterApplicationBarButtonItem;
  OMBResidence *residence;
  CGPoint startingPoint;
  NSTimer *timer;
  OMBUser *user;
}

@end

@implementation OMBMessageDetailViewController

static NSString *CellIdentifier   = @"CellIdentifier";
static NSString *EmptyCellID      = @"EmptyCellID";
static NSString *FooterIdentifier = @"FooterIdentifier";
static NSString *HeaderIdentifier = @"HeaderIdentifier";

#pragma mark - Initializer

- (id) initWithConversation: (OMBConversation *) object
{
  if (!(self = [super init])) return nil;

  conversation = object;
  isFirstTime  = YES;
  lastFetched  = [[NSDate date] timeIntervalSince1970];

  self.currentPage = self.maxPages = 1;
  self.fetching    = NO;

  self.title = conversation.nameOfConversation;

  return self;
}

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;

  self.currentPage = self.maxPages = 1;
  self.fetching    = NO;

  self.title = [residence.address capitalizedString];

  return self;
}

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user = object;

  self.currentPage = self.maxPages = 1;
  self.fetching    = NO;

  self.title = [user fullName];

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
  _collection = [[UICollectionView alloc] initWithFrame: screen
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
  renterApplicationBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Profile"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(showRenterProfile)];
  // Spacing
  UIBarButtonItem *flexibleSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
  // Phone
  UIImage *phoneIcon = [UIImage image: [UIImage imageNamed: @"phone_icon.png"]
    size: CGSizeMake(22.0f, 22.0f)];
  phoneBarButtonItem =
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
  contactToolbar.tintColor = [UIColor blue];
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

  // bottomToolbar.cameraBarButtonItem.action = @selector(addImage);
  // bottomToolbar.cameraBarButtonItem.target = self;
  bottomToolbar.sendBarButtonItem.action  = @selector(send);
  bottomToolbar.sendBarButtonItem.enabled = NO;
  bottomToolbar.sendBarButtonItem.target  = self;

  activityViewFullScreen = [[OMBActivityViewFullScreen alloc] init];
  [self.view addSubview: activityViewFullScreen];
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
    forCellWithReuseIdentifier: EmptyCellID];

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

  [timer invalidate];

  // scrollViewDidScroll will send to this zombie if you don't do this
  self.collection.delegate = nil;
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  if (!self.collection.delegate)
    self.collection.delegate = self;

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillShow:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillHide:)
      name: UIKeyboardWillHideNotification object: nil];

  [self verifyPhone];

  if (conversation) {
    [self assignMessages];
    if (isFirstTime && [self.messages count]) {
      [self scrollToBottomAnimated: NO
        additionalOffsetY: OMBPadding + OMBStandardHeight];
    }
    [self fetchMessagesWithCompletion: nil];
  }
  // If there is no conversation, fetch one
  else {
    conversation = [[OMBConversation alloc] init];
    void (^completion) (NSError * error) = ^void (NSError *error) {
      [self verifyPhone];
      [self fetchMessagesWithCompletion: nil];
      [activityViewFullScreen stopSpinning];
      [bottomToolbar.messageContentTextView becomeFirstResponder];
    };
    if (residence) {
      [conversation fetchConversationWithResidenceUID: residence.uid completion:
        completion
      ];
      renterApplicationBarButtonItem.enabled = NO;
    }
    else if (user) {
      [conversation fetchConversationWithUserUID: user.uid completion:
        completion
      ];
    }
    [activityViewFullScreen startSpinning];
  }
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];

  [bottomToolbar.messageContentTextView resignFirstResponder];

  [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  [conversation readFromMessagesDictionary: dictionary];
}

- (void) numberOfPages: (NSUInteger) pages
{
  self.maxPages = pages;
}

#pragma mark - UIAlertViewDelegate Protocol

- (void) alertView: (UIAlertView *) alertView
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  if (buttonIndex == 0) {
    [[self userDefaults] permissionPushNotificationsSet: NO];
  }
  else if (buttonIndex == 1) {
    [[self userDefaults] permissionPushNotificationsSet: YES];
    [[self appDelegate] registerForPushNotifications];
  }
}

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

  // Last row, empty row
  // if (indexPath.row == [_messages count]) {
  //   UICollectionViewCell *emptyCell =
  //     [collectionView dequeueReusableCellWithReuseIdentifier:
  //       EmptyCellID forIndexPath: indexPath];
  //   emptyCell.backgroundColor = [UIColor redColor];
  //   return emptyCell;
  // }

  OMBMessageCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier: CellIdentifier
      forIndexPath: indexPath];
  OMBMessage *message = [self messageAtIndexPath: indexPath];
  [cell loadMessageData: message];

  // Minus 1, account for the last empty row
  if (indexPath.row !=
    [collectionView numberOfItemsInSection: indexPath.section] - 1) {
    OMBMessage *nextMessage = [self messageAtIndexPath:
      [NSIndexPath indexPathForRow: indexPath.row + 1
        inSection: indexPath.section]];
    // If the next message is from another user
    if (![message isFromUser: nextMessage.user]) {
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

  // Empty cell at the end
  return [self.messages count];
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
  // Returning some size makes it so that the 1st message doesn't show up
  // when sending it
  // return CGSizeZero;

  CGFloat height = 0.0f;
  if (isEditing && [_messages count] > 1)
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
  return UIEdgeInsetsMake(OMBPadding, 0.0f,
    bottomToolbar.frame.size.height, 0.0f);
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
  // Last row, empty row
  // if (indexPath.row == [_messages count]) {
  //   CGFloat height = 0.0f;
  //   if (isEditing)
  //     height = OMBKeyboardHeight;
  //   return CGSizeMake(collectionView.frame.size.width, height);
  // }

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

  CGRect screen   = [[UIScreen mainScreen] bounds];
  CGFloat padding = [OMBMessageCollectionViewCell paddingForCell];
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
  // Minus 1, account for the last empty row
  if (indexPath.row !=
    [collectionView numberOfItemsInSection: indexPath.section] - 1) {
    OMBMessage *nextMessage = [self messageAtIndexPath:
      [NSIndexPath indexPathForRow: indexPath.row + 1
        inSection: indexPath.section]];
    // If 2 consecutive messages are from the same person
    if ([message isFromUser: nextMessage.user]) {
      // If 2 consecutive messages are within 60 seconds of each other
      if (nextMessage.createdAt - message.createdAt <= 60) {
        spacing = spacing * 0.5;
      }
    }
  }
  // NSLog(@"%f", rect.size.height);
  return CGSizeMake(screen.size.width,
    padding + rect.size.height + padding + (padding * 0.5) + spacing);
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  // if (scrollView.contentOffset.y + 216.0f < startingPoint.y) {
  //   [self.view endEditing: YES];
  //   startingPoint = scrollView.contentOffset;
  // }
}

- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
  // startingPoint = scrollView.contentOffset;
}

#pragma mark - Protocol UITextViewDelegate

- (void) textViewDidChange: (UITextView *) textView
{
  UIFont *sendFont = [UIFont normalTextFontBold];
  if ([[textView.text stripWhiteSpace] length]) {
    [bottomToolbar.sendBarButtonItem setTitleTextAttributes: @{
      NSFontAttributeName: sendFont,
      NSForegroundColorAttributeName: [UIColor blueDark]
    } forState: UIControlStateNormal];
    bottomToolbar.sendBarButtonItem.enabled = YES;
  }
  else {
    bottomToolbar.sendBarButtonItem.enabled = NO;
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
  self.messages = [conversation sortedMessagesWithKey: @"createdAt"
    ascending: YES];
  [self.collection reloadData];
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

- (void) fetchMessagesWithCompletion: (void (^) (NSError *err)) block
{
  [conversation fetchMessagesAtPage: self.currentPage delegate: self
    completion: ^(NSError *error) {
      [self assignMessages];
      if (isFirstTime) {
        isFirstTime = NO;
        [self scrollToBottomAnimated: NO];
        [self startTimer];
      }
      if (block)
        block(error);
    }
  ];
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

- (void) loadDefaultMessage
{
  bottomToolbar.messageContentTextView.text =
    @"Hi, I’m very interested in your place. "
    @"When would be a good time for me to visit to check it out? Thank you!";
  [self textViewDidChange: bottomToolbar.messageContentTextView];
  [bottomToolbar.messageContentTextView becomeFirstResponder];
}

- (void) loadEarlierMessages
{
  // NEED TO FIGURE OUT HOW TO MAKE A HEADER SUPPLEMENTARY VIEW
  // THAT DOESN'T DISAPPEAR, SO WE CAN LOAD EARLIER MESSAGES
  if (_currentPage < _maxPages) {
    _currentPage += 1;
    [self fetchMessagesWithCompletion: nil];
  }
}

- (OMBMessage *) messageAtIndexPath: (NSIndexPath *) indexPath
{
  // Account for the Load Earlier Messages cell
  // return [_messages objectAtIndex: indexPath.row - 1];
  return [self.messages objectAtIndex: indexPath.row];
}

- (OMBUser *) otherUser
{
  OMBUser *object;
  if (conversation && conversation.otherUser) {
    object = conversation.otherUser;
  }
  else if (residence && residence.user) {
    object = residence.user;
  }
  else if (user) {
    object = user;
  }
  NSLog(@"%@", conversation);
  NSLog(@"%@", residence);
  NSLog(@"%@", user);
  return object;
}

- (void) phoneCallUser
{
  if ([self otherUser]) {
    NSString *string = [@"telprompt:" stringByAppendingString:
      [residence phone]];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: string]];
  }
}

- (void) scrollToBottomAnimated: (BOOL) animated
{
  [self scrollToBottomAnimated: animated additionalOffsetY: 0.0f];
}

- (void) scrollToBottomAnimated: (BOOL) animated
additionalOffsetY: (CGFloat) offsetY
{
  CGFloat contentSizeHeight =
    [self.collection.collectionViewLayout collectionViewContentSize].height;
  CGFloat frameSizeHeight = self.collection.frame.size.height;
  frameSizeHeight -= offsetY;
  CGFloat bottom = contentSizeHeight - frameSizeHeight;

  // NSLog(@"Content Size Height: %f", contentSizeHeight);
  // NSLog(@"Frame Size Height: %f", frameSizeHeight);
  // NSLog(@"Bottom: %f", bottom);

  if (bottom > 0)
    [self.collection setContentOffset: CGPointMake(0.0f, bottom)
      animated: animated];
}

- (void) send
{
  OMBMessage *message = [[OMBMessage alloc] init];
  [message createMessageWithContent: bottomToolbar.messageContentTextView.text
    forConversation: conversation];
  [conversation addMessage: message];
  [self assignMessages];
  // Create the message
  [message createMessageConnectionWithConversation: conversation];

  // When there is only one message, it doesn't show
  // Only after you come back to this view does it show
  // Don't know why...

  if ([self.collection.collectionViewLayout collectionViewContentSize].height >
    self.collection.frame.size.height + bottomToolbar.frame.size.height) {
    [self scrollToBottomAnimated: YES];
  }

  // Clear the text field
  bottomToolbar.messageContentTextView.text = @"";
  [self textViewDidChange: bottomToolbar.messageContentTextView];

  // Ask to register for push notifications
  if (![[self userDefaults] permissionPushNotifications]) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
      @"Message Notifications" message: @"Would you like to be notified "
      @"as soon as you receive a response to your message?"
        delegate: self cancelButtonTitle: @"Not now"
          otherButtonTitles: @"Yes", nil];
    [alertView show];
  }
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

- (void) showRenterProfile
{
  OMBUser *otherUser = [self otherUser];
  if (otherUser) {
    OMBOtherUserProfileViewController *vc =
      [[OMBOtherUserProfileViewController alloc] initWithUser: otherUser];
    [self.navigationController pushViewController: vc animated: YES];
  }
}

- (void) startTimer
{
  timer = [NSTimer timerWithTimeInterval: 1 target: self
    selector: @selector(timerFireMethod:) userInfo: nil repeats: YES];
  // NSRunLoopCommonModes, mode used for tracking events
  [[NSRunLoop currentRunLoop] addTimer: timer forMode: NSRunLoopCommonModes];
}

- (void) timerFireMethod: (NSTimer *) timer
{
  NSInteger currentCount = [_messages count];

  if (!isFetching) {
    [conversation fetchMessagesWithTimeInterval: lastFetched delegate: self
      completion: ^(NSError *error) {
        [self assignMessages];
        if (currentCount != [self.messages count])
          [self scrollToBottomAnimated: YES];
        isFetching  = NO;
        lastFetched = [[NSDate date] timeIntervalSince1970];
      }
    ];
  }
}

- (void) verifyPhone
{
  BOOL hasPhone = NO;
  if ([self otherUser] && [[[self otherUser] phoneString] length]) {
    hasPhone = YES;
  }
  else if (residence && [residence.phone length]) {
    hasPhone = YES;
  }
  phoneBarButtonItem.enabled = hasPhone;
}

@end
