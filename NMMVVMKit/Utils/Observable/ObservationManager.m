//
//  ObservationManager.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "ObservationManager.h"
#import "NSArray+Sequence.h"

@interface ObservationManager ()

@property (nonatomic, strong) NSMutableArray<Observation *> *observations;

@end

@implementation ObservationManager

- (instancetype)init {
    if (self = [super init]) {
        _observations = [NSMutableArray new];
    }
    return self;
}

- (Observation *)observe:(EventPublisher *)eventPublisher withEventHandler:(EventHandler)eventHandler {
    NSString *key = [eventPublisher addEventHandler:eventHandler];
    UnobserveHandler unobserveHanler = ^() {
        [eventPublisher removeEventHandlerForKey:key];
    };
    Observation *observation = [[Observation alloc] initWithUnobserveHandler:unobserveHanler];
    [_observations addObject:observation];
    return observation;
}

- (void)unobserve:(Observation *)observation {
    observation.unobserveHandler();
    [_observations removeObject:observation];
}

- (void)unobserveAll {
    [_observations enumerateObjectsUsingBlock:^(Observation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.unobserveHandler();
    }];
    [_observations removeAllObjects];
}

- (void)dealloc {
    [self unobserveAll];
}

@end
