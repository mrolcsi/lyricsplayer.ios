//
//  SongList.h
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.07..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongList : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *songs;

-(id)initWithTestData;

@end
