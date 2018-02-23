//
//  DynamicObservable.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventPublisher.h"
#import "ValueChange.h"

@interface DynamicObservable<__covariant Value> : EventPublisher

@property (nonatomic, strong) Value value;

@property (nonatomic, weak) NSObject *target;

@property (nonatomic, strong) NSString *keyPath;

- (instancetype)initWithTarget:(NSObject *)target keyPath:(NSString *)keyPath;

- (instancetype)initWithTarget:(NSObject *)target keyPath:(NSString *)keyPath shouldRetainTarget:(BOOL)shouldRetainTarget;


@end
