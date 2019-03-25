//
//  StoryContent.m
//  NAOMonitor
//
//  Created by LiuYuHan on 10/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "StoryContent.h"

@interface StoryContent ()

@end

@implementation StoryContent

@synthesize ipAdress;
@synthesize port;
@synthesize clientSocket;
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    //_webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([userdefaults objectForKey:@"SelectedRobotIP"] && [userdefaults integerForKey:@"SelectedRobotPort"]) {
        ipAdress = [userdefaults objectForKey:@"SelectedRobotIP"];
        port = [userdefaults integerForKey:@"SelectedRobotPort"];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please Add and Select A Robot First at the Robot Page." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.tabBarController setSelectedViewController:[self.tabBarController.viewControllers objectAtIndex:0]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if ([userdefaults objectForKey:@"ConnectToServer"]) {
        NSString *tmp = [userdefaults objectForKey:@"ConnectToServer"];
        if ([tmp isEqualToString:@"NO"]) {
            _connectToServer = NO;
        }
        else{
            _connectToServer = YES;
        }
    }
    _txtView = [[UITextView alloc]initWithFrame:self.view.frame];
    
    NSString *filename = [[NSString alloc]initWithFormat:@"%d",self.index+1];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:filename ofType:@"txt"];
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //[_txtView setText:content];
    
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:_font],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    [_txtView setAttributedText:[[NSAttributedString alloc]initWithString:content attributes:attributes]];
    
    [_txtView setEditable:NO];
    [_txtView setSelectable:NO];
    
    
    
    //[_webView loadHTMLString:content baseURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForAuxiliaryExecutable:path]]];
    //[self.view addSubview:_webView];
    [self.view addSubview:_txtView];
    if (_connectToServer) {
        [self connection:ipAdress port:port];
        NSString *sendMessage = [[NSString alloc]initWithFormat:@"Story%d",_index];
        [self sendStringToServerAndReceived:sendMessage];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidLayoutSubviews{
    [_txtView setFrame:self.view.frame];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (_connectToServer) {
        [self connection:ipAdress port:port];
        NSString *sendMessage = [[NSString alloc]initWithFormat:@"Stop"];
        [self sendStringToServerAndReceived:sendMessage];
    }
}

- (BOOL)connection:(NSString *)hostText port:(int)port {
    
    clientSocket = - 1;
    clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (clientSocket <= 0){
        NSLog(@"Connection failed.");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Connection failed." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    //Connect
    struct sockaddr_in serverAddress;
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = inet_addr(ipAdress.UTF8String);
    serverAddress.sin_port = htons(port);
    
    result = connect(clientSocket, (const struct sockaddr *)&serverAddress, sizeof(serverAddress));
    
    if (clientSocket > 0 && result >= 0) {
        return YES;
    }else {
        NSLog(@"Connection failed.");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Connection failed." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        [self disConnection];
        return NO;
    }
}
- (void)disConnection {
    
    if (clientSocket > 0) {
        close(clientSocket);
        clientSocket = -1;
    }
}

- (void)sendStringToServerAndReceived:(NSString *)message {
    
    if (clientSocket > 0 && result >= 0) {
        sigset_t set;
        sigemptyset(&set);
        sigaddset(&set, SIGPIPE);
        sigprocmask(SIG_BLOCK, &set, NULL);
        ssize_t sendLen = send(clientSocket, message.UTF8String, strlen(message.UTF8String), 0);
        NSLog(@"Sent: %ld", sendLen);
        if (sendLen > 0) {
            sleep(1);
            [self disConnection];
        }
    }
}


@end
