//
//  Song.m
//  NAOMonitor
//
//  Created by LiuYuHan on 6/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "Song.h"

@interface Song ()

@end

@implementation Song

@synthesize itemList;
@synthesize editButton;
@synthesize ipAdress;
@synthesize port;
@synthesize clientSocket;
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Song";
    itemList = [[NSMutableArray alloc]init];
    for (int i = 1; i<10; i++) {
        [itemList addObject:[NSString stringWithFormat:@"Lullaby 0%d",i]];
    }
    for (int i = 10; i<61; i++) {
        [itemList addObject:[NSString stringWithFormat:@"Lullaby %d",i]];
    }
    
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
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [itemList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [itemList objectAtIndex:indexPath.row];
    
    return cell;
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    if([[[tableView cellForRowAtIndexPath:indexPath] textColor] isEqual:[UIColor redColor]]){
        [[tableView cellForRowAtIndexPath:indexPath] setTextColor:[UIColor grayColor]];
        if (_connectToServer) {
            [self connection:ipAdress port:port];
            NSString *sendMessage = [[NSString alloc]initWithFormat:@"Stop"];
            [self sendStringToServerAndReceived:sendMessage];
        }
    }else{
        [[tableView cellForRowAtIndexPath:indexPath] setTextColor:[UIColor redColor]];
        if (_connectToServer) {
            [self connection:ipAdress port:port];
            NSString *sendMessage = [[NSString alloc]initWithFormat:@"Song%d",(int)indexPath.row];
            [self sendStringToServerAndReceived:sendMessage];
        }
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
