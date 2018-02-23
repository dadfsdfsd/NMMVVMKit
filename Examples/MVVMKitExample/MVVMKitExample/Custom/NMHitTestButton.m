//
//  NMHitTestButton.m
//  music
//
//  Created by yangfan on 2018/1/16.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "NMHitTestButton.h"

@implementation NMHitTestButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = UIEdgeInsetsInsetRect(self.bounds, _hitTestInsets);
    BOOL result = CGRectContainsPoint(rect, point);
    result = [super pointInside:(result ? CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) : point) withEvent:event];
    NSLog(@"^^^^^^^^^%d", result);
    return result;
}

@end
