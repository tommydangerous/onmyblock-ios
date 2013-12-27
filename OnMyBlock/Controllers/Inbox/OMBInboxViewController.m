//
//  OMBInboxViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBInboxViewController.h"

#import "OMBInboxCell.h"
#import "OMBMessage.h"
#import "OMBMessageDetailViewController.h"
#import "OMBMessageNewViewController.h"
#import "OMBMessageStore.h"
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

  [self setMenuBarButtonItem];

  [self setupForTable];

  self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: 
      UIBarButtonSystemItemCompose target: self action: @selector(newMessage)];

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.table.backgroundColor = [UIColor backgroundColor];
  self.table.separatorInset  = UIEdgeInsetsMake(0.0f, 
    10.0f + (screen.size.width * 0.2) + 10.0f, 0.0f, 0.0f);
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];
  // [self tableView: self.table didSelectRowAtIndexPath: 
  //   [NSIndexPath indexPathForRow: 0 inSection: 0]];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [[OMBMessageStore sharedStore] createFakeMessages];
}

#pragma mark - Protocol

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
  [cell loadMessageData: [self messageAtIndexPath: indexPath]];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [[[OMBMessageStore sharedStore] mostRecentThreadedMessages] count];
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
  [self.navigationController pushViewController: 
    [[OMBMessageDetailViewController alloc] initWithUser: message.sender] 
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
 
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (OMBMessage *) messageAtIndexPath: (NSIndexPath *) indexPath
{
  return 
    [[[OMBMessageStore sharedStore] mostRecentThreadedMessages] objectAtIndex:
      indexPath.row];
}

- (void) newMessage
{
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      [[OMBMessageNewViewController alloc] init]]
        animated: YES completion: nil];
}

@end
