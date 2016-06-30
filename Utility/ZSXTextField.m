//
//  ZSXTextField.m
//  QingYanFuYanWo
//
//  Created by qianfeng on 15-11-4.
//  Copyright (c) 2015年 zoushixin. All rights reserved.
//

#import "ZSXTextField.h"

@implementation ZSXTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 20;// 右偏10
    return iconRect;
}
- (CGRect)textRectForBounds:(CGRect)bounds;
{
    CGRect textRect = [super textRectForBounds:bounds];
    textRect.origin.x += 20;
    return textRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect editRect = [super editingRectForBounds:bounds];
    editRect.origin.x += 20;
    return editRect;
}

@end
