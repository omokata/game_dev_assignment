extends Node

const MAX_SENS: float = 0.01
var mouse_sens: float = 0.005

const MAX_DB: float = 24.0
const MIN_DB: float = -40.0
var bgm_db: float = -12.0
var sfx_db: float = -12.0

func set_mouse_sens(value: float):
	mouse_sens = value


func set_bgm_vol(value: float):
	bgm_db = value


func set_sfx_vol(value: float):
	sfx_db = value
