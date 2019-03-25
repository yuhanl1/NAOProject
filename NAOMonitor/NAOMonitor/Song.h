//
//  Song.h
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

@interface Song : UITableViewController


@property (nonatomic,strong) UIBarButtonItem * editButton;
@property (nonatomic, strong) NSMutableArray * itemList;
@property (nonatomic, copy) NSString *ipAdress;
@property (nonatomic, assign) UInt16 port;
@property (nonatomic,assign) int clientSocket;
@property (nonatomic,assign) int result;
@property (nonatomic, assign) bool connectToServer;

@end
