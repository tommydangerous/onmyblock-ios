//
//  OMBUserMenu.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/4/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBUserMenu.h"

#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBUserMenu

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  _renterButtons = [NSMutableArray array];
  _sellerButtons = [NSMutableArray array];

  float imageSize = 22;
  float leftPad   = 25;

  // Button
  _headerButton = [[UIButton alloc] init];
  _headerButton.contentEdgeInsets = UIEdgeInsetsMake(0, leftPad, 0, 0);
  _headerButton.contentHorizontalAlignment =
    UIControlContentHorizontalAlignmentLeft;
  _headerButton.frame = CGRectMake(0, 0, rect.size.width, 100);
  _headerButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 27];
  [self addSubview: _headerButton];

  // Buttons
  // Renter
  // Discover
  _discoverButton = [[UIButton alloc] init];
  _discoverButton.contentEdgeInsets = UIEdgeInsetsMake(0, 
    (leftPad + imageSize + leftPad), 0, 20);
  _discoverButton.contentHorizontalAlignment = 
    UIControlContentHorizontalAlignmentLeft;
  _discoverButton.frame = CGRectMake(-1 * rect.size.width, 0, rect.size.width, 
    10 + 40 + 10);
  _discoverButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  [_discoverButton setTitle: @"Discover" forState: UIControlStateNormal];
  [_discoverButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  UIImageView *discoverImageView = [[UIImageView alloc] init];
  discoverImageView.frame = CGRectMake(leftPad, 
    ((_discoverButton.frame.size.height - imageSize) * 0.5), 
      imageSize, imageSize);
  discoverImageView.image = [UIImage image: 
    [UIImage imageNamed: @"search_icon.png"] 
      size: discoverImageView.frame.size];
  [_discoverButton addSubview: discoverImageView];
  [_renterButtons addObject: _discoverButton];

  // Homebase
  _renterHomebaseButton = [[UIButton alloc] init];
  _renterHomebaseButton.contentEdgeInsets = _discoverButton.contentEdgeInsets;
  _renterHomebaseButton.contentHorizontalAlignment = 
    _discoverButton.contentHorizontalAlignment;
  _renterHomebaseButton.titleLabel.font = _discoverButton.titleLabel.font;
  [_renterHomebaseButton setTitle: @"Homebase" forState: UIControlStateNormal];
  [_renterHomebaseButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  UIImageView *homebaseImageView = [[UIImageView alloc] init];
  homebaseImageView.frame = discoverImageView.frame;
  UIImage *homebaseImage = [UIImage imageNamed: @"homebase_icon.png"];
  homebaseImageView.image = [UIImage image: homebaseImage
    size: homebaseImageView.frame.size];
  [_renterHomebaseButton addSubview: homebaseImageView];
  [_renterButtons addObject: _renterHomebaseButton];

  // Favorites
  _favoritesButton = [[UIButton alloc] init];
  _favoritesButton.contentEdgeInsets = _discoverButton.contentEdgeInsets;
  _favoritesButton.contentHorizontalAlignment = 
    _discoverButton.contentHorizontalAlignment;
  _favoritesButton.titleLabel.font = _discoverButton.titleLabel.font;  
  [_favoritesButton setTitle: @"Favorites" forState: UIControlStateNormal];
  [_favoritesButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  UIImageView *favoritesImageView = [[UIImageView alloc] init];
  favoritesImageView.frame = discoverImageView.frame;
  UIImage *favoritesImage = [UIImage imageNamed: @"favorites_icon.png"];
  favoritesImageView.image = [UIImage image: favoritesImage
    size: favoritesImageView.frame.size];
  [_favoritesButton addSubview: favoritesImageView];
  [_renterButtons addObject: _favoritesButton];

  // Seller
  // Create Listing
  _createListingButton = [[UIButton alloc] init];
  _createListingButton.contentEdgeInsets = _discoverButton.contentEdgeInsets;
  _createListingButton.contentHorizontalAlignment = 
    _discoverButton.contentHorizontalAlignment;
  _createListingButton.frame = _discoverButton.frame;
  _createListingButton.titleLabel.font = _discoverButton.titleLabel.font;
  [_createListingButton setTitle: @"Create Listing" 
    forState: UIControlStateNormal];
  [_createListingButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
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
  _sellerHomebaseButton.contentEdgeInsets = _discoverButton.contentEdgeInsets;
  _sellerHomebaseButton.contentHorizontalAlignment = 
    _discoverButton.contentHorizontalAlignment;
  _sellerHomebaseButton.titleLabel.font = _discoverButton.titleLabel.font;
  [_sellerHomebaseButton setTitle: @"Homebase" 
    forState: UIControlStateNormal];
  [_sellerHomebaseButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  UIImageView *sellerHomebaseImageView = [[UIImageView alloc] init];
  sellerHomebaseImageView.frame = discoverImageView.frame;
  UIImage *sellerHomebaseImage = [UIImage imageNamed: 
    @"homebase_icon.png"];
  sellerHomebaseImageView.image = [UIImage image: sellerHomebaseImage
    size: sellerHomebaseImageView.frame.size];
  [_sellerHomebaseButton addSubview: sellerHomebaseImageView];
  [_sellerButtons addObject: _sellerHomebaseButton];
  // Manage listing
  _manageListingButton = [[UIButton alloc] init];
  _manageListingButton.contentEdgeInsets = _discoverButton.contentEdgeInsets;
  _manageListingButton.contentHorizontalAlignment = 
    _discoverButton.contentHorizontalAlignment;
  _manageListingButton.titleLabel.font = _discoverButton.titleLabel.font;
  [_manageListingButton setTitle: @"Manage Listing" 
    forState: UIControlStateNormal];
  [_manageListingButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  UIImageView *manageListingImageView = [[UIImageView alloc] init];
  manageListingImageView.frame = discoverImageView.frame;
  UIImage *manageListingImage = [UIImage imageNamed: 
    @"account_icon.png"];
  manageListingImageView.image = [UIImage image: manageListingImage
    size: manageListingImageView.frame.size];
  [_manageListingButton addSubview: manageListingImageView];
  [_sellerButtons addObject: _manageListingButton];

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
  }];}

- (void) setHeaderInactive
{
  [UIView animateWithDuration: 0.1 animations: ^{
    [_headerButton setTitleColor: [UIColor colorWithWhite: 1.0f alpha: 0.3f]
      forState: UIControlStateNormal];
  }];
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
  [_headerButton setTitle: @"Seller" forState: UIControlStateNormal];
  _currentButtons  = _sellerButtons;
  [self setupButtons];
}

@end
