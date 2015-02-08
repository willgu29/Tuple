//
//  PullFromContactsList.m
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "PullFromContactsList.h"
#import <AddressBook/AddressBook.h>

@implementation PullFromContactsList

-(void)fetchAllFromContactsList
{
    CFErrorRef error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, &error);
    if (error)
    {
        NSLog(@"Error Address Book: %@", error);
    }
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    for (int i = 0; i < nPeople; i++)
    {
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        NSLog(@"Reference Contacts: %@", ref);
    }
}

@end
