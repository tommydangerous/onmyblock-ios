//
//  OMBLegalQuestionCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBLegalAnswer;
@class OMBLegalQuestion;
@class OMBLegalViewController;

extern NSString *const LegalAnswerTextViewPlaceholder;

@interface OMBLegalQuestionCell : OMBTableViewCell <UITextViewDelegate>
{
  UIView *lineView;
  UIButton *noButton;
  BOOL noButtonHighlighted;
  UILabel *questionLabel;
  UIButton *yesButton;
  BOOL yesButtonHighlighted;
}

@property (nonatomic, weak) OMBLegalViewController *delegate;
@property (nonatomic, strong) UITextView *explanationTextView;
@property (nonatomic, strong) OMBLegalAnswer *legalAnswer;
@property (nonatomic, strong) OMBLegalQuestion *legalQuestion;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) buttonSize;
+ (UIFont *) fontForQuestionLabel;
+ (UIFont *) fontForQuestionLabelForOtherUser;
+ (CGFloat) textViewHeight;
+ (CGFloat) widthForQuestionLabel;

#pragma mark - Instance Methods

- (void) enableButton:(BOOL) enabled;
- (void) loadData: (OMBLegalQuestion *) object 
atIndexPath: (NSIndexPath *) indexPath;
- (void) loadData: (OMBLegalQuestion *) object
atIndexPathForOtherUser: (NSIndexPath *) indexPath;
- (void) loadLegalAnswer: (OMBLegalAnswer *) object;
- (void) loadLegalAnswerForOtherUser: (OMBLegalAnswer *) object;
- (void) loadLegalAnswer2: (OMBLegalAnswer *) object;

@end
