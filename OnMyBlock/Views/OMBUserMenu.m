//
//  OMBUserMenu.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/4/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBUserMenu.h"

#import "NSString+Extensions.h"
#import "OMBUser.h"
#import "OMBViewController.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Resize.h"

@implementation OMBUserMenu

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  // Landlord type
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(updateLandlordType:)
      name: OMBCurrentUserLandlordTypeChangeNotification object: nil];
  
  // Messages badge
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(updateMessagesUnviewedCount:) 
      name: OMBMessagesUnviewedCountNotification object: nil];

  // When user logs out
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(userLogout:)
      name: OMBUserLoggedOutNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateLandlordOffersPendingCount:)
                                                 name: OMBOffersLandordPendingCountNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateRenterOffersAcceptedCount:)
                                                 name: OMBOffersRenterAcceptedCountNotification object: nil];

  _renterButtons = [NSMutableArray array];
  _sellerButtons = [NSMutableArray array];

  float imageSize = 22;
  float leftPad   = 25;
  // CGFloat buttonHeight = 10.0f + 40.0f + 10.0f;
  CGFloat buttonHeight = OMBStandardButtonHeight;
  CGFloat padding = OMBPadding;

  // Button
  _headerButton = [[UIButton alloc] init];
  _headerButton.contentEdgeInsets = UIEdgeInsetsMake(0, leftPad, 0, 0);
  _headerButton.contentHorizontalAlignment =
    UIControlContentHorizontalAlignmentLeft;
  _headerButton.frame = CGRectMake(0, 0, rect.size.width, 100);
  // _headerButton.titleLabel.font = [UIFont fontWithName: 
  //   @"HelveticaNeue-Light" size: 27];
  _headerButton.titleLabel.font = [UIFont mediumLargeTextFont];
  [_headerButton addTarget: self action: @selector(headerButtonSelected) 
    forControlEvents: UIControlEventTouchUpInside];
  [self addSubview: _headerButton];

  // Buttons
  // Renter

  // Search
  _searchButton = [UIButton new];
  _searchButton.frame = CGRectMake(-1 * rect.size.width, 0.0f, rect.size.width, 
    buttonHeight);
  [_searchButton addTarget: self action: @selector(showSearch)
    forControlEvents: UIControlEventTouchUpInside];
  [_searchButton setTitle: @"Search" forState: UIControlStateNormal];

  // Image view
  UIImageView *searchImageView = [[UIImageView alloc] init];
  searchImageView.frame = CGRectMake(leftPad, 
    ((_searchButton.frame.size.height - imageSize) * 0.5), 
      imageSize, imageSize);
  searchImageView.image = [UIImage image: 
    [UIImage imageNamed: @"search_icon.png"] 
      size: searchImageView.frame.size];
  [_searchButton addSubview: searchImageView];
  [_renterButtons addObject: _searchButton];

  // Discover
  _discoverButton = [[UIButton alloc] init];
  // _discoverButton.frame = CGRectMake(-1 * rect.size.width, 0.0f, 
  //   rect.size.width, 10.0f + 40.0f + 10.0f);
  [_discoverButton addTarget: self action: @selector(showDiscover)
    forControlEvents: UIControlEventTouchUpInside];
  [_discoverButton setTitle: @"Discover" forState: UIControlStateNormal];
  // Image view
  UIImageView *discoverImageView = [[UIImageView alloc] init];
  discoverImageView.frame = CGRectMake(leftPad, 
    ((_searchButton.frame.size.height - imageSize) * 0.5), 
      imageSize, imageSize);
  discoverImageView.image = [UIImage image: 
    [UIImage imageNamed: @"discover_icon.png"] 
      size: discoverImageView.frame.size];
  [_discoverButton addSubview: discoverImageView];
  [_renterButtons addObject: _discoverButton];

  // My Renter App
  _myRenterAppButton = [[UIButton alloc] init];
  [_myRenterAppButton addTarget: self action: @selector(showMyRenterApp)
    forControlEvents: UIControlEventTouchUpInside];
  [_myRenterAppButton setTitle: @"My Renter App" 
    forState: UIControlStateNormal];
  UIImageView *myRenterAppImageView = [[UIImageView alloc] init];
  myRenterAppImageView.frame = discoverImageView.frame;
  UIImage *myRenterAppImage = [UIImage imageNamed: @"user_icon_white.png"];
  myRenterAppImageView.image = [UIImage image: myRenterAppImage
    size: myRenterAppImageView.frame.size];
  [_myRenterAppButton addSubview: myRenterAppImageView];
  // [_renterButtons addObject: _myRenterAppButton];

  // Homebase
  _renterHomebaseButton = [[UIButton alloc] init];
  [_renterHomebaseButton addTarget: self action: @selector(showHomebaseRenter)
    forControlEvents: UIControlEventTouchUpInside];
  [_renterHomebaseButton setTitle: @"Homebase" forState: UIControlStateNormal];
  UIImageView *homebaseImageView = [[UIImageView alloc] init];
  homebaseImageView.frame = discoverImageView.frame;
  UIImage *homebaseImage = [UIImage imageNamed: @"homebase_icon.png"];
  homebaseImageView.image = [UIImage image: homebaseImage
    size: homebaseImageView.frame.size];
  [_renterHomebaseButton addSubview: homebaseImageView];
  [_renterButtons addObject: _renterHomebaseButton];
  // Notification badge
  _renterHomebaseNotificationBadge = [UILabel new];
  [_renterHomebaseButton addSubview: _renterHomebaseNotificationBadge];

  // Favorites
  _favoritesButton = [[UIButton alloc] init];
  [_favoritesButton addTarget: self action: @selector(showFavorites)
    forControlEvents: UIControlEventTouchUpInside];
  [_favoritesButton setTitle: @"Favorites" forState: UIControlStateNormal];
  UIImageView *favoritesImageView = [[UIImageView alloc] init];
  favoritesImageView.frame = discoverImageView.frame;
  UIImage *favoritesImage = [UIImage imageNamed: @"favorites_icon.png"];
  favoritesImageView.image = [UIImage image: favoritesImage
    size: favoritesImageView.frame.size];
  [_favoritesButton addSubview: favoritesImageView];
  [_renterButtons addObject: _favoritesButton];

  // Inbox
  _inboxButton = [UIButton new];
  [_inboxButton addTarget: self action: @selector(showInbox)
    forControlEvents: UIControlEventTouchUpInside];
  [_inboxButton setTitle: @"Inbox" forState: UIControlStateNormal];
  UIImageView *inboxImageView = [UIImageView new];
  inboxImageView.frame = discoverImageView.frame;
  inboxImageView.image = [UIImage image: [UIImage imageNamed: @"message_icon.png"]
    size: inboxImageView.frame.size];
  [_inboxButton addSubview: inboxImageView];
  [_renterButtons addObject: _inboxButton];
  // Notification badge
  _inboxNotificationBadge = [UILabel new];
  [_inboxButton addSubview: _inboxNotificationBadge];

  // Seller
  // Create Listing
  _createListingButton = [[UIButton alloc] init];
  // Need this since it is the top button
  _createListingButton.frame = _searchButton.frame;
  [_createListingButton addTarget: self action: @selector(showCreateListing)
    forControlEvents: UIControlEventTouchUpInside];
  [_createListingButton setTitle: @"Create Listing" 
    forState: UIControlStateNormal];
  UIImageView *createListingImageView = [[UIImageView alloc] init];
  createListingImageView.frame = discoverImageView.frame;
  UIImage *createListingImage = [UIImage imageNamed: 
    @"create_listing_icon.png"];
  createListingImageView.image = [UIImage image: createListingImage
    size: createListingImageView.frame.size];
  [_createListingButton addSubview: createListingImageView];
  [_sellerButtons addObject: _createListingButton];

  // Homebase
  _sellerHomebaseButton = [[UIButton alloc] init];
  [_sellerHomebaseButton addTarget: self action: @selector(showHomebaseLandlord)
    forControlEvents: UIControlEventTouchUpInside];
  [_sellerHomebaseButton setTitle: @"Homebase" 
    forState: UIControlStateNormal];
  UIImageView *sellerHomebaseImageView = [[UIImageView alloc] init];
  sellerHomebaseImageView.frame = discoverImageView.frame;
  UIImage *sellerHomebaseImage = [UIImage imageNamed: 
    @"homebase_icon.png"];
  sellerHomebaseImageView.image = [UIImage image: sellerHomebaseImage
    size: sellerHomebaseImageView.frame.size];
  [_sellerHomebaseButton addSubview: sellerHomebaseImageView];
  [_sellerButtons addObject: _sellerHomebaseButton];
  // Notification badge
  _sellerHomebaseNotificationBadge = [UILabel new];
  [_sellerHomebaseButton addSubview: _sellerHomebaseNotificationBadge];

  // Manage listing
  _manageListingsButton = [[UIButton alloc] init];
  [_manageListingsButton addTarget: self action: @selector(showManageListings)
    forControlEvents: UIControlEventTouchUpInside];
  [_manageListingsButton setTitle: @"Manage Listings" 
    forState: UIControlStateNormal];
  UIImageView *manageListingImageView = [[UIImageView alloc] init];
  manageListingImageView.frame = discoverImageView.frame;
  UIImage *manageListingImage = [UIImage imageNamed: 
    @"account_icon.png"];
  manageListingImageView.image = [UIImage image: manageListingImage
    size: manageListingImageView.frame.size];
  [_manageListingsButton addSubview: manageListingImageView];
  [_sellerButtons addObject: _manageListingsButton];

  // Set attributes for buttons
  NSArray *buttonsArray = @[
    // Renter
    _searchButton,
    _discoverButton, 
    _myRenterAppButton,
    _renterHomebaseButton,
    _favoritesButton,
    _inboxButton,
    // Seller
    _createListingButton,
    _sellerHomebaseButton,
    _manageListingsButton
  ];
  for (UIButton *button in buttonsArray) {
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 
      leftPad + imageSize + leftPad, 0.0f, padding);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
      size: 17];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [button setTitleColor: [UIColor grayLight] 
      forState: UIControlStateHighlighted];
  }

  // Set attributes for notification badges
  NSArray *badgeArray = @[
    _inboxNotificationBadge,
    _renterHomebaseNotificationBadge,
    _sellerHomebaseNotificationBadge
  ];
  for (UILabel *label in badgeArray) {
    label.backgroundColor = [UIColor blue];
    label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 13];
    label.frame = CGRectMake(
      discoverImageView.frame.origin.x - (padding * 0.5f), 
        discoverImageView.frame.origin.y - (padding * 0.5f), 
          padding, padding);
    label.hidden = YES;
    label.layer.cornerRadius = label.frame.size.height * 0.5f;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
  }

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addCurrentMenuButtonsToMenuScroll
{
  for (UIView *v in _currentButtons) {
    [self addSubview: v];
  }
}

