//
//  DataProvider.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 20.03.2026.
//

import Foundation

protocol DataProviderProtocol {
    func getData(from forecastResponse: ForecastResponse) -> WeatherForecastData
}

final class DataProvider: DataProviderProtocol {
    func getData(from forecastResponse: ForecastResponse) -> WeatherForecastData {
        
        let currentDay = forecastResponse.forecast.forecastdays.first
        
        let currentWeatherData = CurrentWeatherData(location: forecastResponse.location.name,
                                                    temperature: temp(from: forecastResponse.current.tempC),
                                                    imageUrl: forecastResponse.current.condition.icon,
                                                    condition: forecastResponse.current.condition.text,
                                                    highLowTemp: highLowTemp(from: currentDay?.day.maxTempC ?? 0.0,
                                                                             and: currentDay?.day.minTempC ?? 0.0))
        
        let dailyForecastDatas = daysData(from: forecastResponse)
        let hoursData = hoursData(from: forecastResponse)
        
        return WeatherForecastData(currentWeatherData: currentWeatherData,
                                   dailyForecastData: dailyForecastDatas,
                                   hourlyForecastData: hoursData)
        
    }
    
    private func hoursData(from forecastResponse: ForecastResponse) -> [HourlyForecastData] {
        let days = forecastResponse.forecast.forecastdays
            let today = days[0]
            let tommorow = days[1]
        
        var hoursToShow: [Hour] = []
        hoursToShow.append(contentsOf: remainingHoursFor(today))
        hoursToShow.append(contentsOf: tommorow.hours)
        
        var hoursData: [HourlyForecastData] = []
        
        for hour in hoursToShow {
            let hourDate = Date(timeIntervalSince1970: TimeInterval(hour.timeEpoch))
            let hourData = HourlyForecastData(time: hourStr(from: hourDate),
                                              temperature: temp(from: hour.tempC),
                                              imaageUrl: hour.condition.icon)
            
            hoursData.append(hourData)
        }
        return hoursData
    }
    
    private func remainingHoursFor(_ today: ForecastDay) -> [Hour] {
        let remainingHours = today.hours.filter{
            let hourDate = Date(timeIntervalSince1970: TimeInterval($0.timeEpoch))
            return isHourRemain(hourDate)
        }
        return remainingHours
    }
    
    private func isHourRemain(_ hourDate: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: hourDate)
        let hour = components.hour ?? 0
        
        let currentHour = calendar.dateComponents([.hour], from: Date()).hour ?? 0
        
        return hour >= currentHour
    }
    
    private func daysData(from forecastResponse: ForecastResponse) -> [DailyForecastData] {
        let days = forecastResponse.forecast.forecastdays
        var dailyDatas: [DailyForecastData] = []
        
        for day in days {
            let dayDate = dateFromResponse(day.date)
            let weekDay = self.weekday(from: dayDate)
            
            let data = DailyForecastData(day: isToday(dayDate) ? "Today" : weekDay,
                                              condition: day.day.condition.text,
                                              imageUrl: day.day.condition.icon,
                                              highTempC: temp(from: day.day.maxTempC),
                                              lowTempC: temp(from: day.day.minTempC))
            dailyDatas.append(data)
        }
        return dailyDatas
    }
    
    func isToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        
        return calendar.isDate(date, equalTo: today, toGranularity: .day)
    }
    
    private func dateFromResponse(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateString)
        return date ?? Date()
    }
    
    private func hourStr(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: date)
    }
    
    private func weekday(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
 
    private func highLowTemp(from high: Double, and low: Double) -> String {
        let highStr = high.formatted(.number.precision(.fractionLength(0)))
        let lowStr = low.formatted(.number.precision(.fractionLength(0)))
        
        return "H: \(highStr)° L: \(lowStr)°"
    }
    
    private func temp(from value: Double) -> String {
        let string = value.formatted(.number.precision(.fractionLength(0)))
        return "\(string)°"
    }
}
