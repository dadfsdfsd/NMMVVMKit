//
//  BaseDataStore.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/25.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit.h>

@interface BaseDataStore : NSObject

@property(nonatomic, strong, readonly) NSString *path;

- (instancetype)initWithPath:(NSString *)path;

- (YYDiskCache *)diskCache;

@end
