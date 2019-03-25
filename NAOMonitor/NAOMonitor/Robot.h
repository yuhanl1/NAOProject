//
//  Robot.h
//  NAOMonitor
//
//  Created by LiuYuHan on 6/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "valuePass.h"

@interface Robot : UITableViewController<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, valuePass>

@property (nonatomic,strong) UIBarButtonItem * editButton;
@property (nonatomic, strong) NSMutableArray * robotName;
@property (nonatomic, strong) NSMutableArray * robotIP;
@property (nonatomic, strong) NSMutableArray * robotPort;

@end
