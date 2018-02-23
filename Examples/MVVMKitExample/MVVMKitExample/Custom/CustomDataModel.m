//
//  CustomDataModel.m
//  MyIpadDemo
//
//  Created by 杨帆 on 2018/2/9.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "CustomDataModel.h"


@implementation CustomDataModel {
    
    
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *path = @"nothing";
       
    }
    return self;
}

- (void)updateDataItemAtIndex:(NSInteger)index withCompletion:(CustomDataModelUpdaterCompletion)completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{;
        NSMutableArray *itemDatas = [NSMutableArray new];
        for (NSUInteger i = 0; i < 3; i++) {
            NSInteger numberOfItems = random()%10;
            NSMutableArray *items = [NSMutableArray new];
            for (NSInteger i = 0; i < numberOfItems; i ++) {
                CustomData *subData = [CustomData new];
                subData.index = i;
                [items addObject:subData];
            }
            CustomSectionData *sectionData = [CustomSectionData new];
            sectionData.items = [items copy];
            [itemDatas addObject:sectionData];
        }
        completion(true, itemDatas);
    });
}


@end
