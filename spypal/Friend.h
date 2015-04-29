//
//  Friend.h
//  spypal
//
//  Created by Andrei Constantinescu on 28/04/15.
//  Copyright (c) 2015 Andrei Constantinescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (strong, nonatomic) NSString *parsedPhone;
@property (strong, nonatomic) NSString *rawPhone;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@end
