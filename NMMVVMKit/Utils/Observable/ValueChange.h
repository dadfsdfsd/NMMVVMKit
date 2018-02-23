//
//  ValueChange.h
//  MyIpadDemo
//
//  Created by yangfan on 2018/1/31.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValueChange<Value>: NSObject

@property (nonatomic, strong) Value oValue;

@property (nonatomic, strong) Value nValue;

-(instancetype)initWithNewValue:(Value)newValue oldValue:(Value)oldValue;

@end


