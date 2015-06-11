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
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MessagingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _room = [[Chatroom alloc] init];
    _room.delegate = self;
    [_room connectToSocket];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
   
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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
    [_room joinChatroom:[PFUser currentUser].username];
}
-(void)chatRoomJoinedBy:(id)data
{
    
}
-(void)chatRoomLeftBy:(id)data
{
    
}

#pragma mark - UITextField Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    
}

#pragma mark - animations for keyboard


- (void)keyboardWillShow:(NSNotification*)notification
{
    [_tableView setContentOffset:CGPointMake(0, -240) animated:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, -240, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    
}




@end
