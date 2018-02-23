//
//  BaseCollectionViewCell.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/8.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@interface BaseCollectionViewCell ()<IGListBindable>

@end

@implementation BaseCollectionViewCell

- (void)bindCellModel:(id)cellModel {
    
}


- (void)bindViewModel:(id)viewModel {
   _cellModel = viewModel;
    [self bindCellModel:_cellModel];
}

@end








