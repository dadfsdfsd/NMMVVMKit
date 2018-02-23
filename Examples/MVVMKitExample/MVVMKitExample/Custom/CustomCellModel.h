//
//  CustomCellModel.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/8.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "NMDataCellModel.h"
#import "CustomData.h"
#import <YYKit.h>

@interface CustomCellModel : NMDataCellModel<CustomData *>

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) YYTextLayout *textLayout;

@property (nonatomic, assign) CGFloat textContentPadding;

@property (nonatomic, assign) CGFloat buttonPadding;

@property (nonatomic, assign) CGSize buttonSize;

- (void)doChangeContent;

@end
