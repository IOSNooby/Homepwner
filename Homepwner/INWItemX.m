//
//  INWItemX.m
//  Homepwner
//
//  Created by Padme on 5/20/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import "INWItemX.h"


@implementation INWItemX

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic hasImage;
@dynamic thumb;
@dynamic myUUID;
@dynamic orderInTVC;
@dynamic newRelationship;


-(void) awakeFromInsert{
     [super awakeFromInsert];
     [self autoCreateUUIDForThisItem];
}


#pragma mark Helper Methods


-(void) autoCreateUUIDForThisItem{
    NSUUID* myID = [NSUUID UUID];
    NSString* gotID = [myID UUIDString];
    self.myUUID = gotID;
}
@end
