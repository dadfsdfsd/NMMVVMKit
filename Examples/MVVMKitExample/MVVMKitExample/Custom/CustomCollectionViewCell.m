//
//  CustomCollectionViewCell.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/8.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import "CustomCellModel.h"
#import "NSObject+ObservationManager.h"
#import <ReactiveObjC.h>

@interface CustomCollectionViewCell()

@property (nonatomic, strong) YYLabel *titleLabe;

@property (nonatomic, strong) UIButton *button;

@end

@implementation CustomCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _titleLabe = ({
        YYLabel *label = [YYLabel new];
        label;
    });
    
    _button = ({
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:@"doChangeContent" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(doChangeContent) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1;
    
    [self.contentView addSubview:_titleLabe];
    [self.contentView addSubview:_button];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _button.centerX = self.contentView.bounds.size.width/2;
}

- (void)bindCellModel:(id)cellModel {
    [[self observationManager] unobserveAll];
    
    CustomCellModel *customCellModel = (CustomCellModel *)cellModel;

//    [_button rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    if ([customCellModel isKindOfClass:[CustomCellModel class]]) {
        
        _button.frame = CGRectMake(0, customCellModel.buttonPadding, customCellModel.buttonSize.width, customCellModel.buttonSize.height);
        _button.centerX = self.contentView.bounds.size.width/2;
        
        __weak __typeof(self) weakSelf = self;
        
        [[self observationManager] observe:[[DynamicObservable<YYTextLayout *> alloc] initWithTarget:customCellModel keyPath:@"textLayout" shouldRetainTarget:true] withEventHandler:^(ValueChange<YYTextLayout *> *change) {
            weakSelf.titleLabe.frame = CGRectMake(customCellModel.textContentPadding, customCellModel.textContentPadding + _button.bottom, customCellModel.textLayout.textBoundingSize.width, customCellModel.textLayout.textBoundingSize.height);
            weakSelf.titleLabe.textLayout = customCellModel.textLayout;
        }];
        
        _titleLabe.frame = CGRectMake(customCellModel.textContentPadding, customCellModel.textContentPadding + _button.bottom, customCellModel.textLayout.textBoundingSize.width, customCellModel.textLayout.textBoundingSize.height);
        _titleLabe.textLayout = customCellModel.textLayout;
        
        [[self observationManager] observe:[[DynamicObservable<UIColor *> alloc] initWithTarget:customCellModel keyPath:@"data.backgroundColor" shouldRetainTarget:true] withEventHandler:^(ValueChange<UIColor *> *change) {
            UIColor *newColor = change.nValue;
            weakSelf.backgroundColor = newColor;
        }];
        self.backgroundColor = customCellModel.data.backgroundColor;
    }
}

- (void)doChangeContent {
    CustomCellModel *customCellModel = (CustomCellModel *)self.cellModel;
    [customCellModel doChangeContent];
}

@end
