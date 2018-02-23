//
//  NSObject+ObservationManager.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObservationManager.h"
#import "Observable.h"
#import "DynamicObservable.h"

@interface NSObject (ObservationManager)

- (ObservationManager *)observationManager;

@end
