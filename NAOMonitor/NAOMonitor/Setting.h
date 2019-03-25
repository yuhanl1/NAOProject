//
//  Setting.h
//  NAOMonitor
//
//  Created by LiuYuHan on 6/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

@interface Setting : UITableViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *sectionValue;
@property (nonatomic, strong) NSMutableArray *systemSettingArray;
@property (nonatomic, strong) NSMutableArray *systemSettingValue;
@property (nonatomic, strong) NSMutableArray *aboutArray;
@property (nonatomic, strong) NSMutableArray *aboutValue;
@property (nonatomic, strong) NSMutableArray *sectionLabel;

@property (nonatomic, strong) NSString *setVolume;
@property (nonatomic, strong) NSString *setResolution;
@property (nonatomic, strong) NSString *setFont;

@property (nonatomic, copy) NSString *ipAdress;
@property (nonatomic, assign) UInt16 port;
@property (nonatomic,assign) int clientSocket;
@property (nonatomic,assign) int result;

@property (nonatomic, assign) bool connectToServer;
@property (nonatomic, strong) UISwitch *aSwitch;

@end
