//
//  BaseViewModel.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "BaseViewModel.h"

@interface BaseViewModel ()
    
@property(nonatomic, strong) NSArray<BaseSectionModel *> *sectionModels;

@end


@implementation BaseViewModel {
    
    BOOL _isDataInitialized;
    
}

- (void)didBindViewController {
    if (!_isDataInitialized) {
        [self loadData];
    }
    else {
        __weak __typeof(self) weakSelf = self;
        [self performUpdatesAnimated:false completion:^(BOOL finished, NSArray<BaseSectionModel *> *sectionModels) {
            if (finished) {
                weakSelf.sectionModels = sectionModels;
            }
        }];
    }
}

- (void)loadData {
    
}

- (void)markState:(ViewModelState)state completion:(void(^)(void))completion{
    if (state != _state) {
        _state = state;
        if (completion != nil) {
            completion();
        }
    }
}
 
- (void)updateWithCompletion:(void(^)(BOOL))completion {
    [self markState:ViewModelStateUpdating completion:^{
        self.state = ViewModelStateIdle;
    }];
}

- (void)refreshWithCompletion:(void(^)(BOOL))completion {
    [self markState:ViewModelStateRefreshing completion:^{
        self.state = ViewModelStateIdle;
    }];
}

- (void)loadMoreWithCompletion:(void(^)(BOOL))completion {
    [self markState:ViewModelStateLoadingMore completion:^{
        self.state = ViewModelStateIdle;
    }];
}

- (void)reload:(BOOL)aniamted {
    __weak __typeof(self) weakSelf = self;
    [self performUpdatesAnimated:aniamted completion:^(BOOL finished, NSArray<BaseSectionModel *> *sectionModels) {
        if (finished) {
            weakSelf.sectionModels = sectionModels;
        }
    }];
}

- (NSArray<BaseSectionModel *> *)newSectionModels {
    return [NSArray<BaseSectionModel *> new];
}

- (void)performUpdatesAnimated:(BOOL)animated completion:(BaseViewModelUpdaterCompletion)completion {
    [_delegate reload:animated completion:completion];
}

- (BaseSectionModel *)sectionModelAtIndex:(NSInteger)index {
    if (index < _sectionModels.count) {
        return _sectionModels[index];
    }
    return nil;
}

- (id<BaseCellModel>)cellModelAtIndexPath:(NSIndexPath *)indexPath {
    BaseSectionModel *sectionModel = [self sectionModelAtIndex:indexPath.section];
    if (sectionModel && indexPath.row < sectionModel.cellModels.count) {
        return sectionModel.cellModels[indexPath.row];
    }
    return nil;
}


@end
