//
//  OMBMessageDetailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

#import "OMBConnectionProtocol.h"

@class OMBConversation;
@class OMBMessage;
@class OMBMessageInputToolbar;

@interface OMBMessageDetailViewController : OMBViewController
<OMBConnectionProtocol>
{
  CGFloat keyboardHeight;
}

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) BOOL fetching;
@property (nonatomic) NSInteger maxPages;
@property (nonatomic, strong) NSArray *messages;

#pragma mark - Initializer

- (id) initWithConversation: (OMBConversation *) object;
- (id) initWithResidence: (OMBResidence *) object;
- (id) initWithUser: (OMBUser *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadDefaultMessage;
- (void) send;

@end
