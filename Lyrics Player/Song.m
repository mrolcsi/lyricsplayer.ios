//
//  Song.m
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.07..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import "Song.h"

@implementation Song

-(id)initWithArtist:(NSString *)artist Title:(NSString *)title Album:(NSString *)album CoverImage:(UIImage *)cover DurationInMilliseconds:(NSInteger)duration{
    
    self = [super init];
    if (self){
        _artist = artist;
        _title = title;
        _album = album;
        _cover = cover;
        _duration = duration;
    }
    return self;
}

-(NSString *)getDurationString{
    long mins = _duration / 60000;
    int seconds = (_duration /10000) % 60;
    
    return [NSString stringWithFormat:@"%ld:%d", mins, seconds];
}

@end
