//
//  UIColor+EX.m
//  MyIpadDemo
//
//  Created by 杨帆 on 2018/2/2.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "UIColor+EX.h"

@implementation UIColor (EX)

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
}

@end
