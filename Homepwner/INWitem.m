//
//  INWitem.m
//  Homepwner
//
//  Created by Zenjougahara on 12/10/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import "INWitem.h"

@interface INWitem()

@property (strong,nonatomic) NSString* myUUID;

@end

@implementation INWitem


-(INWitem*) init{
    self = [super init];
    if(self){
        [self autoCreateUUIDForThisItem];
         self.hasImage = NO;
    }
    return  self;
}


-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _itemName = [aDecoder decodeObjectForKey:@"itemName"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _valueInDollars = [aDecoder decodeObjectForKey:@"valueInDollars"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        
        _myUUID = [aDecoder decodeObjectForKey:@"myUUID"];

        _hasImage = [aDecoder decodeBoolForKey:@"hasImage"];
        
        /*
        NSData * thumbData = [aDecoder decodeObjectForKey:@"thumb"];
        
        id x =[NSKeyedUnarchiver unarchiveObjectWithData:thumbData];
        if([x isKindOfClass:[UIImage class]]){
            _thumb = x;
        } */
        
        _thumb = [aDecoder decodeObjectForKey:@"thumb"];
    
    }
    return self;
}



/*+(NSArray*) nameList{
    return   @[@"John",@"Sven",@"Mirana",@"Butcher",@"Lois"
               ,@"Ommy",@"Cammy",@"Sagat",@"Juri"];;
}  

//+(NSArray*) serialNumList{
    return @[@"111",@"222",@"333",@"444",@"555",@"666",@"777",@"888"];
}
*/

+(INWitem*) createBlankItem{
    INWitem* item = [[INWitem alloc]init];
    return item;
}

-(void) autoCreateUUIDForThisItem{
    NSUUID* myID = [NSUUID UUID];
    NSString* gotID = [myID UUIDString];
    self.myUUID = gotID;
}


#pragma mark NSCoding Protocol

-(void) encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.myUUID forKey:@"myUUID"];
    
    [aCoder encodeBool:self.hasImage forKey:@"hasImage"];
    
    [aCoder encodeObject:self.thumb forKey:@"thumb"];
    /*
    NSData*  thumbData = [NSKeyedArchiver archivedDataWithRootObject:self.thumb];
    [aCoder encodeObject:thumbData forKey:@"thumb"];
    */
}

#pragma mark Unused (Oldversion)
/*
+(INWitem*) randomItem{
    
    INWitem * item = [[INWitem alloc]init];
    // random Value
    item.valueInDollars = [NSNumber numberWithInteger: (arc4random() % 100000) +1];
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

*/

@end
