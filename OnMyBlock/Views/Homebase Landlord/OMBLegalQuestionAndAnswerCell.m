//
//  OMBLegalQuestionAndAnswerCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBLegalQuestionAndAnswerCell.h"

#import "NSString+Extensions.h"
#import "OMBLegalAnswer.h"
#import "OMBLegalQuestion.h"

@implementation OMBLegalQuestionAndAnswerCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;

  questionLabel = [UILabel new];
  questionLabel.font = [OMBLegalQuestionAndAnswerCell fontForQuestionLabel];
  questionLabel.frame = CGRectMake(padding, padding, 
    [OMBLegalQuestionAndAnswerCell widthForQuestionLabel], 0.0f);
  questionLabel.numberOfLines = 0;
  questionLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: questionLabel];

  answerLabel = [UILabel new];
  answerLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  answerLabel.frame = CGRectMake(padding , padding, 
    screen.size.width - (padding * 2), 22.0f);
  [self.contentView addSubview: answerLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (UIFont *) fontForQuestionLabel
{
  return [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
}

+ (CGFloat) widthForQuestionLabel
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;
  return screen.size.width - (padding * 2);
}

#pragma mark - Instance Methods

- (void) loadData: (OMBLegalQuestion *) object 
atIndexPath: (NSIndexPath *) indexPath
{
  _legalQuestion = object;

  CGFloat padding = 20.0f;

  NSString *text = [NSString stringWithFormat: @"%i. %@",
    indexPath.row + 1, _legalQuestion.question];
  questionLabel.text = text;
  // Question label
  CGRect rect1 = [questionLabel.text boundingRectWithSize:
    CGSizeMake([OMBLegalQuestionAndAnswerCell widthForQuestionLabel], 9999)
      font: questionLabel.font];
  questionLabel.frame = CGRectMake(questionLabel.frame.origin.x,
    questionLabel.frame.origin.y, questionLabel.frame.size.width,
      rect1.size.height);

  answerLabel.frame = CGRectMake(answerLabel.frame.origin.x,
    questionLabel.frame.origin.y + 
    questionLabel.frame.size.height + (padding * 0.5f),
      answerLabel.frame.size.width, answerLabel.frame.size.height);
  if (indexPath.row % 2) {
    answerLabel.text = @"Yes";
    answerLabel.textColor = [UIColor green];
  }
  else {
    answerLabel.text = @"No";
    answerLabel.textColor = [UIColor red];
  }
}

- (void) loadLegalAnswer: (OMBLegalAnswer *) object
{

}

@end