- (OMBAppDelegate *) appDelegate
{
  return [UIApplication sharedApplication].delegate;
}

- (void) changeTitleLabelColor:(UIButton *)button
{
  // there are six OMBUserMenu in container
  [[self container] setTitleColorWhite];
  [button setTitleColor: [UIColor blue] forState: UIControlStateNormal];
}

- (OMBViewControllerContainer *) container
{
  return [self appDelegate].container;
}

- (void) headerButtonSelected
{
  NSLog(@"SELECTED");
}

- (void) removeCurrentButtonsFromMenuScroll
{
  for (UIView *v in _currentButtons) {
    [v removeFromSuperview];
  }
}

- (void) setFramesForButtons: (NSArray *) array
{
  for (UIButton *button in array) {
    int index = [array indexOfObject: button];
    if (index > 0) {
      UIButton *previousButton = (UIButton *) [array objectAtIndex: index - 1];
      CGRect rect = previousButton.frame;
      button.frame = CGRectMake(rect.origin.x, 
        rect.origin.y + rect.size.height,
          rect.size.width, rect.size.height);
    }
  }
}

- (void) setHeaderActive
{
  [UIView animateWithDuration: 0.1 animations: ^{
    [_headerButton setTitleColor: [UIColor whiteColor]
      forState: UIControlStateNormal];
  }];
  _headerButton.userInteractionEnabled = NO;
}

