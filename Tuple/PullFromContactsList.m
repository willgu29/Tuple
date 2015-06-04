//
//  PullFromContactsList.m
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "PullFromContactsList.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "UserCellInfo.h"
#import "UserTypeEnums.h"
#import "ArraySorter.h"
#import "AppDelegate.h"
#import "Contact.h"
#import "User.h"
#import "ParseDatabase.h"
#import "Converter.h"
@interface PullFromContactsList()

@property (nonatomic, strong) NSMutableArray *contactListArray;

@end

@implementation PullFromContactsList

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _contactListArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)fetchTableViewData
{
    [self checkAuthorizationStatusForContactList];
}

-(void)checkAuthorizationStatusForContactList
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusAuthorized)
    {
        [self fetchAllFromContactsList];
    }
    else if (status == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(nil, ^(bool granted, CFErrorRef error) {
            if (granted) {
                [self fetchAllFromContactsList];
            } else {
                // User denied access
                [_delegate contactListFetchFailure:(__bridge NSError *)(error)];
            }
        });
    }
    else if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted)
    {
        NSError *error = [[NSError alloc] initWithDomain:@"This app requires access to your contacts book" code:1 userInfo:nil];
        [_delegate contactListFetchFailure:error];
        return;
    }

}

-(void)fetchAllFromContactsList
{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (error)
    {
        NSLog(@"Error Address Book: %@", error);
        [_delegate contactListFetchFailure:(__bridge NSError *)(error)];
    }
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger nPeople = [allPeople count];
    
    for (int i = 0; i < nPeople; i++)
    {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *email = CFBridgingRelease(ABRecordCopyValue(person, kABPersonEmailProperty));
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
        NSString *phoneNumber = nil;
        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
            phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            //TODO: Get all phone numbers for name
        }
        CFRelease(phoneNumbers);

        if (phoneNumber && (firstName || lastName))
        {
            NSString *formatted = [Converter convertPhoneNumberToOnlyNumbers:phoneNumber];
            if ([formatted isEqualToString:@"ERROR"])
            {
                continue;
            }
            
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            NSManagedObjectContext *managedContext = [delegate managedObjectContext];
            Contact *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:managedContext];
            
            newContact.phoneNumber = formatted;
            newContact.firstName = firstName;
            newContact.lastName = lastName;
            newContact.fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            newContact.email = email;
            
            PFUser *user = [ParseDatabase lookupPhoneNumber:formatted];
            User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedContext];
            if (user) {
                newContact.hasTupleAccount = [NSNumber numberWithBool:YES];
                newUser.username = user.username;
                newUser.score = user[@"score"];
                newUser.phoneNumber = user[@"phoneNumber"];
                newUser.contactCard = newContact;
            } else {
                newContact.hasTupleAccount = [NSNumber numberWithBool:NO];
            }
            
            newContact.userInfo = newUser;
            NSError *error;
            if (![managedContext save:&error]) {
                        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            
        }
        
    }
//    NSArray *sortedArray = [ArraySorter sortArrayAlphabetically:_contactListArray];
    
//    [_delegate contactListFetchSuccess:sortedArray];
}


@end
