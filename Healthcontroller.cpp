#include "healthcontroller.h"
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <cmath>

HealthController::HealthController(QObject *parent) : QObject(parent)
{
    // Initialize base user data (105kg, 189cm, 33 years old)
    m_weight = 105.0;
    m_height = 189.0;
    m_age = 33;

    // Calculate Basal Metabolic Rate (BMR) at startup
    calculateBMR();

    // Attempt to load previously saved data for today
    loadData();
}

void HealthController::calculateBMR() {
    // Mifflin-St Jeor Equation for men:
    // P = 10 * weight + 6.25 * height - 5 * age + 5
    m_bmr = static_cast<int>(10 * m_weight + 6.25 * m_height - 5 * m_age + 5);

    // Apply a light activity multiplier (typical for fitness enthusiasts)
    m_bmr *= 1.2;
}

double HealthController::bmi() const {
    // BMI Formula: kg / m^2
    double heightInMeters = m_height / 100.0;
    if (heightInMeters <= 0) return 0;
    return m_weight / (heightInMeters * heightInMeters);
}

int HealthController::dailyTarget() const {
    return m_bmr;
}

int HealthController::consumedCalories() const {
    return m_consumedCalories;
}

double HealthController::hydrationProgress() const {
    // Target set to 3.5 liters based on your body mass
    double target = 3.5;
    double progress = m_consumedWater / target;

    // Clamp progress to 1.0 (100%) so the UI bar doesn't overflow
    return (progress > 1.0) ? 1.0 : progress;
}

void HealthController::addMeal(int calories) {
    if (calories > 0) {
        m_consumedCalories += calories;
        emit statsChanged(); // Notify QML UI to refresh data!
        saveData();
    }
}

void HealthController::addWater(double liters) {
    if (liters > 0) {
        m_consumedWater += liters;
        emit statsChanged(); // Notify QML UI to refresh data!
        saveData();
    }
}

void HealthController::resetDay() {
    m_consumedCalories = 0;
    m_consumedWater = 0.0;
    emit statsChanged();
    saveData();
}

// --- Data Persistence Logic ---

void HealthController::saveData() {
    // Save to the user's system AppData folder
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(path); // Ensure the directory exists

    QFile file(path + "/daily_stats.txt");
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << m_consumedCalories << "\n";
        out << m_consumedWater << "\n";
        file.close();
        qDebug() << "Data saved successfully to:" << file.fileName();
    }
}

void HealthController::loadData() {
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QFile file(path + "/daily_stats.txt");

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        m_consumedCalories = in.readLine().toInt();
        m_consumedWater = in.readLine().toDouble();
        file.close();

        // Notify the UI that loaded data is ready for display
        emit statsChanged();
    }
}
