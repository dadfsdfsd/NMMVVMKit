//
//  BaseControllerCollectionViewCell.m
//  MyIpadDemo
//
//  Created by 杨帆 on 2018/2/22.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "BaseControllerCollectionViewCell.h"

@implementation BaseControllerCollectionViewCell {
    
    UIViewController<MVVMViewController> *viewControler;

}

- (Class)viewControllerClass {
    return [BaseCollectionViewCell class];
}

- (void)bindCellModel:(id)cellModel {
    if (viewControler == nil) {
        viewControler = [[self viewControllerClass] new];
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [(UIViewController *)self.delegate addChildViewController:viewControler];
        }
        [self addSubview:viewControler.view];
    }
    [viewControler bindViewModel:cellModel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    viewControler.view.frame = self.bounds;
}

@end
