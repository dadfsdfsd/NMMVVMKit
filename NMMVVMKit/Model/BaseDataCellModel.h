//
//  BaseDataCellModel.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCellModel.h"
#import <IGListKit/IGListKit.h>

@interface BaseDataCellModel<__covariant DataType: id<IGListDiffable>> : BaseCellModel

@property (nonatomic, strong) DataType data;

- (instancetype)initWithData:(DataType)data;

- (void)didLoadData;

@end
