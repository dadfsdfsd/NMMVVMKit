//
//  Observation.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "Observation.h"
#import "NSString+UUID.h"

@implementation Observation

- (instancetype)initWithUnobserveHandler:(UnobserveHandler)unobserveHandler {
    self = [super init];
    if (self) {
        _uuid = [NSString uuidString];
        _unobserveHandler = unobserveHandler;
    }
    return self;
}

@end
