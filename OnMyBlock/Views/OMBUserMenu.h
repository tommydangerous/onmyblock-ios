//
//  OMBUserMenu.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/4/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBUserMenu : UIView

// Array to hold the buttons
@property (nonatomic, strong) NSArray *currentButtons;
@property (nonatomic, strong) NSMutableArray *renterButtons;
@property (nonatomic, strong) NSMutableArray *sellerButtons;

// Buttons
@property (nonatomic, strong) UIButton *headerButton;
// Renter
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *discoverButton;
@property (nonatomic, strong) UIButton *myRenterAppButton;
@property (nonatomic, strong) UIButton *favoritesButton;
@property (nonatomic, strong) UIButton *renterHomebaseButton;
@property (nonatomic, strong) UIButton *inboxButton;
// Seller
@property (nonatomic, strong) UIButton *createListingButton;
@property (nonatomic, strong) UIButton *manageListingsButton;
@property (nonatomic, strong) UIButton *sellerHomebaseButton;

// Notification badges
@property (nonatomic, strong) UILabel *inboxNotificationBadge;
@property (nonatomic, strong) UILabel *renterHomebaseNotificationBadge;
@property (nonatomic, strong) UILabel *sellerHomebaseNotificationBadge;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setHeaderActive;
- (void) setHeaderInactive;
- (void) setupForRenter;
- (void) setupForSeller;

@end
