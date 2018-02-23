//
//  Observation.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UnobserveHandler)(void);

@interface Observation : NSObject

@property (nonatomic, strong, readonly) UnobserveHandler unobserveHandler;

@property (nonatomic, strong, readonly) NSString *uuid;

-(instancetype)initWithUnobserveHandler:(UnobserveHandler)unobserveHandler;

@end
