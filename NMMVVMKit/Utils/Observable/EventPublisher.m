//
//  EventPublisher.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "EventPublisher.h"
#import "NSString+UUID.h"

@implementation EventPublisher

- (instancetype)init {
    if (self = [super init]) {
        _eventHandlers  = [NSMutableDictionary new];
    }
    return self;
}

- (void)publish:(ValueChange *)event {
    [_eventHandlers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, EventHandler  _Nonnull eventHandler, BOOL * _Nonnull stop) {
        eventHandler(event);
    }];
}

- (NSString *)addEventHandler:(EventHandler)eventHandler {
    NSString *uuid = [NSString uuidString];
    [_eventHandlers setValue:eventHandler forKey:uuid];
    [self didAddEventHandler];
    return uuid;
}

- (void)removeEventHandlerForKey:(NSString *)key {
    [_eventHandlers removeObjectForKey:key];
    [self didRemoveEventHandler];
}

- (void)didAddEventHandler {}

- (void)didRemoveEventHandler {}

@end
