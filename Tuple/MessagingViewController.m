//
//  MessagingViewController.m
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "MessagingViewController.h"
#import "Tuple-Swift.h"
#import "QueryForConversation.h"
#import "SendMessages.h"
#import "AppDelegate.h"
@interface MessagingViewController ()

@property (nonatomic, strong) LYRConversation *conversation;
@property (nonatomic, retain) LYRQueryController *queryController;

@property (nonatomic, weak) IBOutlet UILabel *hostName;
@property (nonatomic, weak) IBOutlet UILabel *diningHallAndTime;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *textField;


@end

@implementation MessagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.preSendData.clientType == 1)
    {
        NSURL *identifier = [[NSUserDefaults standardUserDefaults] URLForKey:@"convoID"];
        self.conversation = [QueryForConversation queryForConversationWithConvoID:identifier];

    }
    else if (delegate.preSendData.clientType == 2)
    {
        //Get ConvoID from info.
    }
    if (self.conversation)
    {
        [self setupQueryController];
    }
    else
    {
        //TODO: ALERT ERROR
        NSLog(@"No conversation found ERROR");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -IBActions

-(IBAction)sendButton:(UIButton *)sender
{
    if ([_textField.text isEqualToString:@""])
    {
        return;
    }
    [SendMessages sendMessage:_textField.text ToConversation:self.conversation];
    _textField.text = @"";
}

-(IBAction)doneChatting:(UIButton *)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"You will not be able to re-enter the chatroom." delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"Cancel", nil] show];
}

#pragma mark - UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveVC];
    textField.text = @"";
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self revertVC];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignKeyboard];
}

-(void)resignKeyboard
{
    NSLog(@"Resign keyboard");
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index: %d", buttonIndex);
    if (buttonIndex == 0)
    {
        [SendMessages sendMessage:@"has left the conversation" ToConversation:self.conversation];
        [self pushToFeedbackVC];
    }
}

#pragma mark - VC Methods

-(void)pushToFeedbackVC
{
    FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

-(void)moveVC
{
    [self.view setFrame:CGRectMake(0, -166, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)revertVC
{
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
}

#pragma mark -Layer methods and calls

-(void)setupQueryController
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    // Query for all the messages in conversation sorted by index
    LYRQuery *query = [LYRQuery queryWithClass:[LYRMessage class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"conversation" operator:LYRPredicateOperatorIsEqualTo value:self.conversation];
    query.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    self.queryController = [delegate.layerClient queryControllerWithQuery:query];
    self.queryController.delegate = self;
    
    NSError *error;
    BOOL success = [self.queryController execute:&error];
    if (success) {
        NSLog(@"Query fetched %tu message objects", [self.queryController numberOfObjectsInSection:0]);
    } else {
        NSLog(@"Query failed with error: %@", error);
    }
    
    [_tableView reloadData];
}

- (void)queryControllerWillChangeContent:(LYRQueryController *)queryController
{
    [self.tableView beginUpdates];
}

- (void)queryController:(LYRQueryController *)controller
        didChangeObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
          forChangeType:(LYRQueryControllerChangeType)type
           newIndexPath:(NSIndexPath *)newIndexPath
{
    // Automatically update tableview when there are change events
    switch (type) {
        case LYRQueryControllerChangeTypeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case LYRQueryControllerChangeTypeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case LYRQueryControllerChangeTypeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case LYRQueryControllerChangeTypeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
    
}

- (void)queryControllerDidChangeContent:(LYRQueryController *)queryController
{
    [self.tableView endUpdates];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return number of objects in queryController
    return [self.queryController numberOfObjectsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get Message Object from queryController
    LYRMessage *message = [self.queryController objectAtIndexPath:indexPath];
    // Set cell text to "<Sender>: <Message Contents>"
    LYRMessagePart *messagePart = message.parts[0];
    NSString *messageString = [[NSString alloc] initWithData:messagePart.data encoding:NSUTF8StringEncoding];
    
    if ([messageString isEqualToString:@"Welcome to Tuple!"] || [messageString isEqualToString:@"Say hi!"])
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Tuple@UCLA: %@", messageString];
        return;
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",[message sentByUserID], messageString];
    }
    
    
}



@end
