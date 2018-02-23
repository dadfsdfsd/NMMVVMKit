//
//  BaseViewModel.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSectionModel.h"

typedef NS_ENUM (NSInteger, ViewModelState) {
    ViewModelStateIdle,
    ViewModelStateError,
    ViewModelStateRefreshing,
    ViewModelStateLoadingMore,
    ViewModelStateUpdating
};

typedef void (^BaseViewModelUpdaterCompletion)(BOOL finished, NSArray<BaseSectionModel *> *sectionModels);

@protocol BaseViewModelDelegate

@required

- (void)reload:(BOOL)animated completion:(BaseViewModelUpdaterCompletion)completion;

- (void)setNeedsUpdate;

- (void)setNeedsRefresh;

@end

@interface BaseViewModel : NSObject

@property(nonatomic, strong, readonly) NSArray<BaseSectionModel *> *sectionModels;

@property(nonatomic, weak) id<BaseViewModelDelegate> delegate;

@property (nonatomic, assign) ViewModelState state;

- (void)updateWithCompletion:(void(^)(BOOL))completion;

- (void)refreshWithCompletion:(void(^)(BOOL))completion;

- (void)loadMoreWithCompletion:(void(^)(BOOL))completion;

- (void)markState:(ViewModelState)state completion:(void(^)(void))completion;

- (void)didBindViewController;

- (void)reload:(BOOL)animated;

- (BaseSectionModel *)sectionModelAtIndex:(NSInteger)index;

- (id<BaseCellModel>)cellModelAtIndexPath:(NSIndexPath *)indexPath;


//need override
- (NSArray<BaseSectionModel *> *) newSectionModels;

- (void)loadData;

@end
