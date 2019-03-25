//
//  RobotSay.m
//  NAOMonitor
//
//  Created by LiuYuHan on 11/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "RobotSay.h"

@interface RobotSay ()

@end

@implementation RobotSay

@synthesize ipAdress;
@synthesize port;
@synthesize clientSocket;
@synthesize result;
@synthesize aButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"Cell"];
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width - 40, 230)];
    [_textView setEditable:YES];
    [_textView setText:@"Hello!"];
    [_textView setFont:[UIFont systemFontOfSize:_font]];
    [_textView setDelegate:self];
    [_textView setClearsContextBeforeDrawing:YES];
    [_textView setScrollsToTop:YES];
    [_textView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.05]];
    //UIButton *aButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 45)];
    aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aButton setFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 45)];
    [aButton setTitle:@"Say" forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchDown];
    [aButton setEnabled:YES];
    [aButton setBackgroundColor:[UIColor colorWithRed:0.9 green:0.0 blue:0.0 alpha:0.7]];
    [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIView *tmpView = [[UIView alloc]init];
    //[tmpView addSubview:aButton];
    self.tableView.tableFooterView = tmpView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        [cell.contentView addSubview:_textView];
    }
    else{
        [cell.contentView addSubview:aButton];
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {return NO;}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 240;
    }
    else{
        return 45;
    }
}

-(void)buttonAction{
    [self connection:ipAdress port:port];
    NSString *sendMessage = [[NSString alloc]initWithFormat:@"Say:%@",[_textView text]];
    [self sendStringToServerAndReceived:sendMessage];
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
