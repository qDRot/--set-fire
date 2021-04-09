extends Node

# Effects
enum {
	NORMAL,
	CLEAN,
	KNIFE,
	GOMI,
	KOMA_A,
	SICK,
	KOMA_UM = 30
}

var obtainedEffects = [NORMAL, KNIFE, SICK, GOMI]
var state = KNIFE
