//
//  EventPublisher.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValueChange.h"

@interface EventPublisher : NSObject

typedef void(^EventHandler)(ValueChange *);

@property(nonatomic, strong)NSMutableDictionary<NSString *, EventHandler> *eventHandlers;

- (void)publish:(ValueChange *)event;

- (NSString *)addEventHandler:(EventHandler)eventHandler;

- (void)removeEventHandlerForKey:(NSString *)key;

- (void)didAddEventHandler;

- (void)didRemoveEventHandler;

@end
