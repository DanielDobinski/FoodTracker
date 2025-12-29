# FoodTracker - Personalized Nutrition & Health Monitor

**FoodTracker** is a desktop application built for users who want to stay on top of their fitness goals. It allows for efficient logging of daily food intake, monitoring macronutrients, and tracking body metrics like weight and BMI. 

*This project is developed using **C++**, **Qt 6**, , combining the power of a robust framework with a modern, high-performance immediate-mode GUI.*

# Application Preview
![image](https://github.com/DanielDobinski/FoodTracker/tree/master/github/app.png)

### Video Presentation
[![FoodTracker Demo](https://img.youtube.com/vi/5NVcK8g8kuk/0.jpg)](https://www.youtube.com/watch?v=5NVcK8g8kuk)
*Click the image above to watch the app in action.*

## Key Features
- **Macronutrient Tracking:** Log calories, proteins, fats, and carbs with ease.
- **Body Progress:** Keep track of your weight (Current: XXX kg, Height: 190 cm) and physical measurements.
- **Performance Focused:** Fast UI interactions powered by QT
- **Custom Food Database:** Save your favorite meals to speed up the logging process.

## Install and Configure

### Prerequisites
- **Qt 6.x** (installed via Qt Online Installer)
- **CMake** 3.16 or newer
- **C++20** compatible compiler (MinGW or MSVC)

### Building from Source
```bash
# 1. Clone the repository
> git clone [https://github.com/DanielDobinski/FoodTracker.git](https://github.com/DanielDobinski/FoodTracker.git)
> cd FoodTracker

# 2. Configure the project
# Replace the path with your actual Qt installation path
> cmake . -B build/ -DCMAKE_PREFIX_PATH="C:/Qt/6.x.x/mingw_64" 

# 3. Build the application
> cmake --build build --config Release
