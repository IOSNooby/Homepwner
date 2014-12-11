//
//  INWitem.h
//  Homepwner
//
//  Created by Zenjougahara on 12/10/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INWitem : NSObject

@property (nonatomic,strong) NSString* itemName;
@property (nonatomic,strong) NSString* serialNumber;
@property (nonatomic) NSInteger valueInDollars;
@property (nonatomic,strong) NSDate* dateCreated;

+(INWitem*) randomItem;

@end
