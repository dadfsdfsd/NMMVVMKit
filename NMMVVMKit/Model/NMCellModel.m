//
//  NMCellModel.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/5.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "NMCellModel.h"

@interface NMCellModel ()

@property (nonatomic, assign) BOOL hasCalculatedSize;

@end

@implementation NMCellModel

+ (NSString *)cellIdentifier {
    return NSStringFromClass(self);
}

- (CGSize)expectedSizeForContainerWidth:(CGFloat)containerWidth {
    if (_hasCalculatedSize) {
        return _cachedSize;
    }
    _cachedSize = [self calculateSizeForContainerWidth:containerWidth];
    _hasCalculatedSize = true;
    return _cachedSize;
}

- (CGSize)calculateSizeForContainerWidth:(CGFloat)containerWidth {
    return CGSizeZero;
}

- (void)clearCachedSize {
    _hasCalculatedSize = false;
    _cachedSize = CGSizeZero;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return object == self;
}

- (id<NSObject>)diffIdentifier {
    return self;
}

@end
