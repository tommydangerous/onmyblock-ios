//
//  OMBTextViewViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@interface OMBTextViewViewController : OMBViewController
<UITextViewDelegate>;
  
@property (nonatomic, strong) UITextView *textView;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) dismiss;
- (void) save;

@end
