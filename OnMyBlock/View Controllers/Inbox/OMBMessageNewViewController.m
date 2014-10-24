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
#import "OMBActivityView.h"
#import "OMBMessage.h"
#import "OMBMessageCollectionViewCell.h"
#import "OMBMessageCreateConnection.h"
#import "OMBMessageDetailCollectionViewFlowLayout.h"
#import "OMBMessageInputToolbar.h"
#import "OMBMessagesLastFetchedWithUserConnection.h"
#import "OMBResidence.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"

@interface OMBMessageNewViewController ()
{
	NSString *host;
}
@end

@implementation OMBMessageNewViewController

static NSString *CellIdentifier   = @"CellIdentifier";
static NSString *EmptyCellID      = @"EmptyCellID";
static NSString *FooterIdentifier = @"FooterIdentifier";
static NSString *HeaderIdentifier = @"HeaderIdentifier";

#pragma mark - Initializer

- (id) init
{
  return [self initWithUser: nil];
}

- (id) initWithUser: (OMBUser *) object
{
  return [self initWithUser: object residence: nil];
}

- (id) initWithUser: (OMBUser *) object residence: (OMBResidence *) res
{
  if (!(self = [super init])) return nil;

  residence = res;
  user      = object;
  
  self.currentPage = self.maxPages = 1;
  
  host = (user.firstName.length && [user.firstName caseInsensitiveCompare:
    @"Land"] != NSOrderedSame) ?
  [NSString stringWithFormat:@" %@",[user.firstName capitalizedString]] :
  @"";
  
  self.screenName = self.title = 
    [NSString stringWithFormat: @"Contact%@", host];

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

	//self.navigationItem.leftBarButtonItem =
	//[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
	//								target: self action:@selector(cancel)];
	
	// if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] ||
	// 	[[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"])
	// {	
	// }

  // Collection view
  _collection = [[UICollectionView alloc] initWithFrame:
    CGRectMake(screen.origin.x, 44.0f, screen.size.width, screen.size.height - (44.0f + 216.0f))
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
  
  callBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Call" 
    style: UIBarButtonItemStylePlain target: self action: @selector(call)];
  self.navigationItem.rightBarButtonItem = callBarButtonItem;
	
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

//  bottomToolbar.cameraBarButtonItem.action = @selector(addImage);
//  bottomToolbar.cameraBarButtonItem.target = self;
  bottomToolbar.sendBarButtonItem.action   = @selector(send);
  bottomToolbar.sendBarButtonItem.target   = self;

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(moveBottomToolbarUp:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(moveBottomToolbarDown:)
      name: UIKeyboardWillHideNotification object: nil];

  // Activty spinner
  activityView = [[OMBActivityView alloc] init];
  [self.view addSubview: activityView];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];
  
  if (user)
    [bottomToolbar.messageContentTextView becomeFirstResponder];
  else
    [toTextField becomeFirstResponder];
  
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];
  
  [timer invalidate];
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

  [_collection registerClass: [UICollectionReusableView class]
  forSupplementaryViewOfKind: UICollectionElementKindSectionFooter
         withReuseIdentifier: FooterIdentifier];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  if (user) {
    toTextField.text = [user fullName];
    toTextField.userInteractionEnabled = NO;
	bottomToolbar.messageContentTextView.text = [NSString stringWithFormat:@"Hi%@, I’m very interested in your place.  When would be a good time for me to visit to check it out?  Thank you!", host];
	[self textViewDidChange:bottomToolbar.messageContentTextView];
    //[bottomToolbar.messageContentTextView becomeFirstResponder];
  }
  //else
    //[toTextField becomeFirstResponder];

  if (user && user.phone && [user.phone length]) {
    callBarButtonItem.enabled = YES;
  }
  else {
    callBarButtonItem.enabled = NO;
  }
  
  timer = [NSTimer timerWithTimeInterval: 1 target: self
    selector: @selector(timerFireMethod:) userInfo: nil repeats: YES];
  [[NSRunLoop currentRunLoop] addTimer: timer forMode: NSRunLoopCommonModes];
  
  [self assignMessages];
  [_collection reloadData];
  [self scrollToBottomAnimatedViewWillAppear: NO];
  
  [self reloadTable];
}

#pragma mark - Protocol

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
  return [_messages count];
}

