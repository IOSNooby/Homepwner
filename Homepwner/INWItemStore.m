//
//  INWItemStore.m
//  Homepwner
//
//  Created by Zenjougahara on 12/10/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import "INWItemStore.h"
#import "INWitem.h"

static INWItemStore* store = nil;

@interface INWItemStore()

@property (strong ,nonatomic) NSMutableArray* privateItems;

@end


@implementation INWItemStore

#pragma mark Class Methods


+(instancetype) sharedStore{
    if(!store){
        store = [[self alloc]initWithPrivate];
    }
    return store;
}


#pragma mark Class Initializers

/// both init methods cant speak to the client.
/// you init only through sharedStore "Once".

-(instancetype) initWithPrivate{
    return [super init];
}


-(instancetype) init{
    @throw  [NSException exceptionWithName:@"Singleton"
                                    reason:@"You Noob !!,go USE +[INWItemstore sharedStore] method instead !!"
                                  userInfo:nil];
    return nil;
}


#pragma mark Lazy inits

-(NSMutableArray*) privateItems{
    if(!_privateItems){
        _privateItems = [[NSMutableArray alloc]init];
    }
    return _privateItems;
}


#pragma mark Methods 

-(INWitem*) createINWItem {

    INWitem * item = [INWitem randomItem];
    // everytime item created , store it to Array ! (store pointer)
    NSLog(@"random Item ? = %@",item);

    [self.privateItems addObject: item];
    return item;
   
}

-(void) moveItemFromIndex:(NSInteger)from
                  toIndex:(NSInteger)destination{
    
    INWitem* originalPosition = self.privateItems[from];
    
    [self.privateItems removeObjectIdenticalTo:originalPosition];
    [self.privateItems insertObject:originalPosition atIndex:destination];
    
}

-(void) removeItem:(INWitem *)itemToRemove{
    // removing base on memory Address in Heap
    
    [self.privateItems removeObjectIdenticalTo:itemToRemove];
}


-(NSMutableArray*) allItems{
    return [self.privateItems copy];
}
@end
