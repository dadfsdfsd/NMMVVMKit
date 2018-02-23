//
//  CustomData.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/8.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListKit.h>

@interface CustomSectionData : NSObject<IGListDiffable>

@property (nonatomic, copy) NSArray* items;

@end

@interface CustomData : NSObject<IGListDiffable>

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSString *content;

@end
