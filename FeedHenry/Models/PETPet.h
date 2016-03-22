//
// Created by David Newman on 3/7/16.
// Copyright (c) 2016 bluefletch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PETTask;

@interface PETPet : NSObject

typedef NS_ENUM(NSInteger, PetStatus) {
    PetStatusNeedsAttention, PetStatusWillNeedAttention, PetStatusDoesntNeedAttention
};

NS_ASSUME_NONNULL_BEGIN
@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSMutableArray<PETTask *> *tasks;
@property(nonatomic, readonly) PetStatus status;
- (instancetype)initWithName:(NSString *)name uid:(NSString *)uid;
+ (instancetype)petWithName:(NSString *)name uid:(NSString *)uid;
+ (instancetype)petWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name;

- (instancetype)initWithName:(NSString *)name uid:(NSString *)uid tasks:(NSMutableArray *)tasks;

+ (instancetype)petFromDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary;

+ (instancetype)petWithName:(NSString *)name uid:(NSString *)uid tasks:(NSMutableArray *)tasks;

+ (NSString *)stringFromPetStatus:(PetStatus)status;
NS_ASSUME_NONNULL_END

@property(nullable, nonatomic, copy) NSString *uid;


@end