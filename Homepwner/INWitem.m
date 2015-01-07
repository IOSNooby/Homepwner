//
//  INWitem.m
//  Homepwner
//
//  Created by Zenjougahara on 12/10/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import "INWitem.h"

@interface INWitem()

@property (strong,nonatomic) NSArray* nameList;
@property (strong,nonatomic) NSArray* serialNumList;

@end

@implementation INWitem

+(NSArray*) nameList{
    return   @[@"John",@"Sven",@"Mirana",@"Butcher",@"Lois"
               ,@"Ommy",@"Cammy",@"Sagat",@"Juri"];;
}

+(NSArray*) serialNumList{
    return @[@"111",@"222",@"333",@"444",@"555",@"666",@"777",@"888"];
}

+(INWitem*) randomItem{
    
    INWitem * item = [[INWitem alloc]init];
    // random Value
    item.valueInDollars=  arc4random() % 20;
    // random Serial
    NSArray* arraySerial = self.serialNumList;
    item.serialNumber = arraySerial[ arc4random() % [arraySerial count]];
    // random Name
    NSArray* arrayName = self.nameList;
    item.itemName = arrayName [ arc4random() % [arrayName count]];
    
    NSDate * currentDate = [NSDate date];
    item.dateCreated = currentDate;
    
    return item ;
}


@end
