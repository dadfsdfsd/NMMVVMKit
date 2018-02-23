//
//  NSMutableArray+Move.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/2/1.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "NSMutableArray+Move.h"

@implementation NSMutableArray (Move)


- (void)moveObjectAtIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex {
    if (self.count > index && self.count > toIndex) {
        id object = [self objectAtIndex:index];
        if (index > toIndex) {
            [self removeObjectAtIndex:index];
            [self insertObject:object atIndex:toIndex];
        } else if (index < toIndex){
            [self removeObjectAtIndex:index];
            [self insertObject:object atIndex:toIndex - 1];
        }
    }
}

@end
