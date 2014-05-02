//
//  LyricLine.h
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.05.01..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricLine : NSObject

@property double time;
@property (strong, nonatomic) NSString *lyric;

-(id)initWithTime:(double)seconds Lyric:(NSString*) text;

@end
