//
//  Observable.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "Observable.h"

@implementation Observable

- (instancetype)initWithValue:(id)value {
    if (self = [super init]) {
        _value = value;
    }
    return self;
}

- (void)setValue:(id)value {
    if (_value != value) {
        id oldValue = _value;
        _value = value;
        ValueChange *valueChange = [[ValueChange alloc] initWithNewValue:value oldValue:oldValue];
        [self publish:valueChange];
    }
}

- (void)silentlyUpdateValueToValue:(id)value {
    _value = value;
}

@end
