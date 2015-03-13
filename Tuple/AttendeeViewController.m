//
//  AttendeeViewController.m
//  Tuple
//
//  Created by William Gu on 3/13/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "AttendeeViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface AttendeeViewController ()

@end

@implementation AttendeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupLabel];
}

-(IBAction)attend:(UIButton *)sender
{
    //TODO: update
}
-(IBAction)decline:(UIButton *)sender
{
    //TODO: update
}

-(IBAction)testText:(UIButton *)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://tupleapp.com/twilio/sms/"];
    NSString *encoded = [NSString stringWithUTF8String:[url UTF8String]];
    NSString *number = @"16032756869";
    NSString *message = @"Whatever I wanted to say";
    NSDictionary *dictionary = @{@"number" : number};
    [manager POST:encoded parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@" ,error);
    }];
}
@end
