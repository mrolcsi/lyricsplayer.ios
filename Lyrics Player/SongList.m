//
//  SongList.m
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.07..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import "SongList.h"
#import "Song.h"
#import "SongListCell.h"

@implementation SongList

-(id)initWithTestData{
    self = [super init];
    if (self){
        Song *vivalavida = [[Song alloc]initWithFile:[[NSBundle mainBundle] pathForResource:@"Coldplay - Viva la Vida.mp3" ofType:nil]];
        Song *thriftshop = [[Song alloc]initWithFile:[[NSBundle mainBundle] pathForResource:@"Macklemore & Ryan Lewis - Thrift Shop (feat. Wanz).mp3" ofType:nil]];
        Song *staythenight = [[Song alloc]initWithFile:[[NSBundle mainBundle] pathForResource:@"Zedd - Stay The Night (feat. Hayley Williams Of Paramore).mp3" ofType:nil]];
        Song *digitallove = [[Song alloc]initWithFile:[[NSBundle mainBundle] pathForResource:@"Daft Punk - Digital Love.mp3" ofType:nil]];
        
        _songs =[[NSMutableArray alloc]initWithObjects: vivalavida, digitallove, thriftshop, staythenight, nil];
        
    }
    return self;
}

-(void)addSong:(Song *) song{
    if (_songs) [_songs addObject:song];
}

-(void)removeSong:(Song *) song{
    if (_songs) [_songs removeObject:song];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_songs count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SongCell";
    
    SongListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell) {
        cell = [[SongListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Song *song = [_songs objectAtIndex:indexPath.row];
    
    cell.lblArtist.text = song.artist;
    cell.lblTitle.text = song.title;
    cell.imgCover.image = song.cover;
    cell.lblDuration.text = [song getTotalTimeString];
    
    return cell;
}

@end
