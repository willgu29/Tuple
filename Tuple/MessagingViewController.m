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
#import <Parse/Parse.h>

@interface MessagingViewController ()

@property (nonatomic, strong) Chatroom *room;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

@implementation MessagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _room = [[Chatroom alloc] init];
    _room.delegate = self;
    [_room joinChatroom];
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)sendMessage:(UIButton *)sender
{
    [_room sendMessage:_textField.text];
    _textField.text = @"";
}
-(IBAction)done:(UIButton *)sender
{
    
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
-(void)chatRoomReconnected
{
    NSLog(@"Re-Connected!");
    
}

#pragma mark - UITextField Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

@end
