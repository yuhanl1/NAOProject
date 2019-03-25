//
//  RobotSay.h
//  NAOMonitor
//
//  Created by LiuYuHan on 11/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

@interface RobotSay : UITableViewController<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *aButton;
@property (nonatomic, assign) int font;
@property (nonatomic, copy) NSString *ipAdress;
@property (nonatomic, assign) UInt16 port;
@property (nonatomic,assign) int clientSocket;
@property (nonatomic,assign) int result;

@end
