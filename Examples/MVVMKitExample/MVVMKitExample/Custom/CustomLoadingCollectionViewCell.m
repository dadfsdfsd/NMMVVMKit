//
//  CustomLoadingCollectionViewCell.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/26.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "CustomLoadingCollectionViewCell.h"

@implementation CustomLoadingCollectionViewCell {
    
    UIActivityIndicatorView *_loadingView;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubviews];
    }
    return self;
}

- (void)initializeSubviews {
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_loadingView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _loadingView.frame = self.bounds;
}

- (void)bindCellModel:(id)cellModel {
    [_loadingView startAnimating];
}

@end
