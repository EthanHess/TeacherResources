//
//  RandomizedViewControllerDataSource.m
//  Teacher Resources
//
//  Created by Ethan Hess on 3/6/15.
//  Copyright (c) 2015 PJayRushton. All rights reserved.
//

#import "RandomizedViewControllerDataSource.h"
#import "MembersCollectionViewCell.h"
#import "GroupController.h"
#import "Member.h"
#import "Group.h"

@interface RandomizedViewControllerDataSource ()

@property (nonatomic,strong) MembersCollectionViewCell * cell;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) Group *group;

@end

@implementation RandomizedViewControllerDataSource


@synthesize cell;

-(void)registerCollectionView:(UICollectionView *)collectionView withGroup:(Group *)group {
    
    self.group = group;
//    self.members = [group.members array];
    
    [collectionView registerClass:[MembersCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
}

-(MembersCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Member *member = [GroupController sharedInstance].temporaryStudentList[indexPath.row];
    cell.name.text = member.name;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[GroupController sharedInstance].temporaryStudentList count];
}

@end

////
////  RandomizedViewControllerDataSource.m
////  Teacher Resources
////
////  Created by Ethan Hess on 3/6/15.
////  Copyright (c) 2015 PJayRushton. All rights reserved.
////
//
//#import "RandomizedViewControllerDataSource.h"
//#import "MembersCollectionViewCell.h"
//#import "GroupController.h"
//#import "Member.h"
//#import "Group.h"
//
//@interface RandomizedViewControllerDataSource ()
//
//@property (nonatomic,strong) MembersCollectionViewCell * cell;
//
//@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) Group *group;
//
//@end
//
//@implementation RandomizedViewControllerDataSource
//
//
//@synthesize cell;
//
//-(void)registerCollectionView:(UICollectionView *)collectionView withGroup:(Group *)group {
//
//    self.group = group;
//
//    [collectionView registerClass:[MembersCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
//}
//
//-(MembersCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    
//    
//    Member *member = self.group.members[indexPath.item];
//    
//    cell.name.text = member.name;
//    
//    return cell;
//}
//
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return self.group.members.count;
//}
//
//@end