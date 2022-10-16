import XCTest
import MyLibrary
@testable import MyLibrary
final class MyLibraryTests: XCTestCase {
    func testIsLuckyBecauseWeAlreadyHaveLuckyNumber() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(8)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsLuckyBecauseWeatherHasAnEight() async throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: true
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(0)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsNotLucky() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == false)
    }

    func testIsNotLuckyBecauseServiceCallFails() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: false,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then
        XCTAssertNil(isLuckyNumber)
    }
    func testGetTemperature() async {
        let mockWeatherService = MockWeatherService(
            shouldSucceed: false,
            shouldReturnTemperatureWithAnEight: false
        )
        let myLibrary = MyLibrary(weatherService: mockWeatherService)
        // When
        let temp = await myLibrary.GetStandardTemperature()
        // Then
        XCTAssertNotNil(temp)
    }
//    func testGetTemperatureFromWeatherServiceImpl() async {
//        let thisService = WeatherServiceImpl()
//        thisService.myURL = .local
//        let temperature = try await thisService.getTemperature()
////        return temperature
//    }
    func testGetTemperatureFromWeatherServiceImpl() async {
        // Check the simple case first: 3, 5 and 8 are automatically lucky.
        do
        {
            print("GetStandardTemperature")
            let thisService = WeatherServiceImpl()
            thisService.myURL = .local
            let temperature = try await thisService.getTemperature()
            XCTAssertNotNil(temperature)
        }
        catch
        {
            XCTAssert(false)
        }
    }
}
