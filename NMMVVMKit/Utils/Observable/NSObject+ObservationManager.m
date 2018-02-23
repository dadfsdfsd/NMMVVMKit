//
//  NSObject+ObservationManager.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "NSObject+ObservationManager.h"
#import <objc/runtime.h>

@implementation NSObject (ObservationManager)

- (ObservationManager *)observationManager {
    ObservationManager *observationManager = (ObservationManager *)objc_getAssociatedObject(self, _cmd);
    if (observationManager == nil) {
        observationManager = [[ObservationManager alloc] init];
        objc_setAssociatedObject(self, _cmd, observationManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observationManager;
}

@end
