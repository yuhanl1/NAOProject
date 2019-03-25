//
//  AddRobot.m
//  NAOMonitor
//
//  Created by LiuYuHan on 6/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "AddRobot.h"

@interface AddRobot ()

@end

@implementation AddRobot

@synthesize name;
@synthesize ip;
@synthesize port;
@synthesize doneButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add A Robot";
    doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    [doneButton setTintColor:[UIColor blueColor]];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"Cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        name = [[UITextField alloc]initWithFrame:CGRectMake(30, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
        name.keyboardType = UIKeyboardTypeDefault;
        name.clearButtonMode = UITextFieldViewModeWhileEditing;
        name.returnKeyType = UIReturnKeyNext;
        name.delegate = self;
        //cell.userInteractionEnabled = NO;
        [cell addSubview:name];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        ip = [[UITextField alloc]initWithFrame:CGRectMake(30, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
        ip.keyboardType = UIKeyboardTypeURL;
        ip.clearButtonMode = UITextFieldViewModeWhileEditing;
        ip.returnKeyType = UIReturnKeyNext;
        ip.delegate = self;
        //cell.userInteractionEnabled = NO;
        [cell addSubview:ip];
    }
    else if (indexPath.section == 2 && indexPath.row == 1) {
        port = [[UITextField alloc]initWithFrame:CGRectMake(30, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
        port.keyboardType = UIKeyboardTypeURL;
        port.clearButtonMode = UITextFieldViewModeWhileEditing;
        port.returnKeyType = UIReturnKeyDone;
        port.delegate = self;
        //cell.userInteractionEnabled = NO;
        [cell addSubview:port];
    }
    
    else if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"Robot Name";
        cell.userInteractionEnabled = NO;
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = @"IP address";
        cell.userInteractionEnabled = NO;
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        cell.textLabel.text = @"Port";
        cell.userInteractionEnabled = NO;
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == name) {
        [ip becomeFirstResponder];
    }
    else if(textField == ip) {
        [port becomeFirstResponder];
    }
    else{
        [port resignFirstResponder];
        [self doneAction];
    }
    return YES;
}



- (void) doneAction{
    NSArray *tmp = [[NSArray alloc]initWithObjects:name.text, ip.text, port.text, nil];
    [_delegate valueChanged:tmp];
    [self.navigationController popViewControllerAnimated:YES];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
