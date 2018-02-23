//
//  BaseCollectionViewController.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>
#import "BaseViewModel.h"
#import "MVVMViewController.h"
#import <KVOController/KVOController.h>


@interface BaseCollectionViewController<__covariant ViewModelType: BaseViewModel *> : UIViewController<MVVMViewController>

@property (nonatomic, strong) ViewModelType viewModel;

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@property (nonatomic, assign, readonly) BOOL isAppearing;

- (UICollectionViewLayout *)loadCollectionLayout;

- (UICollectionView *)loadCollectionView;

- (void)bindViewModel:(ViewModelType)viewModel;

- (IGListAdapter *)loadListAdapter;

//need override
- (ViewModelType)loadViewModel;

- (BOOL)isRefreshEnabled;

- (BOOL)isLoadMoreEnabled;

- (void)beginRefreshing;

- (void)beginUpdating;

- (NSDictionary<NSString *, Class> *) cellModel2Cell;

@end
