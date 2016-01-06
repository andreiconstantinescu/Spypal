//
//  FriendsViewController.m
//  spypal
//
//  Created by Andrei Constantinescu on 08/04/15.
//  Copyright (c) 2015 Andrei Constantinescu. All rights reserved.
//

#import "FriendsViewController.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Parse/Parse.h>
#import "FriendDetailsViewController.h"
#import "Friend.h"

@interface FriendsViewController ()

@property (nonatomic, strong) NSMutableArray *friendsArray;
@property (nonatomic, strong) NSMutableArray *friendObjectArray;
@end

@implementation FriendsViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _friendObjectArray = [[NSMutableArray alloc] init];
    [self loadData];
}

- (void)loadData {
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
        [self getContactsWithAddressBook:addressBook withHandler:^(NSArray *fetchResults, NSError *error) {
            NSLog(@"%lu",(unsigned long)fetchResults.count);
            _friendsArray = [[NSMutableArray alloc] init];
            [_friendsArray addObjectsFromArray:fetchResults];
            for(int i=0; i< [_friendObjectArray count]; ++i) {
                Friend *temp = [_friendObjectArray objectAtIndex:i];
                BOOL exists = NO;
                NSLog(@"%@", temp.parsedPhone);

                for(PFObject *temp2 in _friendsArray) {
                    NSLog(@"%@", temp.parsedPhone);
                    NSString *t1 = temp.parsedPhone;
                    NSString *t2 = [temp2 valueForKey:@"phoneNumber"];
                    
                    if([t1 isEqualToString: t2]){
//                        NSLog(@"%@", @"DA");
//                    if([temp.parsedPhone isEqualToString:[temp2 valueForKey:@"phoneNumber"]]) {
//
                        [temp setNickname:[temp2 valueForKey:@"nickname"]];
                        [temp setLatitude:[temp2 valueForKey:@"currentLocationLat"]];
                        [temp setLongitude:[temp2 valueForKey:@"currentLocationLon"]];
                        exists = YES;
                    }
                }
                if(!exists) {
                    NSLog(@"%@", temp.parsedPhone);
                    [_friendObjectArray removeObject:temp];
                    i--;
                }
            }
            [self.tableView reloadData];
        }];
    }
    
}

// Get the contacts.
- (void)getContactsWithAddressBook:(ABAddressBookRef)addressBook withHandler:(AddresBookFetchResult)handler{
    
    NSMutableArray *contactList = [[NSMutableArray alloc] init];
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
        
        //For Images
        NSData *imgData = (__bridge NSData *)ABPersonCopyImageData(ref);
        if (imgData != nil) {
            [dOfPerson setObject:imgData forKey:@"imageThumbnail"];
        } 
        
        
//        UIImage *img = [UIImage imageWithData:imgData];
        
        
        
        
//        ABMutableMultiValueRef image  = ABRecordCopyValue(ref, kABPersonImageFormatThumbnail);
//        if(ABMultiValueGetCount(image) > 0) {
//            [dOfPerson setObject:(__bridge UIImage *)ABMultiValueCopyValueAtIndex(image, 0) forKey:@"image"];
//        }
        
        //For Phone number
        NSString* mobileLabel;
        
//        NSLog(@"%@", dOfPerson);
        
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
            
            Friend *friend = [[Friend alloc] init];
            [friend setRawPhone:object[@"Phone"]];

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
            
            [friend setParsedPhone:object[@"Phone"]];
            [friend setImageData:object[@"imageThumbnail"]];
            if (friend.rawPhone != nil)
                [_friendObjectArray addObject:friend];
//            NSLog(@"%@", object[@"imageThumbnail"]);  // matrix
        }
        
    }
    
    
    //    NSLog(@"Contacts = %@", phoneNumbers);
    
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"phoneNumber" containedIn:phoneNumbers];
    [query findObjectsInBackgroundWithBlock:^(NSArray *userObjects, NSError *error) {
        
        if (!error) {
            if(handler)
            {
                handler(userObjects, error);
            }
            else
            {
                handler(nil, error);
            }
            NSLog(@"Successfully retrieved.");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _friendsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
//    cell.textLabel.text = [[_friendsArray objectAtIndex:indexPath.row] valueForKey:@"nickname"];
//    cell.imageView.image = [UIImage imageWithData: [[[_friendsArray objectAtIndex:indexPath.row] valueForKey:@"imageData"] valueForKey:@"imageData"]];
    
    cell.textLabel.text = [[_friendObjectArray objectAtIndex:indexPath.row] nickname];
    cell.imageView.image = [UIImage imageWithData:[[_friendObjectArray objectAtIndex:indexPath.row] imageData]];
    if(cell.imageView.image == nil)
        cell.imageView.image = [UIImage imageNamed:@"u.png"];
    
    cell.imageView.image = [self image:cell.imageView.image scaledToSize:CGSizeMake(40, 40)];
    cell.imageView.layer.cornerRadius = 20;
    cell.imageView.layer.masksToBounds = YES;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendDetailsViewController *detailsViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendDetailsViewController"];
    detailsViewCtrl.currentFriend = [_friendObjectArray objectAtIndex:indexPath.row];
    
    NSString *username = [[_friendsArray objectAtIndex:indexPath.row] valueForKey:@"nickname"];
    NSString *phonenumber = [[_friendsArray objectAtIndex:indexPath.row] valueForKey:@"phoneNumber"];
    NSString *lat = [[_friendsArray objectAtIndex:indexPath.row] valueForKey:@"currentLocationLat"];
    
    NSString *lon = [[_friendsArray objectAtIndex:indexPath.row] valueForKey:@"currentLocationLon"];
    
    
    [detailsViewCtrl setUsername:username];
    [detailsViewCtrl setPhonenumber:phonenumber];
    [detailsViewCtrl setLat:lat];
    [detailsViewCtrl setLong:lon];
    
    
    [self.navigationController pushViewController:detailsViewCtrl animated:YES];
}

- (UIImage *)image:(UIImage *)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, image.scale);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
