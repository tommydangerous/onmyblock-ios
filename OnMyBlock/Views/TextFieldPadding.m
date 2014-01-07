//
//  TextFieldPadding.m
//  Bite
//
//  Created by Tommy DANGerous on 5/30/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "TextFieldPadding.h"

@implementation TextFieldPadding

@synthesize paddingX;
@synthesize paddingY;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    // self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // self.autocorrectionType = UITextAutocorrectionTypeNo;
    // self.enablesReturnKeyAutomatically = YES;
    // self.returnKeyType = UIReturnKeySearch;
  }
  return self;
}

#pragma mark - Override UITextField

- (CGRect) textRectForBounds: (CGRect) bounds
{
  float originX = bounds.origin.x + self.paddingX;
  float originY = bounds.origin.y + self.paddingY;
  float sizeWidth  = bounds.size.width - (self.paddingX * 2);
  float sizeHeight = bounds.size.height - (self.paddingY * 2);
  if (self.leftPaddingX && self.rightPaddingX) {
    originX = bounds.origin.x + self.leftPaddingX;
    sizeWidth = bounds.size.width - (self.leftPaddingX + self.rightPaddingX);
  }
  return CGRectMake(originX, originY, sizeWidth, sizeHeight);
}

- (CGRect) editingRectForBounds: (CGRect) bounds
{
  return [self textRectForBounds: bounds];
}

- (void) setPlaceholder: (NSString *) string
{
  if (self.placeholderColor) {
    self.attributedPlaceholder = 
    [[NSAttributedString alloc] initWithString: string
      attributes: @{ NSForegroundColorAttributeName: self.placeholderColor }];
  }
  else {
    [super setPlaceholder: string];
  }
}

@end
