//
//  NMSectionModel.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "NMSectionModel.h"

@implementation NMSectionModel

+ (instancetype)sectionModelWithCellModels:(NSArray<id<NMCellModel>> *)cellModels {
    return [[self alloc] initWithCellModels:cellModels];
}

- (instancetype)initWithCellModels:(NSArray<id<NMCellModel>> *)cellModels {
    if (self = [super init]) {
        self.cellModels = cellModels;
    }
    return self;
}

- (void)setCellModels:(NSArray<id<NMCellModel>> *)cellModels {
    _cellModels = cellModels;
    [_cellModels enumerateObjectsUsingBlock:^(id<NMCellModel> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.container = self;
    }];
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if (object == self) {
        return true;
    }
    NMSectionModel *sectionModel = (NMSectionModel *)object;
    if ([sectionModel isKindOfClass:[NMSectionModel class]]) {
        BOOL(^isHeaderCellEqual)(void) = ^(void) {
            return (BOOL)([sectionModel.headerCell isEqualToDiffableObject:self.headerCell] || (sectionModel.headerCell == nil && self.headerCell == nil));
        };
        
        BOOL(^isFooterCellEqual)(void) = ^(void) {
            return (BOOL)([sectionModel.footerCell isEqualToDiffableObject:self.footerCell] || (sectionModel.footerCell == nil && self.footerCell == nil));
        };
 
        BOOL(^isCellsEqual)(void) = ^(void) {
            BOOL result = sectionModel.cellModels.count == self.cellModels.count;
            if (result) {
                for (NSInteger i = 0; i < self.cellModels.count; i++) {
                    if (![self.cellModels[i] isEqualToDiffableObject:sectionModel.cellModels[i]]) {
                        result = false;
                        break;
                    }
                }
            }
            return result;
        };
        
        return isHeaderCellEqual() && isFooterCellEqual() && isCellsEqual();
    }
    return false;
}

-(void)updateAnimated:(BOOL)animated onlySize:(BOOL)onlySize {
    [_delegate updateAnimated:animated onlySize:onlySize];
}

- (id<NSObject>)diffIdentifier {
    if (_diffIdentifier) {
        return _diffIdentifier;
    }
    return self;
}

- (void)didExitWorkingRange {
    
}

- (void)willEnterWorkingRange {
    
}

@end
