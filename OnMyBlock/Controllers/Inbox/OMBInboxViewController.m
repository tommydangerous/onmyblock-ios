//
//  OMBInboxViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBInboxViewController.h"

#import "OMBConversationMessageStore.h"
#import "OMBEmptyBackgroundWithImageAndLabel.h"
#import "OMBInboxCell.h"
#import "OMBMessage.h"
#import "OMBMessageDetailViewController.h"
#import "OMBMessageNewViewController.h"
#import "OMBNavigationController.h"
#import "UIColor+Extensions.h"

@implementation OMBInboxViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Inbox";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setupForTable];

  // [self.table removeFromSuperview];

  // self.navigationItem.rightBarButtonItem = 
  //   [[UIBarButtonItem alloc] initWithBarButtonSystemItem: 
  //     UIBarButtonSystemItemCompose target: self action: 
  //       @selector(newMessage)];

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.table.backgroundColor = [UIColor backgroundColor];
  self.table.separatorInset  = UIEdgeInsetsMake(0.0f, 
    10.0f + (screen.size.width * 0.2) + 10.0f, 0.0f, 0.0f);
  self.table.showsVerticalScrollIndicator = YES;

  noMessagesView = [[OMBEmptyBackgroundWithImageAndLabel alloc] initWithFrame:
    screen];
  noMessagesView.alpha = 1.0f;
  noMessagesView.imageView.image = [UIImage imageNamed: 
    @"speech_bubble_icon.png"];
  NSString *text = @"Your messages with other users appear here. "
    @"You currently have no messages.";
  [noMessagesView setLabelText: text];
  [self.view addSubview: noMessagesView];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // [[OMBMessageStore sharedStore] createFakeMessages];

  // Homebase landlord presents this controller
  // We only want to show the menu icon on the inbox from the side menu
  if ([self.navigationController.viewControllers count] == 1) {
    [self setMenuBarButtonItem];
  }

  [self.table reloadData];
  [self reloadTable];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];

  self.fetching = YES;
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGFloat scrollViewHeight = scrollView.frame.size.height;
  CGFloat contentHeight    = scrollView.contentSize.height;
  CGFloat totalContentOffset = contentHeight - scrollViewHeight;
  CGFloat limit = totalContentOffset - (scrollViewHeight / 1.0f);
  if (!self.fetching && scrollView.contentOffset.y > limit &&
    self.maxPages > self.currentPage) {

    self.currentPage += 1;
    self.fetching = YES;
    [self reloadTable];
  }
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  OMBInboxCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[OMBInboxCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CellIdentifier];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [[[OMBConversationMessageStore sharedStore].messages allKeys] count];
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView 
didEndDisplayingCell: (UITableViewCell *) cell 
forRowAtIndexPath: (NSIndexPath *) indexPath
{
  
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  OMBMessage *message = [self messageAtIndexPath: indexPath];
  message.viewed = YES;
  messageDetailViewController = 
    [[OMBMessageDetailViewController alloc] initWithUser: [message otherUser]];
  [self.navigationController pushViewController: messageDetailViewController 
    animated: YES];
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBInboxCell heightForCell];
}

- (void) tableView: (UITableView *) tableView 
willDisplayCell: (UITableViewCell *) cell 
forRowAtIndexPath: (NSIndexPath *) indexPath
{
  OMBMessage *message = [self messageAtIndexPath: indexPath];
  [(OMBInboxCell *) cell loadMessageData: message];
  // [[OMBUser currentUser] fetchMessagesAtPage: 1 withUser: message.sender
  //   delegate: nil completion: nil];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (OMBMessage *) messageAtIndexPath: (NSIndexPath *) indexPath
{
  return [[self messages] objectAtIndex: indexPath.row];
}

- (NSArray *) messages
{
  return [[OMBConversationMessageStore sharedStore] sortedMessages];
}

- (void) newMessage
{
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      [[OMBMessageNewViewController alloc] init]]
        animated: YES completion: nil];
}

- (void) reloadTable
{
  [super reloadTable];

  [OMBConversationMessageStore sharedStore].delegate = self;
  for (int i = self.currentPage; i > 0; i--) {
  // NSInteger currentCount =
  //   [[[OMBConversationMessageStore sharedStore].messages allKeys] count];

    [[OMBConversationMessageStore sharedStore] fetchMessagesAtPage: i 
      completion: ^(NSError *error) {
        [self.table reloadData];
        [self updateNoMessagesView];
        // NSInteger newCount = 
        //   [[[OMBConversationMessageStore sharedStore].messages 
        //     allKeys] count];
        // NSInteger difference = newCount - currentCount;
        // NSLog(@"CURRENT COUNT: %i", currentCount);
        // NSLog(@"NEW COUNT: %i", newCount);

        // if (difference > 0) {
        //   [self.table beginUpdates];
        //   for (int i = currentCount; i < newCount; i++) {
        //     [self.table insertRowsAtIndexPaths: @[
        //       [NSIndexPath indexPathForRow: i inSection: 0]
        //     ] withRowAnimation: UITableViewRowAnimationFade];
        //   }
        //   [self.table endUpdates];
        // }
        self.fetching = NO;
      }
    ];
  }
  [self updateNoMessagesView];
}

- (void) updateNoMessagesView
{
  if ([[self messages] count]) {      
    if (noMessagesView.alpha) {
      // [UIView animateWithDuration: OMBStandardDuration animations: ^{
      //   noMessagesView.alpha = 0.0f;
      // }];
      noMessagesView.alpha = 0.0f;
    }
  }
  else {
    if (!noMessagesView.alpha) {
      // [UIView animateWithDuration: OMBStandardDuration animations: ^{
      //   noMessagesView.alpha = 1.0f;
      // }];
      noMessagesView.alpha = 1.0f;
    }
  }
}

@end
