//
// Created by David Newman on 3/8/16.
// Copyright (c) 2016 bluefletch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PETPet.h"

@class PETPet;


@interface PETPetService : NSObject

NS_ASSUME_NONNULL_BEGIN
- (PETPet *)createPetWithName:(NSString *)name;
- (NSArray<PETPet *> *)getAllPets;
- (PETTask *)createTaskForPet:(PETPet *)pet withName:(NSString *)name frequency:(NSTimeInterval)frequency;
NS_ASSUME_NONNULL_END

- (void)updatePet:(PETPet *)pet;
@end