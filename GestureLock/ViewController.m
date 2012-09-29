//
//  ViewController.m
//  GestureLock
//
//  Created by 王鹏 on 12-9-28.
//  Copyright (c) 2012年 pengjay.cn@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "PPLockView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	PPLockView *lockView = [[PPLockView alloc]initWithFrame:self.view.bounds];
	[self.view addSubview:lockView];
	[lockView release];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
