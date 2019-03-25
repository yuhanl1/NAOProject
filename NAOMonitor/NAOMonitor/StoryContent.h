//
//  StoryContent.h
//  NAOMonitor
//
//  Created by LiuYuHan on 10/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>


@interface StoryContent : UIViewController

@property (nonatomic, assign) int index;
@property (nonatomic, assign) int font;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITextView *txtView;
@property (nonatomic, copy) NSString *ipAdress;
@property (nonatomic, assign) UInt16 port;
@property (nonatomic,assign) int clientSocket;
@property (nonatomic,assign) int result;

@property (nonatomic, assign) bool connectToServer;

@end