- (UICollectionReusableView *) collectionView:
(UICollectionView *) collectionView
            viewForSupplementaryElementOfKind: (NSString *) kind
                                  atIndexPath: (NSIndexPath *) indexPath
{

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
  
  OMBMessage *message = [self messageAtIndexPath: indexPath];
  
  CGRect screen    = [[UIScreen mainScreen] bounds];
  CGFloat padding  = [OMBMessageCollectionViewCell paddingForCell];
  
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

- (void) call
{
	NSString *phone = [@"telprompt://" stringByAppendingString:user.phone];
	NSURL *url = [NSURL URLWithString:phone];
	[[UIApplication sharedApplication] openURL:url];
}

- (void) cancel
{
  //[self.navigationController dismissViewControllerAnimated: YES
  //  completion: nil];
  [self.navigationController popViewControllerAnimated:YES];
}
- (OMBMessage *) messageAtIndexPath: (NSIndexPath *) indexPath
{
  // Account for the Load Earlier Messages cell
  // return [_messages objectAtIndex: indexPath.row - 1];
  return [_messages objectAtIndex: indexPath.row];
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

- (void) reloadTable
{
  BOOL firstTime = NO;
  
  if ([[[OMBUser currentUser] messagesWithUser: user] count] == 0)
    firstTime = YES;
  
  [[OMBUser currentUser] fetchMessagesAtPage: self.currentPage withUser: user
    delegate: self completion: ^(NSError *error) {
      [self assignMessages];
      [_collection reloadData];
      if (firstTime) {
        lastFetched = [[NSDate date] timeIntervalSince1970];
        [self scrollToBottomAnimated: NO];
      }
    }
   ];
}

- (void) scrollToBottomAnimated: (BOOL) animated
{
  CGFloat bottom =
  [_collection.collectionViewLayout collectionViewContentSize].height -
  _collection.frame.size.height;
  if (bottom < 0)
    bottom = 0;
  [_collection setContentOffset: CGPointMake(0.0f, bottom) animated: animated];
}

- (void) scrollToBottomAnimatedViewWillAppear: (BOOL) animated
{
  // Use this scroll method only when the view will appear
  CGFloat bottom =
  [_collection.collectionViewLayout collectionViewContentSize].height -
  _collection.frame.size.height;
  bottom += OMBPadding + bottomToolbar.frame.size.height;
  if (bottom < 0)
    bottom = 0;
  [_collection setContentOffset: CGPointMake(0.0f, bottom) animated: animated];
}

- (void) send
{
  // Use an activity view within the view controller if
  // view controller presented modally
  // [[self appDelegate].container startSpinning];

  OMBMessage *message = [[OMBMessage alloc] init];
  message.content   = bottomToolbar.messageContentTextView.text;
  message.createdAt = [[NSDate date] timeIntervalSince1970];
  message.user      = [OMBUser currentUser];
  message.uid       = 9999 + arc4random_uniform(100);
  message.updatedAt = [[NSDate date] timeIntervalSince1970];

  // #warning ASSOCIATE THIS MESSAGE'S CONVERSATION WITH A RESIDENCE
  // if (residence && residence.uid)
  //   message.residenceUID = residence.uid;
  
  // #warning ADD THIS MESSAGE TO A CONVERSATION?
  // [[OMBUser currentUser] addMessage: message];
  
  [self assignMessages];
  [_collection reloadData];
  
  bottomToolbar.hidden = YES;
  
  OMBMessageCreateConnection *conn =
    [[OMBMessageCreateConnection alloc] initWithMessage: message];
  conn.completionBlock = ^(NSError *error) {
    // [[self appDelegate].container stopSpinning];
    if (error) {
      //[cell removeFromSuperview];
      bottomToolbar.hidden = NO;
      [self showAlertViewWithError: error];
    }
    else {
      //[[OMBUser currentUser] addMessage: message];
      [self cancel];
    }
    [activityView stopSpinning];
  };
  [activityView startSpinning];
  [conn start];
}

- (void) timerFireMethod: (NSTimer *) timer
{
  // NSInteger currentCount = [_messages count];
  
  // if (!isFetching) {
  //   OMBMessagesLastFetchedWithUserConnection *conn =
  //   [[OMBMessagesLastFetchedWithUserConnection alloc] initWithLastFetched:
  //    lastFetched otherUser: user];
  //   conn.completionBlock = ^(NSError *error) {
  //     [self assignMessages];
      
  //     CGFloat newCount = [_messages count];
      
  //     if (currentCount != newCount) {
  //       [_collection reloadData];
  //       [self scrollToBottomAnimated: YES];
  //     }
      
  //     isFetching = NO;
  //     lastFetched = [[NSDate date] timeIntervalSince1970];
  //   };
  //   [conn start];
  // }
}

@end
