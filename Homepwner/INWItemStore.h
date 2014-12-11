//
//  INWItemStore.h
//  Homepwner
//
//  Created by Zenjougahara on 12/10/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INWitem;

@interface INWItemStore : NSObject

+(instancetype) sharedStore;
-(INWitem*) createINWItem;
-(NSMutableArray*) allItems;
@end