- (void) setHeaderInactive
{
  [UIView animateWithDuration: 0.1 animations: ^{
    [_headerButton setTitleColor: [UIColor colorWithWhite: 1.0f alpha: 0.5f]
      forState: UIControlStateNormal];
  }];
  _headerButton.userInteractionEnabled = YES;
}

- (void) setTopButtonFrame
{
  if ([_currentButtons count] > 0) {
    CGRect screen   = [[UIScreen mainScreen] bounds];
    UIButton *first = (UIButton *) [_currentButtons objectAtIndex: 0];
    CGRect rect     = first.frame;
    float totalHeight = rect.size.height * [_currentButtons count];
    float originY     = (screen.size.height - totalHeight) * 0.5;
    first.frame = CGRectMake(rect.origin.x, originY,
      rect.size.width, rect.size.height);
  }
}

- (void) setupButtons
{
  [self addCurrentMenuButtonsToMenuScroll];
  [self setTopButtonFrame];
  [self setFramesForButtons: _currentButtons];
}

- (void) setup
{
  if (_isForLandlord)
    [self setupForSeller];
  else
    [self setupForRenter];
}

- (void) setupForRenter
{
  [self removeCurrentButtonsFromMenuScroll];
  [_headerButton setTitle: @"Renter" forState: UIControlStateNormal];
  _currentButtons  = _renterButtons;
  [self setupButtons];
}

