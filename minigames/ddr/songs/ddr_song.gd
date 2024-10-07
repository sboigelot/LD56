extends Resource
class_name DdrSong

@export var music_track:MusicTrack
@export var notes:Array[DdrNote]

func play_music():
	MusicManager.play_song.emit(music_track, false, true, 0.1)
