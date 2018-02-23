//
//  BaseDataStore.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/25.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "BaseDataStore.h"

@implementation BaseDataStore

- (instancetype)initWithPath:(NSString *)path {
    if (self = [self init]) {
        _path = path;
    }
    return self;
}

- (YYDiskCache *)diskCache {
    return [[YYDiskCache alloc] initWithPath:_path];
}

@end
