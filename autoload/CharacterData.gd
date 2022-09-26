extends Resource
class_name CharacterData

export (bool) var unlocked
export (PoolIntArray) var score := empty_array()
export (PoolIntArray) var retry_count := empty_array()

static func empty_array() -> PoolIntArray:
	var arr := []
	arr.resize(8)
	arr.fill(0)
	return PoolIntArray(arr)
