extends Node2D

enum {
	CLEAR_SKY_DAY,
	CLEAR_SKY_NIGHT,
	FEW_CLOUDS_DAY,
	FEW_CLOUDS_NIGHT,
	SCATTERED_CLOUDS_DAY,
	SCATTERED_CLOUDS_NIGHT,
	BROKEN_CLOUDS_DAY,
	BROKEN_CLOUDS_NIGHT,
	SHOWER_RAIN_DAY,
	SHOWER_RAIN_NIGHT,
	RAIN_DAY,
	RAIN_NIGHT,
	THUNDERSTORM_DAY,
	THUNDERSTORM_NIGHT,
	SNOW_DAY,
	SNOW_NIGHT,
	MIST_DAY,
	MIST_NIGHT,
	ERROR
	
}

var current_weather: int
var weather_data: Dictionary

var weather_icon_dict = {
	"01d" : CLEAR_SKY_DAY,
	"01n" : CLEAR_SKY_NIGHT,
	"02d" : FEW_CLOUDS_DAY,
	"02n" : FEW_CLOUDS_NIGHT,
	"03d" : SCATTERED_CLOUDS_DAY,
	"03n" : SCATTERED_CLOUDS_NIGHT,
	"04d" : BROKEN_CLOUDS_DAY,
	"04n" : BROKEN_CLOUDS_NIGHT,
	"09d" : SHOWER_RAIN_DAY,
	"09n" : SHOWER_RAIN_NIGHT,
	"10d" : RAIN_DAY,
	"10n" : RAIN_NIGHT,
	"11d" : THUNDERSTORM_DAY,
	"11n" : THUNDERSTORM_NIGHT,
	"13d" : SNOW_DAY,
	"13n" : SNOW_NIGHT,
	"50d" : MIST_DAY,
	"50n" : MIST_NIGHT
}

func _ready() -> void:
	_on_ScreenRefreshTimer_timeout()

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var json = JSON.parse(body.get_string_from_utf8())
	weather_data = json.result
	print(weather_data)
	
	$Data/Location.text = (weather_data["name"] if weather_data["name"] != '' else "Please Give correct coordinates") + (',\n' + weather_data["sys"]["country"] if "country" in weather_data["sys"] else "")
	$Data/Temp_Data.text = String(weather_data["main"]["temp"]) + " C"
	$Data/Feels_Like_Data.text = String(weather_data["main"]["feels_like"]) + " C"
	$Data/Weather.text = weather_data["weather"][0]["description"].capitalize()
	
	var weather_icon = weather_data["weather"][0]["icon"]
	set_weather_icon(weather_icon)

func send_http_request(latitude: float, longitude: float, app_id: String, units: String) -> void:
	$HTTPRequest.request("https://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid={AppID}&units={Units}".format({
		"latitude": latitude,
		"longitude": longitude,
		"AppID" : app_id,
		"Units" : units
	}))

func set_weather_icon(weather_icon: String) -> void:
	match weather_icon:
		"01d":
			$Weather_Icon.frame = 0
		"01n":
			$Weather_Icon.frame = 1
		"02d":
			$Weather_Icon.frame = 2
		"02n":
			$Weather_Icon.frame = 3
		"03d", "03n":
			$Weather_Icon.frame = 4
		"04d", "04n":
			$Weather_Icon.frame = 5
		"09d", "09n":
			$Weather_Icon.frame = 6
		"10d":
			$Weather_Icon.frame = 7
		"10n":
			$Weather_Icon.frame = 8
		"11d", "11n":
			$Weather_Icon.frame = 9
		"13d", "13n":
			$Weather_Icon.frame = 10
		"50d", "50n":
			$Weather_Icon.frame = 11
		


func _on_ScreenRefreshTimer_timeout() -> void:
	send_http_request(float($Data/Lat_Input.get_line_wrapped_text(0)[0]), float($Data/Lon_Input.get_line_wrapped_text(0)[0]), "0e86960512d6c13787a07e2f982804ca", "metric")


func _on_Lat_Input_text_changed() -> void:
	# $Data/Lat_Input.text = String(clamp(float($Data/Lat_Input.get_line_wrapped_text(0)[0]), -90, 90))
	_on_ScreenRefreshTimer_timeout()


func _on_Lon_Input_text_changed() -> void:
	_on_ScreenRefreshTimer_timeout()


func _on_Lat_Input_focus_exited() -> void:
	_on_ScreenRefreshTimer_timeout()


func _on_Lon_Input_focus_exited() -> void:
	_on_ScreenRefreshTimer_timeout()
