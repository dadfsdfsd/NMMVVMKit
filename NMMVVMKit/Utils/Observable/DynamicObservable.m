//
//  DynamicObservable.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "DynamicObservable.h"

@interface DynamicObservable ()

@property (nonatomic, strong) NSObject *retainedTarget;

@property (nonatomic, assign) BOOL shouldRetainTarget;

@property (nonatomic, assign) BOOL isObserving;

@end


@implementation DynamicObservable

- (instancetype)initWithTarget:(NSObject *)target keyPath:(NSString *)keyPath {
    return [self initWithTarget:target keyPath:keyPath shouldRetainTarget:true];
}

- (instancetype)initWithTarget:(NSObject *)target keyPath:(NSString *)keyPath shouldRetainTarget:(BOOL)shouldRetainTarget {
    if (self = [self init]) {
        _target = target;
        _keyPath = keyPath;
        _shouldRetainTarget = shouldRetainTarget;
    }
    return self;
}

- (id)value {
    return [_target valueForKeyPath:_keyPath];
}

- (void)setValue:(id)value {
    [_target setValue:value forKeyPath:_keyPath];
}

-(void)didAddEventHandler {
    [self startObservation];
}

- (void)startObservation {
    if (_isObserving) {
        return;
    }
    [_target addObserver:self forKeyPath:_keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    _isObserving = true;
    
    if (_shouldRetainTarget) {
        _retainedTarget = _target;
    }
}

- (void)stopObservation {
    if (!_isObserving) {
        return;
    }
    [_target removeObserver:self forKeyPath:_keyPath];
    _isObserving = false;
    _retainedTarget = nil;
}

-(void)dealloc {
    [self stopObservation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (change) {
        id oldValue = change[NSKeyValueChangeOldKey];
        id newValue = change[NSKeyValueChangeNewKey];
        ValueChange<id> *valueChange = [[ValueChange alloc]initWithNewValue:newValue oldValue:oldValue];
        [self publish:valueChange];
    }
}

@end
