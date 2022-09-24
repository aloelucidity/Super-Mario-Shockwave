class_name math_util

static func change_max(value : float, old_max : float, new_max : float):
	var old_min = 0
	var new_min = 0
	return ( (value - old_min) / (old_max - old_min) ) * (new_max - new_min) + new_min

static func base64_encode_int(number : int):
	var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	var is_negative = false
	if str(number)[0] == "-":
		is_negative = true
		number = abs(number)
	
	if number == 0:
		return characters[0]
	var digits = []
	while number:
		digits.append(int(number % 64))
		number = floor(number / 64)
	
	var string = ""
	if is_negative:
		string = "-"
	for digit in digits:
		string += characters[digit]
	return string

static func base64_decode_int(number : String):
	number = number.strip_edges()
	number = number.strip_escapes()
	if number == "":
		return 0
	
	var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	var is_negative = false
	if number[0] == "-":
		is_negative = true
		number.erase(0, 1)
	
	var digits = []
	var index = 0
	for digit in number:
		var digit_int = characters.find(digit)
		digit_int = digit_int * pow(64, index)
		digits.append(digit_int)
		index += 1
		
	var final_number = 0
	for digit in digits:
		final_number += digit
	
	if is_negative:
		final_number = -final_number
	return final_number
