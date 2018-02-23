//
//  CustomDataModel.h
//  MyIpadDemo
//
//  Created by 杨帆 on 2018/2/9.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomData.h"

typedef void (^CustomDataModelUpdaterCompletion)(BOOL finished, NSArray<CustomSectionData *> *dataItems);

@interface CustomDataModel : NSObject

@property (nonatomic, strong) NSArray<CustomSectionData *> *dataItems;

//@property (nonatomic, retain) BOOL state;

- (void)updateDataItemAtIndex:(NSInteger)index withCompletion:(CustomDataModelUpdaterCompletion)completion;

@end
