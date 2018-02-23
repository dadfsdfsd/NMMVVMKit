//
//  NSArray+Sequence.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/19.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "NSArray+Sequence.h"


@implementation NSArray (Sequence)

- (void)each:(void (^)(id obj))block {
    NSParameterAssert(block != nil);
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (void)apply:(void (^)(id obj))block {
    NSParameterAssert(block != nil);
    
    [self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (id)match:(BOOL (^)(id obj))block {
    NSParameterAssert(block != nil);
    
    NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];
    
    if (index == NSNotFound)
        return nil;
    
    return self[index];
}

- (NSArray *)select:(BOOL (^)(id obj))block {
    NSParameterAssert(block != nil);
    return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }]];
}

- (NSArray *)reject:(BOOL (^)(id obj))block {
    NSParameterAssert(block != nil);
    return [self select:^BOOL(id obj) {
        return !block(obj);
    }];
}

- (NSArray *)map:(id (^)(id obj))block {
    NSParameterAssert(block != nil);
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = block(obj) ?: [NSNull null];
        [result addObject:value];
    }];
    
    return result;
}

- (NSArray *)compact:(id (^)(id obj))block {
    NSParameterAssert(block != nil);
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = block(obj);
        if(value)
        {
            [result addObject:value];
        }
    }];
    
    return result;
}

- (id)reduce:(id)initial withBlock:(id (^)(id sum, id obj))block {
    NSParameterAssert(block != nil);
    
    __block id result = initial;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}

- (NSInteger)reduceInteger:(NSInteger)initial withBlock:(NSInteger (^)(NSInteger, id))block {
    NSParameterAssert(block != nil);
    
    __block NSInteger result = initial;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}

- (CGFloat)reduceFloat:(CGFloat)inital withBlock:(CGFloat (^)(CGFloat, id))block {
    NSParameterAssert(block != nil);
    
    __block CGFloat result = inital;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}

- (BOOL)any:(BOOL (^)(id obj))block {
    return [self match:block] != nil;
}

- (BOOL)none:(BOOL (^)(id obj))block {
    return [self match:block] == nil;
}

- (BOOL)all:(BOOL (^)(id obj))block {
    NSParameterAssert(block != nil);
    
    __block BOOL result = YES;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!block(obj)) {
            result = NO;
            *stop = YES;
        }
    }];
    
    return result;
}

- (BOOL)corresponds:(NSArray *)list withBlock:(BOOL (^)(id obj1, id obj2))block {
    NSParameterAssert(block != nil);
    
    __block BOOL result = NO;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < list.count) {
            id obj2 = list[idx];
            result = block(obj, obj2);
        } else {
            result = NO;
        }
        *stop = !result;
    }];
    
    return result;
}


@end
