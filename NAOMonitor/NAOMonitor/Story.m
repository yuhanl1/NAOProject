//
//  Story.m
//  NAOMonitor
//
//  Created by LiuYuHan on 6/5/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "Story.h"
#import "StoryContent.h"

@interface Story ()

@end

@implementation Story

@synthesize itemList;
@synthesize editButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Story";
    itemList = [[NSMutableArray alloc]initWithObjects:@"The Emperor's New Clothes",@"The Princess and the Pea",@"Little Red Riding Hood",@"Little Snow White",@"The Ugly Ducking",@"The Sleeping Beauty",@"The Little Mermaid",@"Beauty and the Beast",@"The Elves and the Shoemaker",@"Little Thumb",@"The Golden Goose",@"The Juniper Tree",@"The Red Shoes",@"The Naughty Boy",@"Blue Beard", nil];
    
    
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
    StoryContent *storyContentView = [[StoryContent alloc]init];
    storyContentView.title = [itemList objectAtIndex:indexPath.row];
    storyContentView.index = (int)(indexPath.row);
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault integerForKey:@"Font"]) {
        NSInteger tmpFont = [userDefault integerForKey:@"Font"];
        storyContentView.font = (int)(tmpFont);
    }else{
        storyContentView.font = 20;
    }
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    [self.navigationController pushViewController:storyContentView animated:YES];
}
@end
