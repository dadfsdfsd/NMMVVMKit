//
//  AnonymousSectionController.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/8.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "NMSectionController.h"
#import "NMCollectionViewCell.h"

typedef NS_ENUM(NSInteger, IGListDiffingSectionState) {
    IGListDiffingSectionStateIdle = 0,
    IGListDiffingSectionStateUpdateQueued,
    IGListDiffingSectionStateUpdateApplied
};


@interface IGListBindingSectionController()<IGListSupplementaryViewSource, IGListWorkingRangeDelegate, NMSectionModelDelegate>

@property (nonatomic, strong, readwrite) NSArray<id<IGListDiffable>> *viewModels;

@property (nonatomic, strong) id object;

@property (nonatomic, assign) IGListDiffingSectionState state;

@end

@implementation NMSectionController

- (void)updateAnimated:(BOOL)animated onlySize:(BOOL)onlySize {
    if (onlySize) {
        [self.collectionContext performBatchAnimated:animated updates:^(id<IGListBatchContext>  _Nonnull batchContext) {
        } completion:nil];
    }
    else {
        [self updateAnimated:animated completion:nil];
    }
}

- (void)updateAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    IGAssertMainThread();

    if (self.state != IGListDiffingSectionStateIdle) {
        if (completion != nil) {
            completion(NO);
        }
        return;
    }
    self.state = IGListDiffingSectionStateUpdateQueued;

    __block IGListIndexSetResult *result = nil;
    __block NSArray<id<IGListDiffable>> *oldViewModels = nil;

    id<IGListCollectionContext> collectionContext = self.collectionContext;
    [self.collectionContext performBatchAnimated:animated updates:^(id<IGListBatchContext> batchContext) {
        if (self.state != IGListDiffingSectionStateUpdateQueued) {
            return;
        }

        oldViewModels = self.viewModels;

        id<IGListDiffable> object = self.object;
        IGAssert(object != nil, @"Expected IGListBindingSectionController object to be non-nil before updating.");

        NSArray *viewModels = [self.dataSource sectionController:self viewModelsForObject:object];
        result = IGListDiff(oldViewModels, viewModels, IGListDiffEquality);

        NSMutableArray *tmpViewModels = [NSMutableArray arrayWithArray:oldViewModels];

        [result.updates enumerateIndexesUsingBlock:^(NSUInteger oldUpdatedIndex, BOOL *stop) {
            id identifier = [oldViewModels[oldUpdatedIndex] diffIdentifier];
            const NSInteger indexAfterUpdate = [result newIndexForIdentifier:identifier];
            if (indexAfterUpdate != NSNotFound) {
                UICollectionViewCell<IGListBindable> *cell = [collectionContext cellForItemAtIndex:oldUpdatedIndex sectionController:self];
                [cell bindViewModel:viewModels[indexAfterUpdate]];
                [tmpViewModels replaceObjectAtIndex:oldUpdatedIndex withObject:viewModels[indexAfterUpdate]];
            }
        }];

        NSMutableArray *needMoveObjects = [NSMutableArray new];
        NSMutableIndexSet *needMoveIndexs = [NSMutableIndexSet new];
        [result.moves enumerateObjectsUsingBlock:^(IGListMoveIndex * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [needMoveObjects addObject:tmpViewModels[obj.from]];
            [needMoveIndexs addIndex:obj.to];
        }];

        [tmpViewModels removeObjectsAtIndexes:result.deletes];

        NSMutableArray *needInsertObjects = [NSMutableArray new];
        [result.inserts enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            [needInsertObjects addObject:viewModels[idx]];
        }];
        [tmpViewModels insertObjects:needInsertObjects atIndexes:result.inserts];

        [tmpViewModels replaceObjectsAtIndexes:needMoveIndexs withObjects:needMoveObjects];

        self.viewModels = [tmpViewModels copy];

        [batchContext deleteInSectionController:self atIndexes:result.deletes];
        [batchContext insertInSectionController:self atIndexes:result.inserts];

        for (IGListMoveIndex *move in result.moves) {
            [batchContext moveInSectionController:self fromIndex:move.from toIndex:move.to];
        }

        self.state = IGListDiffingSectionStateUpdateApplied;
    } completion:^(BOOL finished) {
        self.state = IGListDiffingSectionStateIdle;
        if (completion != nil) {
            completion(YES);
        }
    }];
}

- (instancetype)initWithCellModelToCell:(NSDictionary<NSString *, Class> *)dictionary selectionDelegate:(id<IGListBindingSectionControllerSelectionDelegate>)delegate {
    if (self = [super init]) {
        _cellModel2Cell = dictionary;
        self.dataSource = self;
        self.supplementaryViewSource = self;
        self.selectionDelegate = delegate;
        self.workingRangeDelegate = self;
    }
    return self;
}

- (nonnull UICollectionViewCell<IGListBindable> *)sectionController:(nonnull IGListBindingSectionController *)sectionController cellForViewModel:(nonnull id)viewModel atIndex:(NSInteger)index {
    id<NMCellModel> cellModel = (id<NMCellModel>)viewModel;
    NMCollectionViewCell *collectionViewCell = [self.collectionContext dequeueReusableCellOfClass:_cellModel2Cell[[cellModel.class cellIdentifier]] forSectionController:self atIndex:index];
    collectionViewCell.delegate = self;
    return (UICollectionViewCell<IGListBindable> *)collectionViewCell;
}

