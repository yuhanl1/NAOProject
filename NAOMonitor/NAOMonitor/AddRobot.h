//
//  AddRobot.h
//  NAOMonitor
//
//  Created by LiuYuHan on 6/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "valuePass.h"


@interface AddRobot : UITableViewController<UITextFieldDelegate>

@property (nonatomic,strong) UIBarButtonItem * doneButton;
@property (nonatomic, strong) UITextField * name;
@property (nonatomic, strong) UITextField * ip;
@property (nonatomic, strong) UITextField * port;

@property (weak, nonatomic) id delegate;

@end
