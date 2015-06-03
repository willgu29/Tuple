//
//  MessagingViewController.m
//  Tuple
//
//  Created by William Gu on 6/1/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "MessagingViewController.h"
#import "Chatroom.h"
#import "Message.h"

@interface MessagingViewController ()

@property (nonatomic, strong) Chatroom *room;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation MessagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    _room = [[Chatroom alloc] init];
    _room.delegate = self;
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

#pragma mark - Table View Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_room messageCount];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
    }
    
    Message *message = [_room getMessageAtIndex:indexPath.row];
    
    cell.textLabel.text = message.message;
    
    return cell;
}

#pragma mark - Chatroom Delegate
-(void)chatMessageReceived
{
    [self.tableView reloadData];
}
-(void)chatRoomConnected
{
    NSLog(@"Connected!");
}

@end
