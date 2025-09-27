import os
from typing import Optional

import requests
from langchain.pydantic_v1 import BaseModel, Field
from langchain_core.tools import tool


class WeatherInput(BaseModel):
    city: str = Field(..., description="The city name to get weather for")
    state: str = Field(
        ..., description="The two letter state abbreviation to get weather for"
    )
    country: Optional[str] = Field(
        "usa", description="The two letter country abbreviation to get weather for"
    )



@tool("weather-data", args_schema=WeatherInput, return_direct=True)
def weather_data(city: str, state: str, country: str = "usa") -> dict:
    """Get the current temperature for a city."""
    # 检查是否使用测试模式
    use_test_mode = os.environ.get("WEATHER_TEST_MODE", "true").lower() == "true"
    
    if use_test_mode:
        # 返回测试数据，跳过实际的API调用
        print(f"🌤️ 测试模式：为 {city}, {state}, {country} 返回模拟天气数据")
        return {
            "city": city,
            "state": state,
            "country": country,
            "temperature": 22,  # 模拟温度
            "description": "晴天，适合外出",
            "humidity": "65%",
            "wind_speed": "5 mph",
            "test_mode": True
        }
    
    # 生产模式：使用真实的API调用
    geocode_api_key = os.environ.get("GEOCODE_API_KEY")
    if not geocode_api_key:
        raise ValueError("Missing GEOCODE_API_KEY secret.")

    geocode_url = f"https://geocode.xyz/{city.lower()},{state.lower()},{country.lower()}?json=1&auth={geocode_api_key}"
    geocode_response = requests.get(geocode_url)
    if not geocode_response.ok:
        print("No geocode data found.")
        raise ValueError("Failed to get geocode data.")
    geocode_data = geocode_response.json()
    latt = geocode_data["latt"]
    longt = geocode_data["longt"]

    weather_gov_url = f"https://api.weather.gov/points/{latt},{longt}"
    weather_gov_response = requests.get(weather_gov_url)
    if not weather_gov_response.ok:
        print("No weather data found.")
        raise ValueError("Failed to get weather data.")
    weather_gov_data = weather_gov_response.json()
    properties = weather_gov_data["properties"]

    forecast_url = properties["forecast"]
    forecast_response = requests.get(forecast_url)
    if not forecast_response.ok:
        print("No forecast data found.")
        raise ValueError("Failed to get forecast data.")
    forecast_data = forecast_response.json()
    periods = forecast_data["properties"]["periods"]
    today_forecast = periods[0]

    return {
        "city": city,
        "state": state,
        "country": country,
        "temperature": today_forecast["temperature"],
    }
