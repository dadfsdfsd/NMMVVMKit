//
//  CustomData.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/8.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "CustomData.h"

@implementation CustomSectionData

- (nonnull id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return object == self;
}

@end


@implementation CustomData

- (instancetype)init {
    if (self = [super init]) {
        NSInteger repeatCount = random()%100;
        NSString *base = @"这是一个字符串";
        NSMutableString *string = [NSMutableString string];
        for (NSInteger i = 0; i < repeatCount; i++) {
            [string appendString:base];
        }
        self.content = [string copy];
    }
    return self;
}

- (nonnull id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return object == self;
}

@end
