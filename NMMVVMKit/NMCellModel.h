//
//  NMCellModel.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>

@protocol NMCellModelContainer<NSObject>

-(void)updateAnimated:(BOOL)animated onlySize:(BOOL)onlySize;

@end

@protocol NMCellModel<NSObject, IGListDiffable>

+ (NSString *)cellIdentifier;

- (CGSize)calculateSizeForContainerWidth:(CGFloat) containerWidth;

- (CGSize)expectedSizeForContainerWidth:(CGFloat) containerWidth;

- (id<NMCellModelContainer>)container;

- (void)setContainer:(id<NMCellModelContainer>)container;

@end


@interface NMCellModel : NSObject<NMCellModel>

@property (nonatomic, assign, readonly) CGSize cachedSize;

@property (nonatomic, weak) id<NMCellModelContainer> container;

- (void)clearCachedSize;

+ (NSString *)cellIdentifier;

//need override
- (CGSize)calculateSizeForContainerWidth:(CGFloat) containerWidth;

- (CGSize)expectedSizeForContainerWidth:(CGFloat) containerWidth;


@end





