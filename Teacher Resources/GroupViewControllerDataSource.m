//
//  GroupViewControllerDataSource.m
//  Teacher Resources
//
//  Created by Ethan Hess on 3/6/15.
//  Copyright (c) 2015 PJayRushton. All rights reserved.
//

#import "GroupViewControllerDataSource.h"

static NSString * const cellIdentifier = @"cellIdentifier";

@implementation GroupViewControllerDataSource



- (void)registerTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [GroupController sharedInstance].groupNamesArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    Group *group = [GroupController sharedInstance].groupNamesArray[indexPath.row];
    cell.textLabel.text = group.title;
    
    //Cell Subtitle
    NSString *numberOfStudents = [NSString stringWithFormat:@"%lu Member", (unsigned long)[GroupController sharedInstance].group.members.count];
    cell.detailTextLabel.text = numberOfStudents;
                                  
    return cell; 
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        [tableView beginUpdates];
//        [[GroupController sharedInstance] removeMember:[self.players objectAtIndex:indexPath.row]];
//        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//        NSMutableArray *players = [[NSMutableArray alloc] initWithArray:self.players];
//        [players removeObjectAtIndex:indexPath.row];
//        self.players = players;
//        
//        [tableView endUpdates];
//    }
//}

@end
