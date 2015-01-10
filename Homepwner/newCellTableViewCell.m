//
//  newCellTableViewCell.m
//  Homepwner
//
//  Created by Zenjougahara on 1/10/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import "newCellTableViewCell.h"

@implementation newCellTableViewCell

- (void)awakeFromNib {
    
    NSLog(@"newCell told Iam Awake from NIB ");
    //[self.ContentView addSubview:self.myLabel];
 //   [self.ContentView addSubview:self.onOff];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
