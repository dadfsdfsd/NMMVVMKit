//
//  Observable.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "EventPublisher.h"
#import "ValueChange.h"

@interface Observable<__covariant Value> : EventPublisher

@property (nonatomic, strong) Value value;

- (instancetype)initWithValue:(Value)value;

@end
