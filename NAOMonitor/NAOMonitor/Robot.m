//
//  Robot.m
//  NAOMonitor
//
//  Created by LiuYuHan on 6/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "Robot.h"
#import "valuePass.h"
#import "AddRobot.h"
#import "Monitor.h"
@interface Robot ()

@end

@implementation Robot

@synthesize editButton;
@synthesize robotName;
@synthesize robotIP;
@synthesize robotPort;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    //[self.tableView setEditing:YES];
    self.title = @"Robots";
    editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
    [editButton setTintColor:[UIColor blueColor]];
    self.navigationItem.rightBarButtonItem = editButton;
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([userdefault objectForKey:@"robotName"]) {
        robotName = [[NSMutableArray alloc]initWithArray:[userdefault objectForKey:@"robotName"]];
    }
    else{
        robotName = [[NSMutableArray alloc]init];
    }
    if ([userdefault objectForKey:@"robotIP"]) {
        robotIP = [[NSMutableArray alloc]initWithArray:[userdefault objectForKey:@"robotIP"]];
    }
    else{
        robotIP = [[NSMutableArray alloc]init];
    }
    if ([userdefault objectForKey:@"robotPort"]) {
        robotPort = [[NSMutableArray alloc]initWithArray:[userdefault objectForKey:@"robotPort"]];
    }
    else{
        robotPort = [[NSMutableArray alloc]init];
    }
    
    if (![userdefault integerForKey:@"Volume"]) {
        [userdefault setInteger:50 forKey:@"Volume"];
    }
    if (![userdefault integerForKey:@"Font"]) {
        [userdefault setInteger:20 forKey:@"Font"];
    }
    if (![userdefault objectForKey:@"Resolution"]) {
        [userdefault setObject:@"320*240" forKey:@"Resolution"];
    }
    if (![userdefault objectForKey:@"ConnectToServer"]) {
        [userdefault setObject:@"NO" forKey:@"ConnectToServer"];
    }
    [userdefault synchronize];
    
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
    return [robotName count];
}

-(void)addAction{
    AddRobot *tbc = [[AddRobot alloc]init];
    tbc.delegate = self;
    [self.navigationController pushViewController:tbc animated:YES];
}

- (void) valueChanged:(NSArray *)list{
    [robotName addObject:[list objectAtIndex:0]];
    [robotIP addObject:[list objectAtIndex:1]];
    [robotPort addObject:[list objectAtIndex:2]];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:robotName forKey:@"robotName"];
    [userdefault setObject:robotIP forKey:@"robotIP"];
    [userdefault setObject:robotPort forKey:@"robotPort"];
    [userdefault synchronize];
    
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [robotName objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:20];
    NSString * detailText = [[NSString alloc]initWithFormat:@"%@/%@",[robotIP objectAtIndex:indexPath.row],[robotPort objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = detailText;
    cell.detailTextLabel.font = [UIFont fontWithName:@"ArialMT" size:16];
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}
 */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [robotName removeObjectAtIndex:indexPath.row];
    [robotIP removeObjectAtIndex:indexPath.row];
    [robotPort removeObjectAtIndex:indexPath.row];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:robotName forKey:@"robotName"];
    [userdefault setObject:robotIP forKey:@"robotIP"];
    [userdefault setObject:robotPort forKey:@"robotPort"];
    [userdefault synchronize];
    
    [self.tableView reloadData];
    //[self.tableView setEditing:NO animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Monitor *amonitor = [[Monitor alloc]init];
    amonitor.name = [robotName objectAtIndex:indexPath.row];
    amonitor.ipAdress = [robotIP objectAtIndex:indexPath.row];
    NSNumber *tmpnumber = [[NSNumber alloc]initWithInt:[[robotPort objectAtIndex:indexPath.row] intValue]];
    amonitor.port = [tmpnumber intValue];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    [userdefaults setObject:[robotName objectAtIndex:indexPath.row] forKey:@"SelectedRobotName"];
    [userdefaults setObject:[robotIP objectAtIndex:indexPath.row] forKey:@"SelectedRobotIP"];
    [userdefaults setInteger:[tmpnumber longValue] forKey:@"SelectedRobotPort"];
    [userdefaults synchronize];
    
    [self.navigationController pushViewController:amonitor animated:YES];
    
}


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
