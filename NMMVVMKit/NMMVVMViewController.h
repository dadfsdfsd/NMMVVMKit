//
//  NMMVVMViewController.h
//  MyIpadDemo
//
//  Created by 杨帆 on 2018/2/22.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMViewModel.h"

@protocol NMMVVMViewController<NSObject>

- (void)bindViewModel:(NMViewModel *)viewModel;

@end
