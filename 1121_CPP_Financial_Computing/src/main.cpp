// #include <ql/quantlib.hpp> // LNK1104 Error – Cannot Open QuantLib-x64-mt-gd.lib 錯誤無法排除 但不使嗽namespace就可以避免
#include <ql/qldefines.hpp>
#include <ql/math/distributions/normaldistribution.hpp>
#include <ql/time/all.hpp>
#include <ql/quotes/simplequote.hpp>
#include <ql/termstructures/yield/flatforward.hpp>
#include <ql/handle.hpp>
// #include <ql/pricingengines/all.hpp>
#include <numeric>
#include <fstream>
#include <sstream>
#include <vector>
#include <iostream>
#include <tuple>
#include <algorithm>

// using namespace QuantLib; // LNK1104 Error – Cannot Open QuantLib-x64-mt-gd.lib 錯誤無法排除 但不使嗽namespace就可以避免

// Function to convert a string date to QuantLib Date
QuantLib::Date parseDate(const std::string& dateStr) {
    std::istringstream iss(dateStr);
    QuantLib::Integer year, month, day;
    char dash;

    if (iss >> year >> dash >> month >> dash >> day) {
        return QuantLib::Date(day, QuantLib::Month(month), year);
    } else {
        // Return an invalid date if parsing fails
        return QuantLib::Date();
    }
}

// Function to read data for a specific date
std::tuple<QuantLib::Real, std::vector<QuantLib::Real>> readData(const std::string& filename, const QuantLib::Date& targetDate) {
    QuantLib::Real portfolioValue = 0.0;
    std::vector<QuantLib::Real> returns;
    std::ifstream file(filename);
    std::string line;

    std::getline(file, line);

    while (std::getline(file, line)) {
        std::istringstream iss(line);
        std::vector<std::string> fields;

        // Read the entire line into a stringstream
        std::stringstream lineStream(line);

        // Split the line into fields using ',' as the delimiter
        while (std::getline(lineStream, line, ',')) {
            // Convert "null" to 0.0 for numeric fields
            if (line == "null") {
                fields.push_back("0.0");
            } else {
                fields.push_back(line);
            }
        }

        // Convert the necessary fields to QuantLib::Real as needed
        QuantLib::Date date = parseDate(fields[0]);
        QuantLib::Real open = std::stod(fields[1]);
        // QuantLib::Real high = std::stod(fields[2]);
        // QuantLib::Real low = std::stod(fields[3]);
        QuantLib::Real close = std::stod(fields[4]);
        // QuantLib::Real adjClose = std::stod(fields[5]);
        // QuantLib::Real volume = std::stod(fields[6]);

        // Check if 'close' or 'open' is "null"
        if (open == 0.0 || close == 0.0) {
            continue;
        } else {
            QuantLib::Real dailyReturn = (close - open) / open;
            returns.push_back(dailyReturn);
        }

        if (date == targetDate) {
            // Use 'Close' price as the current portfolio value
            portfolioValue = close;
        }
    }

    // Return a default value if the date is not found
    return std::make_tuple(portfolioValue, returns);
}

// Function to calculate drawdown
QuantLib::Real drawdown(const std::vector<QuantLib::Real>& returns, QuantLib::Real portfolioValue) {
    QuantLib::Real peak = portfolioValue;
    QuantLib::Real currentPeak = portfolioValue;
    QuantLib::Real maxDrawdown = 0.0;

    for (const auto& dailyReturn : returns) {
        currentPeak = std::max(currentPeak, currentPeak * (1.0 + dailyReturn));
        maxDrawdown = std::min(maxDrawdown, portfolioValue - currentPeak);
    }

    return maxDrawdown;
}

// Historical Simulation for VaR
QuantLib::Real historicalVar(const std::vector<QuantLib::Real>& returns, QuantLib::Real portfolioValue, QuantLib::Real alpha) {
    std::vector<QuantLib::Real> losses;

    // std::ostringstream returnsString;
    // for (const auto& value : returns) {
    //     returnsString << value << " ";
    // }
    // std::cout << "returns: " << returnsString.str() << std::endl;

    for (const auto& dailyReturn : returns) {
        QuantLib::Real loss = portfolioValue * (1.0 + dailyReturn) - portfolioValue;
        losses.push_back(loss);
    }

    std::sort(losses.begin(), losses.end());
    QuantLib::Size varIndex = 0;
        if (!losses.empty()) {
            varIndex = static_cast<QuantLib::Size>(std::floor(alpha * losses.size()));
        }
    return losses[varIndex];
}

