//
//  OMBTopDetailView.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBCenteredImageView;

@interface OMBTopDetailView : UIView
{
  UIButton *settingsButton;
  UILabel *signup;
  UILabel *nameLabel;
  OMBCenteredImageView *imageView;
}

@property UIButton *account;

- (void) setName:(NSString *)name;
- (void) setImage: (UIImage *) object;
- (void) setupForLoggedInUser;
- (void) setupForLoggedOutUser;

@end
