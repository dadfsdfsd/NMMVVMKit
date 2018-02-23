//
//  AnonymousSectionController.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/8.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListKit.h>
#import "BaseSectionModel.h"

@interface BaseSectionController : IGListBindingSectionController<id<BaseCellModel>><IGListBindingSectionControllerDataSource>

- (instancetype)initWithCellModelToCell:(NSDictionary<NSString *, Class> *)dictionary selectionDelegate:(id<IGListBindingSectionControllerSelectionDelegate>)delegate;

@property(nonatomic, strong, readonly) NSDictionary<NSString*, Class>* cellModel2Cell;

@end
