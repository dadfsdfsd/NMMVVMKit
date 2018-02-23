//
//  CustomCellModel.m
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/8.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "CustomCellModel.h"
#import "NSObject+ObservationManager.h"
#import <YYKit.h>

@implementation CustomCellModel

- (void)didLoadData {
    _textContentPadding = 10;
    _buttonPadding = 10;
    _buttonSize = CGSizeMake(200, 50);
    
    [self.observationManager unobserveAll];
    __weak __typeof(self) weakSelf = self;
    [self.observationManager observe:[[DynamicObservable alloc] initWithTarget:self.data keyPath:@"content"] withEventHandler:^(ValueChange *change) {
        [weakSelf refreshLayoutForWidth: self.cachedSize.width];
        [weakSelf clearCachedSize];
        [weakSelf.container updateAnimated:false onlySize:true];
    }];
}

- (CGSize)calculateSizeForContainerWidth:(CGFloat)containerWidth {
//    return CGSizeMake((containerSize.width - 40)/1, (containerSize.width - 40)/1);
    [self refreshLayoutForWidth:containerWidth];
    return CGSizeMake(containerWidth, _textLayout.textBoundingSize.height + 2.0 * _textContentPadding + _buttonSize.height + 2.0 * _buttonPadding);
}

- (void)refreshLayoutForWidth:(CGFloat)width {
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(width - 2 * _textContentPadding, 99999)];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:self.data.content];
    [attrText setFont:[UIFont systemFontOfSize:12]];
    [attrText setColor:[UIColor blackColor]];
    self.textLayout = [YYTextLayout layoutWithContainer:container text:attrText];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.data.backgroundColor = backgroundColor;
}

- (void)doChangeContent {
    self.data.content = @"一个新的字符串";
}



@end
