//
//  ViewController.m
//  MVVMKitExample
//
//  Created by yangfan on 2018/2/23.
//  Copyright © 2018年 yangfan. All rights reserved.
//

#import "ViewController.h"
#import "CustomCollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:[CustomCollectionViewController new] animated:false completion:nil];
    });
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
