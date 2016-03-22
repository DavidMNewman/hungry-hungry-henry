//
// Created by David Newman on 3/7/16.
// Copyright (c) 2016 bluefletch. All rights reserved.
//

#import "PETPetTableViewCell.h"
#import "PETPet.h"

@implementation PETPetTableViewCell {

}

- (void)bindPetModel:(PETPet *)pet {
    _nameLabel.text = pet.name;

}



@end