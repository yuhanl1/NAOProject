//
//  Setting.m
//  NAOMonitor
//
//  Created by LiuYuHan on 6/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "Setting.h"
#import "RobotSay.h"

@interface Setting ()

@end

@implementation Setting

@synthesize sectionArray;
@synthesize sectionValue;

@synthesize systemSettingArray;
@synthesize systemSettingValue;

@synthesize aboutArray;
@synthesize aboutValue;

@synthesize sectionLabel;

@synthesize ipAdress;
@synthesize port;
@synthesize clientSocket;
@synthesize result;

@synthesize aSwitch;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Setting";
    systemSettingArray = [[NSMutableArray alloc]initWithObjects:@"Volume",@"Video Resolution",@"Text Font",@"Network Enable",@"Let Robot Say", nil];
    
    aboutArray = [[NSMutableArray alloc]initWithObjects:@"Version",@"Author", nil];
    
    systemSettingValue= [[NSMutableArray alloc]initWithObjects:@"50",@"320*240",@"20",@"NO",@"", nil];
    aboutValue = [[NSMutableArray alloc]initWithObjects:@"1.0.4",@"Yuhan Liu", nil];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault integerForKey:@"Volume"]) {
        systemSettingValue[0] = [[NSString alloc]initWithFormat:@"%d",(int)[userDefault integerForKey:@"Volume"]];
    }
    if ([userDefault integerForKey:@"Font"]) {
        systemSettingValue[2] = [[NSString alloc]initWithFormat:@"%d",(int)[userDefault integerForKey:@"Font"]];
    }
    if ([userDefault objectForKey:@"Resolution"]) {
        systemSettingValue[1] =[userDefault objectForKey:@"Resolution"];
    }
    aSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 68, 7, 45, 11)];
    [aSwitch setEnabled:YES];
    [aSwitch addTarget:self action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];
    if ([userDefault objectForKey:@"ConnectToServer"]) {
        NSString *tmp = [userDefault objectForKey:@"ConnectToServer"];
        if ([tmp isEqualToString:@"NO"]) {
            _connectToServer = NO;
        }
        else{
            _connectToServer = YES;
        }
        systemSettingValue[3] =[userDefault objectForKey:@"ConnectToServer"];
    }
    sectionArray = [[NSMutableArray alloc]initWithObjects:systemSettingArray,aboutArray, nil];
    sectionValue = [[NSMutableArray alloc]initWithObjects:systemSettingValue,aboutValue, nil];
    
    sectionLabel = [[NSMutableArray alloc]initWithObjects:@"System Setting",@"About", nil];
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
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[sectionArray objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 3) {
        if ([systemSettingValue[3] isEqualToString:@"NO"]) {
            [aSwitch setOn:NO];
        }
        else{
            [aSwitch setOn:YES];
        }
        cell.detailTextLabel.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:aSwitch];
        //[cell.detailTextLabel addSubview:aSwitch];
    }
    else if(indexPath.section == 0 && indexPath.row == 4){
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.detailTextLabel.text =[[sectionValue objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    if (indexPath.section == [sectionArray count]-1) {
        [cell setUserInteractionEnabled:NO];
    }
    
    
    return cell;
}
-(void)switchChanged{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([systemSettingValue[3] isEqualToString:@"NO"]){
        systemSettingValue[3] = @"YES";
        [userDefault setObject:@"YES" forKey:@"ConnectToServer"];
        _connectToServer = YES;
    }
    else{
        systemSettingValue[3] = @"NO";
        [userDefault setObject:@"NO" forKey:@"ConnectToServer"];
        _connectToServer = NO;
    }
    [userDefault synchronize];
    [self.tableView reloadData];
}




-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [sectionLabel objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == [sectionArray count]-1) {
        return 0;
    }else{
        return 20;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//Volume
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Set Volume" message:@"Please set volume for the robot.\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
            
            
            UIPickerView *picker =[[UIPickerView alloc]initWithFrame:CGRectMake(25, 55, self.view.frame.size.width - 80, 240)];
            
            picker.tag = 0;
            picker.delegate = self;
            picker.dataSource = self;
            int tmpRow = [systemSettingValue[0] intValue] - 1;
            [picker selectRow:tmpRow inComponent:0 animated:YES];
            
            [alert.view addSubview:picker];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setInteger: [self->_setVolume intValue] forKey:@"Volume"];
                [userDefault synchronize];
                if (self->_connectToServer) {
                    [self connection:self->ipAdress port:self->port];
                    NSString *sendMessage = [[NSString alloc]initWithFormat:@"Volume%d",(int)[self->_setVolume intValue]];
                    [self sendStringToServerAndReceived:sendMessage];
                }
                [self.tableView reloadData];
            }];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (indexPath.row == 1){//Video Resolution
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Set Resolution" message:@"Video resolution is the quality of the video streaming. Please be careful to set a high quality, since it will reduce the streaming speed.\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
            
            
            UIPickerView *picker =[[UIPickerView alloc]initWithFrame:CGRectMake(25, 80, self.view.frame.size.width - 80, 230)];
            
            picker.tag = 1;
            picker.delegate = self;
            picker.dataSource = self;
            int tmpRow = 0;
            if ([systemSettingValue[1] isEqualToString:@"40*30"]) {
                tmpRow = 0;
            }else if ([systemSettingValue[1] isEqualToString:@"80*60"]) {
                tmpRow = 1;
            }else if ([systemSettingValue[1] isEqualToString:@"160*120"]) {
                tmpRow = 2;
            }else if ([systemSettingValue[1] isEqualToString:@"320*240"]) {
                tmpRow = 3;
            }else if ([systemSettingValue[1] isEqualToString:@"640*480"]) {
                tmpRow = 4;
            }else if ([systemSettingValue[1] isEqualToString:@"1280*960"]) {
                tmpRow = 5;
            }
            
            [picker selectRow:tmpRow inComponent:0 animated:YES];
            
            [alert.view addSubview:picker];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject: self->_setResolution forKey:@"Resolution"];
                [userDefault synchronize];
                if (self->_connectToServer) {
                    [self connection:self->ipAdress port:self->port];
                    NSString *sendMessage = [[NSString alloc]initWithFormat:@"Resolution%@",self->_setResolution];
                    [self sendStringToServerAndReceived:sendMessage];
                }
                [self.tableView reloadData];
            }];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (indexPath.row == 2){//Text Font
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Set Font" message:@"Please set font for the story text.\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
            
            
            UIPickerView *picker =[[UIPickerView alloc]initWithFrame:CGRectMake(25, 55, self.view.frame.size.width - 80, 240)];
            
            picker.tag = 2;
            picker.delegate = self;
            picker.dataSource = self;
            int tmpRow = [systemSettingValue[2] intValue] - 11;
            [picker selectRow:tmpRow inComponent:0 animated:YES];
            
            [alert.view addSubview:picker];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setInteger: [self->_setFont intValue] forKey:@"Font"];
                [userDefault synchronize];
                [self.tableView reloadData];
            }];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (indexPath.row == 4){//Say
            if (_connectToServer) {
                RobotSay *aRobotSay = [[RobotSay alloc]init];
                aRobotSay.font = [systemSettingValue[2] intValue];
                aRobotSay.ipAdress = ipAdress;
                aRobotSay.port = port;
                [self.navigationController pushViewController:aRobotSay animated:YES];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Banned" message:@"Please enable the network first." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                [alert addAction:action1];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        return 100;
    }else if(pickerView.tag == 1){
        return 6;
    }else{
        return 50;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 1){
        switch (row) {
            case 0:
                return @"40*30";
                break;
            case 1:
                return @"80*60";
                break;
            case 2:
                return @"160*120";
                break;
            case 3:
                return @"320*240";
                break;
            case 4:
                return @"640*480";
                break;
            default:
                return @"1280*960";
                break;
        }
    }else if(pickerView.tag == 2){
        return [[NSString alloc]initWithFormat:@"%d",(int)(row+11)];
    }else{
        return [[NSString alloc]initWithFormat:@"%d",(int)(row+1)];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        _setVolume = [[NSString alloc]initWithFormat:@"%d",(int)(row+1)];
        systemSettingValue[0] = _setVolume;
    }
    else if(pickerView.tag == 1){
        switch (row) {
            case 0:
                _setResolution = @"40*30";
                break;
            case 1:
                _setResolution = @"80*60";
                break;
            case 2:
                _setResolution = @"160*120";
                break;
            case 3:
                _setResolution = @"320*240";
                break;
            case 4:
                _setResolution = @"640*480";
                break;
            default:
                _setResolution = @"1280*960";
                break;
        }
        systemSettingValue[1] = _setResolution;
    }else if(pickerView.tag == 2){
        _setFont = [[NSString alloc]initWithFormat:@"%d",(int)(row+11)];
        systemSettingValue[2] = _setFont;
    }
    
    [self.tableView reloadData];
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