// Function to calculate conditional value at risk (CVaR)
QuantLib::Real conditionalVar(const std::vector<QuantLib::Real>& returns, QuantLib::Real portfolioValue, QuantLib::Real alpha) {
    std::vector<QuantLib::Real> losses;

    for (const auto& dailyReturn : returns) {
        QuantLib::Real loss = portfolioValue * (1.0 + dailyReturn) - portfolioValue;
        losses.push_back(loss);
    }

    std::sort(losses.begin(), losses.end());
    QuantLib::Size cvarIndex = static_cast<QuantLib::Size>(std::floor(alpha * losses.size()));

    QuantLib::Real cvar = 0.0;
    if (cvarIndex > 0) {
        cvar = -std::accumulate(losses.begin(), losses.begin() + cvarIndex, 0.0) / cvarIndex;
    }

    return cvar;
}

// Variance-Covariance Method for VaR
QuantLib::Real varianceCovarianceVar(const std::vector<QuantLib::Real>& returns, QuantLib::Real portfolioValue, QuantLib::Real alpha) {
    QuantLib::Real meanReturn = 0.0;
    if (!returns.empty()) {
        meanReturn = std::accumulate(returns.begin(), returns.end(), 0.0) / returns.size();
    }

    QuantLib::Real sumSquaredDeviations = 0.0;
    for (const auto& dailyReturn : returns) {
        sumSquaredDeviations += std::pow(dailyReturn - meanReturn, 2);
    }

    QuantLib::Real dailyVolatility = std::sqrt(sumSquaredDeviations / (returns.size() - 1));
    QuantLib::Real annualizedVolatility = dailyVolatility * std::sqrt(252);

    return portfolioValue * annualizedVolatility * QuantLib::InverseCumulativeNormal()(alpha);
}

// Function to calculate parameter value at risk (Parametric VaR)
QuantLib::Real parametricVar(const std::vector<QuantLib::Real>& returns, QuantLib::Real portfolioValue, QuantLib::Real alpha) {
    QuantLib::Real meanReturn = 0.0;
    if (!returns.empty()) {
        meanReturn = std::accumulate(returns.begin(), returns.end(), 0.0) / returns.size();
    }

    QuantLib::Real variance = 0.0;
    for (const auto& dailyReturn : returns) {
        variance += std::pow(dailyReturn - meanReturn, 2);
    }
    variance /= (returns.size() - 1);

    QuantLib::Real volatility = std::sqrt(variance);
    QuantLib::Real zScore = QuantLib::InverseCumulativeNormal()(alpha);

    return portfolioValue * volatility * zScore;
}

void runAnalysis(const std::string& baseFilename, const std::string& csvFilename) {
    std::string fullFilename = baseFilename + csvFilename;

    try {
        QuantLib::Date targetDate(23, QuantLib::January, 2024);
        
        auto [portfolioValue, returns] = readData(fullFilename, targetDate);
        if (portfolioValue == 0.0) {
            std::cerr << "Error: Portfolio value not found for the target date." << std::endl;
        }

        QuantLib::Real maxDrawdownValue = drawdown(returns, portfolioValue);
        QuantLib::Real historicalVaR = historicalVar(returns, portfolioValue, 0.95);
        QuantLib::Real conditionalVaR = conditionalVar(returns, portfolioValue, 0.95);
        QuantLib::Real varianceCovarianceVaR = varianceCovarianceVar(returns, portfolioValue, 0.95);
        QuantLib::Real parametricVaR = parametricVar(returns, portfolioValue, 0.95);

        // Output results
        std::cout << "File: " << csvFilename << std::endl;
        std::cout << "Target Date: " << targetDate << std::endl;
        std::cout << "Portfolio Value: " << portfolioValue << std::endl;
        std::cout << "Max Drawdown: " << maxDrawdownValue << std::endl;
        std::cout << "Historical VaR at 95% confidence level: " << historicalVaR << std::endl;
        std::cout << "Conditional VaR at 95% confidence level: " << conditionalVaR << std::endl;
        std::cout << "Variance-Covariance VaR at 95% confidence level: " << varianceCovarianceVaR << std::endl;
        std::cout << "Parametric VaR at 95% confidence level: " << parametricVaR << std::endl;
        std::cout << "-----------------------------" << std::endl;

    } catch (std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    } catch (...) {
        std::cerr << "Unknown error" << std::endl;
    }
}

int main() {
    std::string baseFilename = "../data/";
    std::vector<std::string> csvFilenames = 
    {
        "006208_daily.csv", "006208_weekly.csv", "006208_monthly.csv", 
        "0050_daily.csv", "0050_weekly.csv", "0050_monthly.csv",
        "00878_daily.csv", "00878_weekly.csv", "00878_monthly.csv"
    };

    for (const auto& csvFilename : csvFilenames) {
        runAnalysis(baseFilename, csvFilename);
    }
    return 0;
}
