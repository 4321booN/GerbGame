extends Node

var is_music_playing

func _ready():
	is_music_playing = false
	unmute()

func Main_TitleMenuSoundtrack():
	if not is_music_playing:
		$Main_TitleMenuSoundtrack.play()
		is_music_playing = true

func _on_MainTitleMenuSoundtrack_finished():
	is_music_playing = false

func Main_GameplaySoundrack():
	if not is_music_playing:
		$Main_GameplaySoundtrack.play()
		is_music_playing = true

func _on_MainGamplaySoundtrack_finished():
	is_music_playing = false

func stop():
	$Main_GameplaySoundtrack.stop()
	$Main_TitleMenuSoundtrack.stop()

func mute():
	$Main_GameplaySoundtrack.stream_paused = true
	$Main_TitleMenuSoundtrack.stream_paused = true

func unmute():
	$Main_GameplaySoundtrack.stream_paused = false
	$Main_TitleMenuSoundtrack.stream_paused = false
