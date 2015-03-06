//
//  INWItemStore.m
//  Homepwner
//
//  Created by Zenjougahara on 12/10/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import "INWItemStore.h"
#import "INWitem.h"
#import "ImageStore.h" 

static INWItemStore* store = nil;

@interface INWItemStore()

@property (strong ,nonatomic) NSMutableArray* privateItems;

@end


@implementation INWItemStore

#pragma mark Class Methods


+(instancetype) sharedStore{
    
    if(!store){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        store = [[self alloc]initWithPrivate];
    });
    }

    return store;
}




#pragma mark Class Initializers

/// both init methods cant speak to the client.
/// you init only through sharedStore "Once".

-(instancetype) initWithPrivate{
    self = [super init];
    if(self){
        BOOL success = [self loadingSavedStore];
        if(success){
            NSLog(@"load succeeded");
        }
    }
    
    return self;
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

    INWitem * item = [INWitem createBlankItem];
    // everytime item created , store it to Array ! (store pointer)
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
    [[ImageStore singletonImageStore] deleteImageByKey:itemToRemove.myUUID];
}


-(NSMutableArray*) allItems{
    return [self.privateItems copy];
}

-(NSInteger) lastObjectIndex{
    return   [self.privateItems count]-1;
}

#pragma mark Persistent Methods 

-(NSURL*) defaultsavePath{
    
    NSFileManager* manager = [[NSFileManager alloc]init];
    
    NSURL* original = [manager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSURL* destinationNEW  = [original URLByAppendingPathComponent:@"itemStore"];
    return destinationNEW;
}

-(BOOL) savingStore{
    
    NSData* finalDataToSave = [NSKeyedArchiver archivedDataWithRootObject:self.privateItems];
    return [finalDataToSave writeToURL:[self defaultsavePath]atomically:YES];
}

-(BOOL) loadingSavedStore{
    
    NSData * data =[[NSData alloc]initWithContentsOfURL:[self defaultsavePath]];
    if(data){
        id someFile = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([someFile isKindOfClass:[NSMutableArray class]]){
            self.privateItems = someFile;
            return YES;
        }
    }
    return NO;
}

@end
