//
//  CustomViewModel.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/8.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "CustomViewModel.h"
#import "NMDataCellModel.h"
#import "NMSectionModel.h"
#import "CustomCellModel.h"
#import <ReactiveObjC.h>
#import "CustomData.h"
#import "CustomLoadingCellModel.h"
#import "NSMutableArray+Move.h"
#import "CustomDataModel.h"

@interface CustomViewModel()

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, assign) CGFloat insetTop;

@property (nonatomic, assign) BOOL reverse;

@property (nonatomic, strong) NSMutableArray<CustomSectionData *> *itemDatas;

@property (nonatomic, strong) CustomDataModel *dataModel;

@property (nonatomic, assign) NSInteger dataIndex;


@end


@implementation CustomViewModel

- (void)loadData {
    _insetTop = 30;
    _itemDatas = [NSMutableArray new];
    _dataIndex = 0;
    _dataModel = [CustomDataModel new];
    [self.delegate setNeedsUpdate];
}

- (void)updateWithCompletion:(void (^)(BOOL))completion {
    [self markState:ViewModelStateUpdating completion:^{
        _dataIndex = 0;
        __weak typeof(self) weakSelf = self;
        [_dataModel updateDataItemAtIndex:_dataIndex withCompletion:^(BOOL finished, NSArray<CustomSectionData *> *dataItems) {
            if (finished) {
                weakSelf.state = ViewModelStateIdle;
                weakSelf.itemDatas = [dataItems mutableCopy];
            }
            else {
                weakSelf.state = ViewModelStateError;
            }
            [weakSelf reload:false];
        }];
        [weakSelf reload:false];
    }];
}


- (void)refreshWithCompletion:(void (^)(BOOL))completion {
    [self markState:ViewModelStateRefreshing completion:^{
        _dataIndex = 0;
        __weak typeof(self) weakSelf = self;
        [_dataModel updateDataItemAtIndex:_dataIndex withCompletion:^(BOOL finished, NSArray<CustomSectionData *> *dataItems) {
            if (finished) {
                weakSelf.state = ViewModelStateIdle;
                weakSelf.itemDatas = [dataItems mutableCopy];
            }
            else {
                weakSelf.state = ViewModelStateError;
            }
            [weakSelf reload:false];
        }];
        [weakSelf reload:false];
    }];
}

- (void)loadMoreWithCompletion:(void (^)(BOOL))completion {
    [self markState:ViewModelStateLoadingMore completion:^{
        __weak typeof(self) weakSelf = self;
        [_dataModel updateDataItemAtIndex:_dataIndex withCompletion:^(BOOL finished, NSArray<CustomSectionData *> *dataItems) {
            if (finished) {
                weakSelf.state = ViewModelStateIdle;
                [weakSelf.itemDatas addObjectsFromArray:dataItems];
                weakSelf.dataIndex += 1;
            }
            else {
                weakSelf.state = ViewModelStateError;
            }
            [weakSelf reload:false];
        }];
        [weakSelf reload:false];
    }];
}

- (NSArray<NMSectionModel *> *)newSectionModels {
    
    NSMutableArray<NMSectionModel *> *sectionModels = [NSMutableArray new];
    
    if (self.state == ViewModelStateUpdating) {
        CustomLoadingCellModel *loadingCell = [CustomLoadingCellModel new];
        NMSectionModel *section = [NMSectionModel sectionModelWithCellModels:@[]];
        section.headerCell = loadingCell;
        [sectionModels addObject:section];
    }
    else {
        for (CustomSectionData *data in _itemDatas) {
            NSMutableArray<NMCellModel *> *cells = [NSMutableArray<NMCellModel *> new];
            for (CustomData *subData in data.items) {
                CustomCellModel *cell = [[CustomCellModel alloc] initWithData:subData];
                [cells addObject: cell];
            }
            
            if (cells.count > 0) {
                NMSectionModel *section = [NMSectionModel sectionModelWithCellModels:cells];
                section.minimumInteritemSpacing = 20;
                section.minimumLineSpacing = 20;
                section.inset = UIEdgeInsetsMake(_insetTop, 10, _insetTop, 10);
                section.diffIdentifier = data;
                [sectionModels addObject:section];
            }
        }
    }
    
    return sectionModels;
}

- (void)doInsetAndDelete {
    [_itemDatas enumerateObjectsUsingBlock:^(CustomSectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *tmp  = [obj.items mutableCopy];
        if (obj.items.count > 5) {
            [tmp removeObjectAtIndex:0];
            
            CustomData *data = [CustomData new];
            data.index = 999;
            [tmp insertObject:data atIndex:3];
            
            [tmp removeObjectAtIndex:0];
            
            CustomData *data2 = [CustomData new];
            data2.index = 9999;
            [tmp insertObject:data2 atIndex:2];
        }
        obj.items= [tmp copy];
    }];
}


- (void)doMove {
    
    [_itemDatas enumerateObjectsUsingBlock:^(CustomSectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *tmp  = [obj.items mutableCopy];
        if (obj.items.count > 5) {
            [tmp moveObjectAtIndex:4 toIndex:0];
            [tmp moveObjectAtIndex:3 toIndex:2];
            [tmp moveObjectAtIndex:4 toIndex:3];
            [tmp moveObjectAtIndex:3 toIndex:2];
            [tmp moveObjectAtIndex:4 toIndex:3];
        }
        obj.items= [tmp copy];
    }];
}

@end
