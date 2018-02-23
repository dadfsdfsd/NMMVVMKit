//
//  NMViewModel.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMSectionModel.h"

typedef NS_ENUM (NSInteger, ViewModelState) {
    ViewModelStateIdle,
    ViewModelStateError,
    ViewModelStateRefreshing,
    ViewModelStateLoadingMore,
    ViewModelStateUpdating
};

typedef void (^NMViewModelUpdaterCompletion)(BOOL finished, NSArray<NMSectionModel *> *sectionModels);

@protocol NMViewModelDelegate

@required

- (void)reload:(BOOL)animated completion:(NMViewModelUpdaterCompletion)completion;

- (void)setNeedsUpdate;

- (void)setNeedsRefresh;

@end

@interface NMViewModel : NSObject

@property(nonatomic, strong, readonly) NSArray<NMSectionModel *> *sectionModels;

@property(nonatomic, weak) id<NMViewModelDelegate> delegate;

@property (nonatomic, assign) ViewModelState state;

- (void)updateWithCompletion:(void(^)(BOOL))completion;

- (void)refreshWithCompletion:(void(^)(BOOL))completion;

- (void)loadMoreWithCompletion:(void(^)(BOOL))completion;

- (void)markState:(ViewModelState)state completion:(void(^)(void))completion;

- (void)didBindViewController;

- (void)reload:(BOOL)animated;

- (NMSectionModel *)sectionModelAtIndex:(NSInteger)index;

- (id<NMCellModel>)cellModelAtIndexPath:(NSIndexPath *)indexPath;


//need override
- (NSArray<NMSectionModel *> *) newSectionModels;

- (void)loadData;

@end
