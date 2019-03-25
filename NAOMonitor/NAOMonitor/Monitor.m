//
//  Monitor.m
//  NAOMonitor
//
//  Created by LiuYuHan on 6/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "Monitor.h"
#include <sys/time.h>

@interface Monitor ()

@end

@implementation Monitor

@synthesize name;
@synthesize ipAdress;
@synthesize port;
@synthesize imageView;
//@synthesize socket;
@synthesize clientSocket;
@synthesize result;
@synthesize editButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = name;
    //_receiveData = [[NSMutableData alloc]init];
    _tmpData = [[NSMutableArray alloc]init];
    imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    //[imageView setTransform:CGAffineTransformMakeScale(-1.0, 1.0)];
    //[self.view setTransform:CGAffineTransformMakeScale(-1.0, 1.0)];
    [self.view addSubview:imageView];
    //[self socketConnectHost];
    editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(addAction)];
    [editButton setTintColor:[UIColor blueColor]];
    self.navigationItem.rightBarButtonItem = editButton;
    _image = [[UIImage alloc]init];
    _stopFlag = 0;
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([userdefaults objectForKey:@"Resolution"]) {
        NSString *tmp = [userdefaults objectForKey:@"Resolution"];
        NSArray *aArray = [tmp componentsSeparatedByString:@"*"];
        _resolution_X = [aArray[0] intValue];
        _resolution_Y = [aArray[1] intValue];
    }
    
    [self connection:ipAdress port:port];
    [self sendStringToServerAndReceived:@"Monitor"];
    
}

-(void)viewDidLayoutSubviews{
    [imageView setFrame:self.view.frame];
}


-(void)addAction{
    
    //for (int i=0; i<20; i++){
        [self connection:ipAdress port:port];
        [self sendStringToServerAndReceived:@"Monitor"];
    //}
    /*for (int i=0; i<10; i++) {
        [self connection:ipAdress port:port];
        [self sendStringToServerAndReceived:@"Monitor"];
        _Flag = 0;
        while (_Flag == 0) {
            
        }
        UIImage *a = [[UIImage alloc]initWithData:_receiveData];
        //NSLog(@"%@",_receiveData);
        [imageView setImage:a];
        [_receiveData resetBytesInRange:NSMakeRange(0, _receiveData.length)];
        [_receiveData setLength:0];
        [self disConnection];
    }*/
}


-(void)viewDidAppear:(BOOL)animated{
    
}



