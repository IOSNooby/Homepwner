//
//  INWItemStore.m
//  Homepwner
//
//  Created by Zenjougahara on 12/10/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import "INWItemStore.h"
#import "INWitem.h"

@interface INWItemStore()

@property (strong ,nonatomic) NSMutableArray* privateItems;

@end


@implementation INWItemStore


#pragma mark 

-(NSMutableArray*) privateItems{
    if(!_privateItems){
        _privateItems = [[NSMutableArray alloc]init];
    }
    return _privateItems;
}

// singleton paradigm

+(instancetype) sharedStore{
    static INWItemStore* store = nil;
    if(!store){
        store = [[self alloc]initwithPrivate];
    }
    return store;
}

-(instancetype) initwithPrivate{
    return [super init];
}

/// if user call init , warn him to use others method

-(instancetype) init{
    @throw  [NSException exceptionWithName:@"Singleton"
                   reason:@"You Noob !!,go USE +[INWItemstore sharedStore] method instead !!"
                   userInfo:nil];
    return nil;
}

///

-(INWitem*) createINWItem {
    INWitem * item = [INWitem randomItem];
    // everytime item created , store it to Array ! (store pointer)
    [self.privateItems addObject: item];
    return item;
   
}

-(NSMutableArray*) allItems{
    return [self.privateItems copy];
}
@end
