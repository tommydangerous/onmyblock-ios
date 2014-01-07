//
//  TextFieldPadding.h
//  Bite
//
//  Created by Tommy DANGerous on 5/30/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldPadding : UITextField

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic) float leftPaddingX;
@property (nonatomic) float paddingX;
@property (nonatomic) float paddingY;
@property (nonatomic) float rightPaddingX;
@property (nonatomic, strong) UIColor *placeholderColor;

@end
