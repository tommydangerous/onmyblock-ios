//
//  OMBLegalQuestionAndAnswerCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBLegalAnswer;
@class OMBLegalQuestion;

@interface OMBLegalQuestionAndAnswerCell : OMBTableViewCell
{
  UILabel *answerLabel;
  UILabel *questionLabel;
}

@property (nonatomic, strong) OMBLegalQuestion *legalQuestion;

#pragma mark - Methods

#pragma mark - Class Methods

+ (UIFont *) fontForQuestionLabel;
+ (CGFloat) widthForQuestionLabel;

#pragma mark - Instance Methods

- (void) loadData: (OMBLegalQuestion *) object 
atIndexPath: (NSIndexPath *) indexPath;
- (void) loadLegalAnswer: (OMBLegalAnswer *) object;

@end
