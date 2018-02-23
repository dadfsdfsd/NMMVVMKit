//
//  BaseControllerCollectionViewCell.h
//  MyIpadDemo
//
//  Created by 杨帆 on 2018/2/22.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVVMViewController.h"
#import "BaseCollectionViewCell.h"

@interface BaseControllerCollectionViewCell : BaseCollectionViewCell

//need override
- (Class)viewControllerClass;

@end
