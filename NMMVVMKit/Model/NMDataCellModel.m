//
//  BaseDataCellModel.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "NMDataCellModel.h"

@implementation NMDataCellModel

- (instancetype)initWithData:(id)data {
    if (self = [super init]) {
        self.data = data;
    }
    return self;
}

- (void)setData:(id<IGListDiffable>)data {
    if (_data != data) {
        _data = data;
        [self didLoadData];
    }
}

- (void)didLoadData {
    
}

- (id<NSObject>)diffIdentifier {
    return self.data.diffIdentifier;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    NMDataCellModel *cellModel = (NMDataCellModel *)object;
    if ([cellModel isKindOfClass:[NMDataCellModel class]]) {
        return [self.data isEqualToDiffableObject:cellModel.data];
    }
    return false;
//    return object == self;
}

@end
