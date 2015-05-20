//
//  INWItemX.h
//  Homepwner
//
//  Created by Padme on 5/20/15.
//  Copyright (c) 2015 Zenjougahara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface INWItemX : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic) int * valueInDollars;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * hasImage;
@property (nonatomic, strong) UIImage *  thumb;
@property (nonatomic, retain) NSString * myUUID;
@property (nonatomic) double orderInTVC;
@property (nonatomic, retain) NSManagedObject *newRelationship;

@end
