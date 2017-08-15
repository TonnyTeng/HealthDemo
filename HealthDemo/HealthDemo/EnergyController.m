//
//  EnergyController.m
//  HealthDemo
//
//  Created by dengtao on 2017/8/15.
//  Copyright © 2017年 JingXian. All rights reserved.
//

#import "EnergyController.h"
#import <HealthKit/HealthKit.h>
#import "HKHealthStore+AppleExtenstions.h"


@interface EnergyController ()

@property (nonatomic) HKHealthStore *healthStore;

@end

@implementation EnergyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"能量";
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(HKHealthStore *)healthStore{

    if (_healthStore == nil) {
        
        _healthStore = [[HKHealthStore alloc] init];
    }
    return _healthStore;
}

@end
