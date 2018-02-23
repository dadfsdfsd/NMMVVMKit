//
//  ObservationManager.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventPublisher.h"
#import "Observation.h"

@interface ObservationManager : NSObject

- (void)unobserve:(Observation *)observation;

- (void)unobserveAll;

- (Observation *)observe:(EventPublisher *)eventPublisher withEventHandler:(EventHandler)eventHandler;

@end
