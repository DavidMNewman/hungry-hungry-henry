//
// Created by David Newman on 3/8/16.
// Copyright (c) 2016 bluefletch. All rights reserved.
//

#import "PETPetService.h"
#import "PETTask.h"
@import FH.FHSyncClient;

NSString *const kFHPetDataId = @"pets";
NSString *const kFHPetTaskId = @"tasks";

@interface PETPetService ()

@property(nonatomic, strong) FHSyncClient *fhClient;

@end

@implementation PETPetService {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        _fhClient = [[FHSyncClient alloc] initWithConfig:[FHSyncConfig objectFromJSONData:@{}]];
        [_fhClient manageWithDataId:kFHPetDataId AndConfig:[FHSyncConfig objectFromJSONData:@{}] AndQuery:@{}];
    }

    return self;
}


- (PETPet *)createPetWithName:(nonnull NSString *)name {

    NSDictionary *dict = [_fhClient createWithDataId:kFHPetDataId AndData:@{@"name" : name}];
    PETPet *pet = [PETPet petFromDictionary:dict[@"data"]];
    pet.uid = dict[@"uid"];
    return pet;
}

- (NSArray<PETPet *> *)getAllPets {
    NSDictionary *petsDict = [_fhClient listWithDataId:kFHPetDataId];
    NSMutableArray<PETPet *> *pets = [NSMutableArray new];

    for (NSDictionary *petDict in petsDict.allValues) {
        PETPet *pet = [PETPet petFromDictionary:petDict[@"data"]];
        pet.uid = petDict[@"uid"];
        [pets addObject:pet];
    }

    return pets;
}

- (PETTask *)createTaskForPet:(PETPet *)pet withName:(NSString *)name frequency:(NSTimeInterval)frequency {
    PETTask *task = [PETTask taskWithName:name frequency:frequency];
    [pet.tasks addObject:task];
    [_fhClient updateWithDataId:kFHPetDataId AndUID:pet.uid AndData:[pet toDictionary]];
    return task;
}

- (void)updatePet:(PETPet *)pet {
    [_fhClient updateWithDataId:kFHPetDataId AndUID:pet.uid AndData:[pet toDictionary]];
}


@end