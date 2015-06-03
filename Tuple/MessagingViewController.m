//
//  MessagingViewController.m
//  Tuple
//
//  Created by William Gu on 6/1/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "MessagingViewController.h"
#import "Chatroom.h"

@interface MessagingViewController ()

@property (nonatomic, strong) Chatroom *room;

@end

@implementation MessagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    _room = [[Chatroom alloc] init];
    [_room joinChatroom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)test:(UIButton *)sender
{
    NSLog(@"Test");
    [_room sendMessage:@"TEST"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
    }
    cell.textLabel.text = @"HI";
    
    return cell;
}
@end
