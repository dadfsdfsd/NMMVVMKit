//
//  BaseCellModel.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>

@protocol BaseCellModelContainer<NSObject>

-(void)updateAnimated:(BOOL)animated onlySize:(BOOL)onlySize;

@end

@protocol BaseCellModel<NSObject, IGListDiffable>

+ (NSString *)cellIdentifier;

- (CGSize)calculateSizeForContainerWidth:(CGFloat) containerWidth;

- (CGSize)expectedSizeForContainerWidth:(CGFloat) containerWidth;

- (id<BaseCellModelContainer>)container;

- (void)setContainer:(id<BaseCellModelContainer>)container;

@end


@interface BaseCellModel : NSObject<BaseCellModel>

@property (nonatomic, assign, readonly) CGSize cachedSize;

@property (nonatomic, weak) id<BaseCellModelContainer> container;

- (void)clearCachedSize;

+ (NSString *)cellIdentifier;

//need override
- (CGSize)calculateSizeForContainerWidth:(CGFloat) containerWidth;

- (CGSize)expectedSizeForContainerWidth:(CGFloat) containerWidth;


@end





