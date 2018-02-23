//
//  NMSectionModel.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>
#import "NMCellModel.h"

@protocol NMSectionModelDelegate

-(void)updateAnimated:(BOOL)animated onlySize:(BOOL)onlySize;

@end

@interface NMSectionModel : NSObject<IGListDiffable, NMCellModelContainer>

@property (nonatomic, weak) id<NMSectionModelDelegate> delegate;

@property (nonatomic, strong) NSArray<id<NMCellModel>>* cellModels;

@property (nonatomic, strong) id<NSObject> diffIdentifier;

@property (nonatomic, assign) UIEdgeInsets inset;

@property (nonatomic, assign) CGFloat minimumLineSpacing;

@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

@property (nonatomic, strong) id<NMCellModel> headerCell;

@property (nonatomic, strong) id<NMCellModel> footerCell;

+ (instancetype)sectionModelWithCellModels:(NSArray<id<NMCellModel>> *)cellModels;

- (void)didExitWorkingRange;

- (void)willEnterWorkingRange;

@end
