//
//  NMDataCellModel.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMCellModel.h"
#import <IGListKit/IGListKit.h>

@interface NMDataCellModel<__covariant DataType: id<IGListDiffable>> : NMCellModel

@property (nonatomic, strong) DataType data;

- (instancetype)initWithData:(DataType)data;

- (void)didLoadData;

@end
