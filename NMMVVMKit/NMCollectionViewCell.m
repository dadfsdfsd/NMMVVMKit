//
//  NMCollectionViewCell.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/8.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "NMCollectionViewCell.h"

@interface NMCollectionViewCell ()<IGListBindable>

@end

@implementation NMCollectionViewCell

- (void)bindCellModel:(id)cellModel {
    
}


- (void)bindViewModel:(id)viewModel {
   _cellModel = viewModel;
    [self bindCellModel:_cellModel];
}

@end








