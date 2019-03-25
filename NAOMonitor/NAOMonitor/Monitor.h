//
//  Monitor.h
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



#import "AsyncSocket.h"

@interface Monitor : UIViewController<AsyncSocketDelegate>
{
}

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIBarButtonItem * editButton;
@property (nonatomic,assign) int clientSocket;
@property (nonatomic,assign) int result;
//@property (nonatomic, strong) AsyncSocket *socket;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, copy) NSString *ipAdress;
@property (nonatomic, assign) UInt16 port;
//@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSMutableArray *tmpData;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic,assign) int Flag;
@property (nonatomic,assign) int stopFlag;

@property (nonatomic, assign) int resolution_X;
@property (nonatomic, assign) int resolution_Y;

@end
