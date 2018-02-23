//
//  ValueChange.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "ValueChange.h"

@implementation ValueChange

-(instancetype)initWithNewValue:(id)newValue oldValue:(id)oldValue {
    if (self = [super init]) {
        _nValue = newValue;
        _oValue = oldValue;
    }
    return self;
}

@end
