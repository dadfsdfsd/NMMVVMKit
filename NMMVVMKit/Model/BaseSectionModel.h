//
//  BaseSectionModel.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>
#import "BaseCellModel.h"

@protocol BaseSectionModelDelegate

-(void)updateAnimated:(BOOL)animated onlySize:(BOOL)onlySize;

@end

@interface BaseSectionModel : NSObject<IGListDiffable, BaseCellModelContainer>

@property (nonatomic, weak) id<BaseSectionModelDelegate> delegate;

@property (nonatomic, strong) NSArray<id<BaseCellModel>>* cellModels;

@property (nonatomic, strong) id<NSObject> diffIdentifier;

@property (nonatomic, assign) UIEdgeInsets inset;

@property (nonatomic, assign) CGFloat minimumLineSpacing;

@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

@property (nonatomic, strong) id<BaseCellModel> headerCell;

@property (nonatomic, strong) id<BaseCellModel> footerCell;

+ (instancetype)sectionModelWithCellModels:(NSArray<id<BaseCellModel>> *)cellModels;

- (void)didExitWorkingRange;

- (void)willEnterWorkingRange;

@end
