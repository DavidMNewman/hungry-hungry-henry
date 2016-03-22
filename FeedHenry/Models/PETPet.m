//
// Created by David Newman on 3/7/16.
// Copyright (c) 2016 bluefletch. All rights reserved.
//

#import "PETPet.h"
#import "PETTask.h"


@implementation PETPet {

}

- (instancetype)initWithName:(NSString *)name uid:(NSString *)uid {
    self = [super init];
    if (self) {
        self.name = name;
        self.uid = uid;
    }

    return self;
}

+ (instancetype)petWithName:(NSString *)name uid:(NSString *)uid {
    return [[self alloc] initWithName:name uid:uid];
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.tasks = [NSMutableArray new];
    }

    return self;
}

+ (instancetype)petWithName:(NSString *)name {
    return [[self alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString *)name uid:(NSString *)uid tasks:(NSMutableArray *)tasks {
    self = [super init];
    if (self) {
        self.uid = uid;
        self.name = name;
        self.tasks = tasks;
    }

    return self;
}

+ (instancetype)petWithName:(NSString *)name uid:(NSString *)uid tasks:(NSMutableArray *)tasks {
    return [[self alloc] initWithName:name uid:uid tasks:tasks];
}


- (PetStatus)status {
    __block PetStatus status = PetStatusDoesntNeedAttention;
    [_tasks enumerateObjectsUsingBlock:^(PETTask *task, NSUInteger idx, BOOL *stop) {
        switch (task.status) {
            // The highest priority a pet can have is Needs Attention, so we stop enumerating if that is the status.
            case TaskStatusNeedsAttention:
                status = PetStatusNeedsAttention;
                *stop = YES;
                break;
            case TaskStatusWillNeedAttention:
                status = PetStatusWillNeedAttention;
                break;
            case TaskStatusDoesntNeedAttention:
                break;
        }
    }];

    return status;
}

+ (NSString *)stringFromPetStatus:(PetStatus)status {
    NSString *statusString;

    switch (status) {
        case PetStatusWillNeedAttention:
            statusString = @"Will Need Attention";
            break;
        case PetStatusDoesntNeedAttention:
            statusString = @"No Attention Needed";
            break;
        default:
            statusString = @"Needs Attention";
            break;
    }

    return statusString;
}

+ (instancetype)petFromDictionary:(nonnull NSDictionary *)dictionary {
    NSMutableArray *tasks = @[].mutableCopy;
    for (NSDictionary *dict in dictionary[@"tasks"]) {
        [tasks addObject:[PETTask taskFromDictionary:dict]];
    }

    return [[self alloc] initWithName:dictionary[@"name"] uid:@"uid" tasks:tasks];
}

- (NSDictionary *)toDictionary {
    NSMutableArray *tasks = [NSMutableArray arrayWithCapacity:self.tasks.count];
    for (PETTask *task in self.tasks) {
        [tasks addObject:[task toDictionary]];
    }

    return @{@"name" : self.name, @"tasks" : tasks};
}


@end