- (CGSize)sectionController:(nonnull IGListBindingSectionController *)sectionController sizeForViewModel:(nonnull id)viewModel atIndex:(NSInteger)index {
    if ([self.object isKindOfClass:[NMSectionModel class]]) {
        NMSectionModel *sectionModel = (NMSectionModel *)self.object;
        id<NMCellModel> cellModel = (id<NMCellModel>)viewModel;
        return [cellModel expectedSizeForContainerWidth:self.collectionContext.containerSize.width - sectionModel.inset.left - sectionModel.inset.right];
    }
    return CGSizeZero;
}

- (nonnull NSArray<id<IGListDiffable>> *)sectionController:(nonnull IGListBindingSectionController *)sectionController viewModelsForObject:(nonnull id)object {
    if ([object isKindOfClass:[NMSectionModel class]]) {
        NMSectionModel *sectionModel = (NMSectionModel *)object;
        return sectionModel.cellModels;
    }
    return [NSArray<id<IGListDiffable>> new];
}

- (void)didUpdateToObject:(id)object {
    id oldObject = self.object;
    self.object = object;
    
    if (oldObject == nil) {
        self.viewModels = [self.dataSource sectionController:self viewModelsForObject:object];
    } else {
        if ([self.object conformsToProtocol:@protocol(IGListDiffable)] && [oldObject conformsToProtocol:@protocol(IGListDiffable)]) {
            id<IGListDiffable> diffableObject = self.object;
            id<IGListDiffable> diffableOldObject = oldObject;
            if (![diffableObject isEqualToDiffableObject:diffableOldObject]) {
                 [self updateAnimated:YES completion:nil];
            }
        }
        else {
            [self updateAnimated:YES completion:nil];
        }
    }
    if ([object isKindOfClass:[NMSectionModel class]]) {
        NMSectionModel *sectionModel = (NMSectionModel *)object;
        sectionModel.delegate = self;
        self.inset = sectionModel.inset;
        self.minimumInteritemSpacing = sectionModel.minimumInteritemSpacing;
        self.minimumLineSpacing = sectionModel.minimumLineSpacing;
    }
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind atIndex:(NSInteger)index {
    if ([self.object isKindOfClass:[NMSectionModel class]]) {
        NMSectionModel *sectionModel = (NMSectionModel *)self.object;
        if (elementKind == UICollectionElementKindSectionHeader && sectionModel.headerCell != nil) {
            return [sectionModel.headerCell expectedSizeForContainerWidth:self.collectionContext.containerSize.width - sectionModel.inset.left - sectionModel.inset.right];
        }
        else if (elementKind == UICollectionElementKindSectionFooter && sectionModel.footerCell != nil) {
            return [sectionModel.footerCell expectedSizeForContainerWidth:self.collectionContext.containerSize.width - sectionModel.inset.left - sectionModel.inset.right];
        }
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind atIndex:(NSInteger)index {
    if ([self.object isKindOfClass:[NMSectionModel class]]) {
        NMSectionModel *sectionModel = (NMSectionModel *)self.object;
        if (elementKind == UICollectionElementKindSectionHeader && sectionModel.headerCell != nil) {
            NMCollectionViewCell *cell = [self.collectionContext dequeueReusableSupplementaryViewOfKind:elementKind forSectionController:self class:_cellModel2Cell[[sectionModel.headerCell.class cellIdentifier]] atIndex:index];
            [cell bindCellModel:sectionModel.headerCell];
            return cell;
        }
        else if (elementKind == UICollectionElementKindSectionFooter && sectionModel.footerCell != nil) {
            NMCollectionViewCell *cell = [self.collectionContext dequeueReusableSupplementaryViewOfKind:elementKind forSectionController:self class:_cellModel2Cell[[sectionModel.footerCell.class cellIdentifier]] atIndex:index];
            [cell bindCellModel:sectionModel.footerCell];
            return cell;
        }
    }
    return nil;
}

- (NSArray<NSString *> *)supportedElementKinds {
    if ([self.object isKindOfClass:[NMSectionModel class]]) {
        NSMutableArray<NSString *> *supportedElementKinds = [NSMutableArray<NSString *> new];
        NMSectionModel *sectionModel = (NMSectionModel *)self.object;
        if (sectionModel.headerCell != nil) {
            [supportedElementKinds addObject:UICollectionElementKindSectionHeader];
        }
        if (sectionModel.footerCell != nil) {
            [supportedElementKinds addObject:UICollectionElementKindSectionFooter];
        }
        return supportedElementKinds;
    }
    return @[];
}

- (void)listAdapter:(IGListAdapter *)listAdapter sectionControllerDidExitWorkingRange:(IGListSectionController *)sectionController {
    if ([self.object isKindOfClass:[NMSectionModel class]]) {
        NMSectionModel *sectionModel = (NMSectionModel *)self.object;
        [sectionModel willEnterWorkingRange];
    }
}

-(void)listAdapter:(IGListAdapter *)listAdapter sectionControllerWillEnterWorkingRange:(IGListSectionController *)sectionController {
    if ([self.object isKindOfClass:[NMSectionModel class]]) {
        NMSectionModel *sectionModel = (NMSectionModel *)self.object;
        [sectionModel didExitWorkingRange];
    }
}


@end
