//
//  OMBInboxViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBInboxViewController.h"

#import "OMBActivityView.h"
#import "OMBConversation.h"
#import "OMBConversationStore.h"
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

  self.title = @"Messages";

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
  
  // Activity spinner
  activityView = [[OMBActivityView alloc] init];
  [self.view addSubview: activityView];

  refreshControl = [UIRefreshControl new];
  [refreshControl addTarget:self action:@selector(refresh) forControlEvents:
   UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor grayMedium];
  [self.table addSubview:refreshControl];
  
  noMessagesView = [[OMBEmptyBackgroundWithImageAndLabel alloc] initWithFrame:
    screen];
  noMessagesView.alpha = 0.0f;
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

  [activityView startSpinning];
  [self.table reloadData];

  [self reloadTable];

  // Update the menu badge count for inbox
  [[NSNotificationCenter defaultCenter] postNotificationName:
    OMBMessagesUnviewedCountNotification object: nil userInfo: @{
      @"count": @0
    }
  ];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];

  self.fetching = YES;
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];
  
  [refreshControl endRefreshing];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  [[OMBConversationStore sharedStore] readFromDictionary: dictionary];
}

- (void) numberOfPages: (NSUInteger) pages
{
  self.maxPages = pages;
}

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
  return [[OMBConversationStore sharedStore] numberOfConversations];
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  OMBConversation *conversation = [self conversationAtIndexPath: indexPath];
  // Add the current user's uid to the 
  // conversation.mostRecentMessage.viewedUserIDs
  [self.navigationController pushViewController: 
    [[OMBMessageDetailViewController alloc] initWithConversation: 
      conversation] animated: YES];
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
  OMBConversation *conversation = [self conversationAtIndexPath: indexPath];
  [(OMBInboxCell *) cell loadConversationData: conversation];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (OMBConversation *) conversationAtIndexPath: (NSIndexPath *) indexPath
{
  return [[self conversations] objectAtIndex: indexPath.row];
}

- (NSArray *) conversations
{
  return [[OMBConversationStore sharedStore] sortedConversationsWithKey:
    @"mostRecentMessageDate" ascending: NO];
}

- (void) newMessage
{
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      [[OMBMessageNewViewController alloc] init]]
        animated: YES completion: nil];
}

- (void) refresh
{
  [self reloadTable];
}

- (void) reloadTable
{
  [super reloadTable];

  // [OMBConversationMessageStore sharedStore].delegate = self;
  for (int i = self.currentPage; i > 0; i--) {
    // NSInteger currentCount = [[self conversations] count];
    [[OMBConversationStore sharedStore] fetchConversationsAtPage: i 
      delegate: self completion: ^(NSError *error) {
        [activityView stopSpinning];
        [self.table reloadData];
        [self updateNoMessagesView];
        // NSInteger newCount = [[self conversations] count];

        // if (newCount - currentCount > 0) {
        //   [self.table beginUpdates];
        //   for (NSInteger i = currentCount; i < newCount; i++) {
        //     [self.table insertRowsAtIndexPaths: @[
        //       [NSIndexPath indexPathForRow: i inSection: 0]
        //     ] withRowAnimation: UITableViewRowAnimationFade];
        //   }
        //   [self.table endUpdates];
        // }
        self.fetching = NO;
        [refreshControl endRefreshing];
      }];
  }
}

- (void) updateNoMessagesView
{
  if ([[self conversations] count]) {      
    if (noMessagesView.alpha) {
      noMessagesView.alpha = 0.0f;
    }
  }
  else {
    if (!noMessagesView.alpha) {
      noMessagesView.alpha = 1.0f;
    }
  }
}

@end
