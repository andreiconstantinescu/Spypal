//
//  ContactsViewController.m
//  spypal
//
//  Created by Andrei Constantinescu on 01/04/15.
//  Copyright (c) 2015 Andrei Constantinescu. All rights reserved.
//

#import "ContactsViewController.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Parse/Parse.h>

@interface ContactsViewController ()

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //    dispatch_release(semaphore);
    }
    if (accessGranted) {
        [self getContactsWithAddressBook:addressBook];
    }
    
}

// Get the contacts.
- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        
        //For Phone number
        NSString* mobileLabel;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                break ;
            }
            
        }
        [contactList addObject:dOfPerson];
        
    }
    
    NSMutableArray * phoneNumbers =  [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary * object in contactList) {
        
        
        
        if (object[@"Phone"]) {
            object[@"Phone"] = [(NSString *)object[@"Phone"] stringByReplacingOccurrencesOfString:@"\u00A0" withString:@""];
            object[@"Phone"] = [(NSString *)object[@"Phone"] stringByReplacingOccurrencesOfString:@" " withString:@""];
            object[@"Phone"] = [(NSString *)object[@"Phone"] stringByReplacingOccurrencesOfString:@"(" withString:@""];
            object[@"Phone"] = [(NSString *)object[@"Phone"] stringByReplacingOccurrencesOfString:@")" withString:@""];
            object[@"Phone"] = [(NSString *)object[@"Phone"] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([object[@"Phone"] class] != [NSString class])
            {
                object[@"Phone"]=[NSString stringWithFormat:@"%@", object[@"Phone"]];
            }
            if([object[@"Phone"] hasPrefix:@"0"]){
                object[@"Phone"]=[NSString stringWithFormat:@"+4%@", object[@"Phone"]];
            }
            [phoneNumbers addObject:object[@"Phone"]];
        }
        
    }
    
//    NSLog(@"Contacts = %@", phoneNumbers);
    
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"phoneNumber" containedIn:phoneNumbers];
    [query findObjectsInBackgroundWithBlock:^(NSArray *userObjects, NSError *error) {
        
        if (!error) {
            NSLog(@"Successfully retrieved.");
            for (PFObject *userObject in userObjects){
                NSLog(@"%@", userObject);
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
