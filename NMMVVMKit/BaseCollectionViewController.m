//
//  BaseCollectionViewController.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "BaseViewModel.h"
#import "BaseSectionController.h"
#import <MJRefresh/MJRefresh.h>


@interface BaseCollectionViewController()<IGListAdapterDataSource, IGListAdapterDelegate, UICollectionViewDelegate, BaseViewModelDelegate, IGListBindingSectionControllerSelectionDelegate>

@property (nonatomic, strong) IGListAdapter *listAdapter;

@property (nonatomic, assign) BOOL needsUpdate;

@property (nonatomic, assign) BOOL needsRefresh;

@property (nonatomic, strong) NSArray<BaseSectionModel *> *tmpDatas;

@property (nonatomic, strong) BaseViewModel *viewModelToBind;

@end

@implementation BaseCollectionViewController {
    
    BaseViewModel *_viewModel;
    
}


- (void)loadView {
    [super loadView];
    
    _collectionView = [self loadCollectionView];
    _listAdapter = [self loadListAdapter];
    self.view = self.collectionView;
    
    [self checkLoadMoreEnabled];
    [self checkRefreshHeaderEnabled];
}

- (IGListAdapter *)loadListAdapter {
    IGListAdapter *listAdapter = [[IGListAdapter alloc] initWithUpdater:[IGListAdapterUpdater new] viewController:self];
    listAdapter.dataSource = self;
    listAdapter.delegate = self;
    listAdapter.collectionView = _collectionView;
    listAdapter.scrollViewDelegate = self;
    listAdapter.collectionViewDelegate = self;
    return listAdapter;
}

- (BaseViewModel *)loadViewModel {
    return nil;
}

- (UICollectionView*)loadCollectionView {
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self loadCollectionLayout]];
    collectionView.backgroundColor = [UIColor whiteColor];
    return collectionView;
}

- (UICollectionViewLayout*)loadCollectionLayout {
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return layout;
}

- (BOOL)isRefreshEnabled {
    return false;
}

- (BOOL)isLoadMoreEnabled {
    return false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_viewModelToBind) {
        [self bindViewModel:_viewModelToBind];
    }
    else {
        [self bindViewModel:[self loadViewModel]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _isAppearing = true;
    
    // Priority: Refresh > Update > Reload
    if (_needsRefresh) {
        _needsUpdate = false;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self beginRefreshing];
        });
    }
    else if (_needsUpdate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self beginUpdating];
        });
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _isAppearing = false;
}

- (NSDictionary<NSString *,Class> *)cellModel2Cell {
    return nil;
}

- (void)setViewModel:(BaseViewModel *)viewModel {
    if (self.isViewLoaded) {
        [self bindViewModel:viewModel];
    }
    else {
        _viewModelToBind = viewModel;
    }
}

- (BaseViewModel *)viewModel {
    if (_viewModelToBind) {
        return _viewModelToBind;
    }
    return _viewModel;
}

- (void)bindViewModel:(BaseViewModel *)viewModel {
    [self view];
    if (_viewModel == viewModel) {
        return;
    }
    
    if (_viewModel) {
        [_viewModel removeObserver:self forKeyPath:@"state"];
    }
    if (viewModel) {
        [viewModel addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    _viewModel = viewModel;
    _viewModelToBind = nil;
    _viewModel.delegate = self;
    [_viewModel didBindViewController];
}

- (void)dealloc {
    [_viewModel removeObserver:self forKeyPath:@"state"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        switch (_viewModel.state) {
            case ViewModelStateIdle:
                [self endLoadingMore];
                [self endRefreshing];
                break;
            case ViewModelStateError:
                [self endLoadingMore];
                [self endRefreshing];
                break;
            case ViewModelStateUpdating:
                [self endRefreshing];
                break;
            case ViewModelStateRefreshing:
                [self endLoadingMore];
                break;
            case ViewModelStateLoadingMore:
                [self endRefreshing];
                break;
            default:
                break;
        }
    }
}

- (nullable UIView *)emptyViewForListAdapter:(nonnull IGListAdapter *)listAdapter {
    return nil;
}

- (nonnull IGListSectionController *)listAdapter:(nonnull IGListAdapter *)listAdapter sectionControllerForObject:(nonnull id)object {
    return [[BaseSectionController alloc] initWithCellModelToCell:[self cellModel2Cell] selectionDelegate:self];
}

- (nonnull NSArray<id<IGListDiffable>> *)objectsForListAdapter:(nonnull IGListAdapter *)listAdapter {
    _tmpDatas = [_viewModel newSectionModels];
    return _tmpDatas;
}

- (void)checkRefreshHeaderEnabled{
    if ([self isRefreshEnabled]) {
        if (_collectionView.mj_header == nil) {
            __weak __typeof(self) weakSelf = self;
            _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf.viewModel refreshWithCompletion:nil];
            }];
        }
    }
    else {
        _collectionView.mj_header = nil;
    }
}

- (void)checkLoadMoreEnabled {
    if ([self isLoadMoreEnabled]) {
        if (_collectionView.mj_footer == nil) {
            __weak __typeof(self) weakSelf = self;
            _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf.viewModel loadMoreWithCompletion:nil];
            }];
        }
    }
    else {
        _collectionView.mj_footer = nil;
    }
}

- (void)endLoadingMore {
    if ([_collectionView.mj_footer isRefreshing]) {
        [_collectionView.mj_footer endRefreshing];
    }
}

- (void)endRefreshing {
    if ([_collectionView.mj_header isRefreshing]) {
        [_collectionView.mj_header endRefreshing];
    }
}

- (void)reload:(BOOL)animated completion:(BaseViewModelUpdaterCompletion)completion {
    [self checkLoadMoreEnabled];
    [self checkRefreshHeaderEnabled];
    
    [_listAdapter performUpdatesAnimated:animated completion:^(BOOL finished) {
        if (finished) {
            NSArray<BaseSectionModel *> *sectionModels = [_tmpDatas copy];
            [[_listAdapter objects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BaseSectionController *sectionController =  (BaseSectionController *)[_listAdapter sectionControllerForObject:obj];
                if ([sectionController isKindOfClass:[BaseSectionController class]] && idx < sectionModels.count) {
                    sectionModels[idx].cellModels = [sectionController.viewModels copy];
                }
                else {
                    NSLog(@"Error: SectionController must be kind of BaseSectionController or unknown error");
                }
            }];
            completion(true, sectionModels);
        }
        else {
            completion(false, nil);
        }
    }];
}

- (void)setNeedsRefresh {
    if (_isAppearing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self beginRefreshing];
        });
    }
    else {
        _needsRefresh = true;
    }
}

- (void)beginRefreshing {
    _needsRefresh = false;
    [_collectionView.mj_header beginRefreshing];
}

- (void)beginUpdating {
    _needsUpdate = false;
    [_viewModel updateWithCompletion:nil];
}

- (void)setNeedsUpdate {
    if (_isAppearing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self beginUpdating];
        });
    }
    else {
        _needsUpdate = true;
    }
}

- (void)sectionController:(nonnull IGListBindingSectionController *)sectionController didSelectItemAtIndex:(NSInteger)index viewModel:(nonnull id)viewModel {
}


- (void)listAdapter:(nonnull IGListAdapter *)listAdapter didEndDisplayingObject:(nonnull id)object atIndex:(NSInteger)index {
    
}

- (void)listAdapter:(nonnull IGListAdapter *)listAdapter willDisplayObject:(nonnull id)object atIndex:(NSInteger)index {
    
}


@end
