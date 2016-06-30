//
//  ZSXAlertLabel.m
//  QingYanFuYanWo
//
//  Created by qianfeng on 15-11-5.
//  Copyright (c) 2015年 zoushixin. All rights reserved.
//

#import "ZSXAlertLabel.h"
#import "POP.h"
@implementation ZSXAlertLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initCustom];
    }
    return self;
}

- (void)initCustom{
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor redColor];
    self.textAlignment = NSTextAlignmentCenter;
}

- (void)show:(NSString *)alertText{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.text = alertText;
        self.alpha = 1.0 ;
        POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        spring.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x-30, self.center.y)];
        spring.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)];
        spring.springBounciness = 30;
        
        [self pop_addAnimation:spring forKey:@"center"];
        
        POPBasicAnimation *basic2 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        basic2.beginTime = CACurrentMediaTime()+2;
        basic2.fromValue = @(1.0);
        basic2.toValue  =@(0.0);
        basic2.duration = 2.0;
        [self pop_addAnimation:basic2 forKey:@"alpha"];
    });
   
}
@end
