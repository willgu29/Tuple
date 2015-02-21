//
//  MessagingViewController.m
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "MessagingViewController.h"
#import "Tuple-Swift.h"
#import "LayerConversation.h"
#import "SendMessages.h"
#import "AppDelegate.h"
#import "DiningHallConvert.h"
//#import "FetchUserData.h"
#import "DeleteMessages.h"
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
    
    [self loadConversationAndMessages];
}

-(void)loadConversationAndMessages
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSError *error;
    if (delegate.sendData.clientType == 1)
    {
        NSURL *identifier = [[NSUserDefaults standardUserDefaults] URLForKey:@"convoID"];
        if (identifier == nil)
        {
            identifier = [LayerConversation createInitialConversationWithUsername:[PFUser currentUser].username];
        }
        else
        {
            [DeleteMessages deleteMessagesInConversationID:identifier];
        }
        self.conversation = [LayerConversation queryForConversationWithConvoID:identifier];
        [self.conversation addParticipants:[NSSet setWithArray:_usernameParticipants] error:&error];
    }
    else if (delegate.sendData.clientType == 2)
    {
        self.conversation = [LayerConversation queryForConversationWithHostName:delegate.sendData.hostUsername];
        [self.conversation addParticipants:[NSSet setWithArray:_usernameParticipants] error:&error];
        
        
    }
    
    if (self.conversation)
    {
        [self setupQueryController];
        [self setupLabels];
        [_tableView reloadData];
    }
    else
    {
        //TODO: ALERT ERROR
        NSLog(@"No conversation found ERROR");
        [self performSelector:@selector(loadConversationAndMessages) withObject:self afterDelay:1];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Labels
-(void)setupLabels
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSString *diningHall =[DiningHallConvert convertDiningHallIntToString:delegate.sendData.diningHallInt];
    NSString *timeToEat = delegate.sendData.theTimeToEat;
    _hostName.text = [NSString stringWithFormat:@"Host: %@", delegate.sendData.hostName];
    _diningHallAndTime.text = [NSString stringWithFormat:@"%@ @ %@", diningHall, timeToEat];
}

#pragma mark -IBActions

-(IBAction)sendButton:(UIButton *)sender
{
    if ([_textField.text isEqualToString:@""])
    {
        return;
    }
    [SendMessages sendMessageWithPush:_textField.text ToConversation:self.conversation];
    _textField.text = @"";
}

-(IBAction)doneChatting:(UIButton *)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"You will not be able to re-enter the chatroom." delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"Cancel", nil] show];
}

#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index: %ld", (long)buttonIndex);
    if (buttonIndex == 0)
    {
        [SendMessages sendMessageWithoutPush:@"has left the conversation" ToConversation:self.conversation];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        
        NSError *error = nil;
        if (delegate.sendData.clientType == 2)
        {
            BOOL success = [self.conversation removeParticipants:[NSSet setWithObject:[PFUser currentUser].username] error:&error];
            
            PFUser *user = [PFUser currentUser];
            PFQuery *query = [PFQuery queryWithClassName:@"Events"];
            [query whereKey:@"hostUsername" equalTo:delegate.sendData.hostUsername];
            PFObject *eventObject = (PFObject *)[query getFirstObject];
            NSMutableArray *peopleInChatroom = eventObject[@"peopleInChatroom"];
            [peopleInChatroom removeObject:user.username];
            eventObject[@"peopleInChatroom"] = peopleInChatroom;
            [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
            }];
            
        }
        [self pushToFeedbackVC];
    }
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



#pragma mark - VC Methods

-(void)pushToFeedbackVC
{
    FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

-(void)moveVC
{
    [self.view setFrame:CGRectMake(0, -230, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)revertVC
{
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self resignKeyboard];
}

#pragma mark -Layer methods and calls

-(void)setupQueryController
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    // Query for all the messages in conversation sorted by index
    LYRQuery *query = [LYRQuery queryWithClass:[LYRMessage class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"conversation" operator:LYRPredicateOperatorIsEqualTo value:self.conversation];
    query.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
//    query.limit = MAX_CONVERSATION_MESSAGES_FROM_QUERY;
//    query.offset = 0;
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
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    if ([messageString isEqualToString:@"Welcome to Tuple!"] || [messageString isEqualToString:@"Say hi!"])
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Tuple@UCLA: %@", messageString];
        return;
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",[message sentByUserID],messageString];
        
    }
    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




@end