- (BOOL)connection:(NSString *)hostText port:(int)port {
    
    clientSocket = - 1;
    clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    if (clientSocket > 0) {
        //NSLog(@"socket Conneced to socket no： %d", clientSocket);
    } else {
        NSLog(@"Connection failed.");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Connection failed." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    /*
    //NON-Block
    int flags = fcntl(clientSocket, F_GETFL,0);
    fcntl(clientSocket,F_SETFL, flags | O_NONBLOCK);
    */
    //Connect
    struct sockaddr_in serverAddress;
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = inet_addr(ipAdress.UTF8String);
    serverAddress.sin_port = htons(port);
    
    result = connect(clientSocket, (const struct sockaddr *)&serverAddress, sizeof(serverAddress));
    /*
    //Tineout
    fd_set          fdwrite;
    struct timeval  tvSelect;
    FD_ZERO(&fdwrite);
    FD_SET(clientSocket, &fdwrite);
    tvSelect.tv_sec = 2;
    tvSelect.tv_usec = 0;
    int retval = select(clientSocket + 1,NULL, &fdwrite, NULL, &tvSelect);
    
    NSLog(@"%d!=%d",clientSocket,result);
    
    //SET BACK TO BLOCK
    flags = fcntl(clientSocket, F_GETFL,0);
    flags &= ~ O_NONBLOCK;
    fcntl(clientSocket,F_SETFL, flags);
    
    //NO INTERRUPT BY SIGPIPE
    struct sigaction sa;
    sa.sa_handler = SIG_IGN;
    sigaction( SIGPIPE, &sa, 0 );
    
    if(retval < 0)
    {
        if ( errno == EINTR )
        {
            NSLog(@"Select failed.");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Select failed." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
            close(clientSocket);
            return NO;
        }
        else
        {
            NSLog(@"Unknown Error.");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unknown Error." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
            close(clientSocket);
            return NO;
        }
    }
    else if(retval == 0)
    {
        NSLog(@"Select Timeout.");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Connection Timeout." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    NSLog(@"%d!-%d",clientSocket,result);
    */
    
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


- (void)sendStringToServerAndReceived:(NSString *)message {
    
    if (clientSocket > 0 && result >= 0) {
        sigset_t set;
        sigemptyset(&set);
        sigaddset(&set, SIGPIPE);
        sigprocmask(SIG_BLOCK, &set, NULL);
        ssize_t sendLen = send(clientSocket, message.UTF8String, strlen(message.UTF8String), 0);
        NSLog(@"Sent: %ld", sendLen);
        if (sendLen > 0) {
            [self performSelectorInBackground:@selector(readStream) withObject:nil];
            //[self readStream];
        }
    }else {
        //发送的时候如果连接失败，重新连接。
    }
}

- (void)readStream {
    char readBuffer[1460] = {0};
    //_Flag = 0;
    long OrgBr = 0;
    OrgBr = recv(clientSocket, readBuffer, sizeof(readBuffer), 0);
    if (OrgBr > 0 && _stopFlag == 0) {
        NSMutableData *receiveData = [[NSMutableData alloc]init];
        [receiveData appendBytes:readBuffer length:OrgBr];
        //[_receiveData appendBytes:readBuffer length:OrgBr];
        //NSLog(@"%lu",OrgBr);
        int lengthLimit = (((_resolution_X * _resolution_Y * 3)/1460)+1)*1460;
        //NSLog(@"%d",lengthLimit);
        while (OrgBr == 1460 && [receiveData length]<lengthLimit) {
        //while (OrgBr == 1460 && [receiveData length]<230680) {
            OrgBr = recv(clientSocket, readBuffer, sizeof(readBuffer), 0);
            //NSLog(@"\nbr = %ld\n", OrgBr);
            if (OrgBr > 0) {
                [receiveData appendBytes:readBuffer length:OrgBr];
            }
            //NSLog(@"%lu",[receiveData length]);
            //[_receiveData appendBytes:readBuffer length:OrgBr];
        }
        //_Flag = 1;
        
        
        //NSLog(@"%@",_receiveData);
        [_tmpData addObject:receiveData.copy];
        //[_tmpData addObject:_receiveData.copy];
        //[NSThread detachNewThreadSelector:@selector(decode) toTarget:self withObject:nil];
        [self decode];
        //[self performSelectorOnMainThread:@selector(decode) withObject:nil waitUntilDone:YES];
        //[_receiveData resetBytesInRange:NSMakeRange(0, _receiveData.length)];
        //[_receiveData setLength:0];
        //[self disConnection];
    }
    else if(_stopFlag == 0){
        [self addAction];
    }
    else{
        //[self disConnection];
    }
}



-(void) decode{
    NSData *imageData = [_tmpData objectAtIndex:_Flag];
    //_image = [UIImage imageWithData:[_tmpData objectAtIndex:_Flag]];
    //NSLog(@"%@",[_tmpData objectAtIndex:_Flag]);
    
    //CGimageRef Create Image Based on RGB
    CGImageRef imageRef = CGImageCreate(_resolution_X, _resolution_Y, 8, 24, _resolution_X * 3, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNone|kCGBitmapByteOrderDefault, CGDataProviderCreateWithCFData((__bridge CFDataRef)imageData), NULL, false, kCGRenderingIntentDefault);
    _image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    _Flag ++;
    [self performSelectorOnMainThread:@selector(displayImage) withObject:nil waitUntilDone:YES];
    //[self displayImage];
}
-(void) displayImage{
    //self.view.layer.contents = (id) _image.CGImage;
    [imageView setImage:_image];
    [imageView layoutIfNeeded];
    [self.view layoutIfNeeded];
    [self disConnection];
    if (_stopFlag == 0) {
        NSLog(@"%d",_Flag);
        [self addAction];
        //sleep(1);
        //[self performSelectorOnMainThread:@selector(receiveAgain) withObject:nil waitUntilDone:YES];
        //[self receiveAgain];
    }
}

-(void) receiveAgain{
    char readBuffer[1460] = {0};
    long OrgBr = 0;
    //while (OrgBr == 0 && _stopFlag == 0) {
    OrgBr = recv(clientSocket, readBuffer, sizeof(readBuffer), 0);
    //}
    if (OrgBr > 0) {
        NSMutableData *receiveData = [[NSMutableData alloc]init];
        [receiveData appendBytes:readBuffer length:OrgBr];
        //[_receiveData appendBytes:readBuffer length:OrgBr];
        //NSLog(@"%lu",OrgBr);
        int lengthLimit = (((_resolution_X * _resolution_Y * 3)/1460)+1)*1460;
        //NSLog(@"%d",lengthLimit);
        while (OrgBr == 1460 && [receiveData length]<lengthLimit) {
        //while (OrgBr == 1460 && [receiveData length]<230680) {
            OrgBr = recv(clientSocket, readBuffer, sizeof(readBuffer), 0);
            [receiveData appendBytes:readBuffer length:OrgBr];
        }
        [_tmpData addObject:receiveData.copy];
        //[self decode];
        [self performSelectorOnMainThread:@selector(decode) withObject:nil waitUntilDone:YES];
    }
}


-(void)viewDidDisappear:(BOOL)animated{
    _stopFlag = 1;
    [self disConnection];
}

- (void)disConnection {
    
    if (clientSocket > 0) {
        close(clientSocket);
        clientSocket = -1;
    }
}
@end
