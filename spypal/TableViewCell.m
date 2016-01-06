//
//  TableViewCell.m
//  spypal
//
//  Created by Andrei Constantinescu on 27/04/15.
//  Copyright (c) 2015 Andrei Constantinescu. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    NSLog(@"cell selected");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    NSLog(@"cell selected");
    // Configure the view for the selected state
}

@end
