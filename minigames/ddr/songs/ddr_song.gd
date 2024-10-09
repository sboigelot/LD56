extends Resource
class_name DdrSong

@export var music_track:MusicTrack
@export var notes:Array[DdrNote]

func play_music():
	Game.play_song(music_track, true)
