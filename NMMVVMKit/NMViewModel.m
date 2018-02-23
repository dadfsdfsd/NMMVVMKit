//
//  NMViewModel.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "NMViewModel.h"

@interface NMViewModel ()
    
@property(nonatomic, strong) NSArray<NMSectionModel *> *sectionModels;

@end


@implementation NMViewModel {
    
    BOOL _isDataInitialized;
    
}

- (void)didBindViewController {
    if (!_isDataInitialized) {
        [self loadData];
    }
    else {
        __weak __typeof(self) weakSelf = self;
        [self performUpdatesAnimated:false completion:^(BOOL finished, NSArray<NMSectionModel *> *sectionModels) {
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
    [self performUpdatesAnimated:aniamted completion:^(BOOL finished, NSArray<NMSectionModel *> *sectionModels) {
        if (finished) {
            weakSelf.sectionModels = sectionModels;
        }
    }];
}

- (NSArray<NMSectionModel *> *)newSectionModels {
    return [NSArray<NMSectionModel *> new];
}

- (void)performUpdatesAnimated:(BOOL)animated completion:(NMViewModelUpdaterCompletion)completion {
    [_delegate reload:animated completion:completion];
}

- (NMSectionModel *)sectionModelAtIndex:(NSInteger)index {
    if (index < _sectionModels.count) {
        return _sectionModels[index];
    }
    return nil;
}

- (id<NMCellModel>)cellModelAtIndexPath:(NSIndexPath *)indexPath {
    NMSectionModel *sectionModel = [self sectionModelAtIndex:indexPath.section];
    if (sectionModel && indexPath.row < sectionModel.cellModels.count) {
        return sectionModel.cellModels[indexPath.row];
    }
    return nil;
}


@end
