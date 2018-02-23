//
//  NMCollectionViewCell.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/8.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>
#import "NMCellModel.h"

@interface NMCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) id cellModel;

@property (nonatomic, weak) id delegate;

- (void)bindCellModel:(id)cellModel;

@end











