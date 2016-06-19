//
//  ViewController.m
//  VKSafariDomainBridge
//
//  Created by Awhisper on 16/5/11.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "ViewController.h"
#import "VKSafariDomainBridge.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"xxx://xxx.xxx.xxx/xxx.xxx"];
    [VKSafariDomainBridge VKSetupSafariBridgeUrl:url AndKey:@"safari"];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [[VKSafariDomainBridge VKSingleton]VKGetSafariInfo:^(BOOL success, NSString *info) {
        NSLog(@"%@ status = %@",info,@(success));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