- (void) setupForSeller
{
  [self removeCurrentButtonsFromMenuScroll];
  [_headerButton setTitle: @"Create Listing" forState: UIControlStateNormal];
  _currentButtons  = _sellerButtons;
  [self setupButtons];
}

- (void) showCreateListing
{
  [self changeTitleLabelColor:_createListingButton];
  [[self container] showCreateListing];
}

- (void) showDiscover
{
  [self changeTitleLabelColor:_discoverButton];
  [[self container] showDiscover];
}

- (void) showFavorites
{
  [self changeTitleLabelColor:_favoritesButton];
  [[self container] showFavorites];
}

- (void) showHomebaseLandlord
{
  [self changeTitleLabelColor:_sellerHomebaseButton];
  [[self container] showHomebaseLandlord];
}

- (void) showHomebaseRenter
{
  [self changeTitleLabelColor:_renterHomebaseButton];
  [[self container] showHomebaseRenter];
}

- (void) showInbox
{
  [self changeTitleLabelColor:_inboxButton];
  [[self container] showInbox];
}

- (void) showManageListings
{
  [self changeTitleLabelColor:_manageListingsButton];
  [[self container] showManageListings];
}

- (void) showMyRenterApp
{
  [[self container] showMyRenterApp];
}

- (void) showSearch
{
  [self changeTitleLabelColor:_discoverButton];
  [[self container] showSearchAndSwitchToList: YES];
}

- (void) updateNotificationBadgeLabel: (UILabel *) label 
withNumber: (NSNumber *) number
{
  label.layer.cornerRadius = label.frame.size.height * 0.5f;
  int count = [number intValue];
  if (count == 0)
    label.hidden = YES;
  else
    label.hidden = NO;
  NSString *countString = [NSString stringWithFormat: @"%i", count];
  label.text = countString;
  if (count > 9) {
    CGRect rect = [label.text boundingRectWithSize: CGSizeMake(99.0f,
      label.frame.size.height) font: label.font];
    CGRect newRect = label.frame;
    CGFloat newWidth = rect.size.width;
    if (newWidth < 20)
      newWidth = 20.0f;
    newRect.size.width = 1.0f + newWidth + 1.0f;
    label.frame = newRect;
  }
}

- (void) updateLandlordType: (NSNotification *) notification
{
  NSString *title = @"Create Listing";
  id landlordType = [[notification userInfo] objectForKey: @"landlordType"];
  // If this user menu is a user menu with the landlord options
  if (_isForLandlord) {
    if (landlordType != [NSNull null]) {
      if ([(NSString *) landlordType length]) {
        title = (NSString *) landlordType;
      }
    }
    [_headerButton setTitle: [title capitalizedString] 
      forState: UIControlStateNormal];
  }
}

- (void) updateMessagesUnviewedCount: (NSNotification *) notification
{
  NSNumber *count = [[notification userInfo] objectForKey: @"count"];
  [self updateNotificationBadgeLabel: _inboxNotificationBadge
    withNumber: count];
}

- (void)updateLandlordOffersPendingCount:(NSNotification*)noti {
    NSNumber *number = noti.object;
    [self updateNotificationBadgeLabel:_sellerHomebaseNotificationBadge
                            withNumber:number];
}

- (void)updateRenterOffersAcceptedCount:(NSNotification*)noti {
    NSNumber *number = noti.object;
    [self updateNotificationBadgeLabel:_renterHomebaseNotificationBadge
                            withNumber:number];
}

- (void) userLogout: (NSNotification *) notification
{
  [self changeTitleLabelColor:nil];
  // Inbox
  [self updateNotificationBadgeLabel: _inboxNotificationBadge withNumber: @0];
    [self updateNotificationBadgeLabel:_renterHomebaseNotificationBadge
                            withNumber:@0];
    [self updateNotificationBadgeLabel:_sellerHomebaseNotificationBadge
                            withNumber:@0];
}

@end
