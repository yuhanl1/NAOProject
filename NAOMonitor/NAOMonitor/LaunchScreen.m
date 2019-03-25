//
//  LaunchScreen.m
//  NAOMonitor
//
//  Created by LiuYuHan on 10/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "LaunchScreen.h"

@interface LaunchScreen ()

@end

@implementation LaunchScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"/ICON/LaunchScreen1242.png"]];
    [self.view addSubview:imageView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
