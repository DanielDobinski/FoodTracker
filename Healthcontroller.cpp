#include "healthcontroller.h"
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <cmath>

HealthController::HealthController(QObject *parent) : QObject(parent)
{
    m_weight = 105.0;
    m_height = 189.0;
    m_age = 33;
    calculateBMR();

    // --- Hardcoded History Injection ---
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(path);
    QString filePath = path + "/daily_stats.txt";
    QFile file(filePath);

    // We open in WriteOnly to ensure the file is exactly these 31 days every startup
    // Change to Append or check if exists if you want to keep data between sessions later
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << "2025-11-29,2950,3.2\n2025-11-30,3100,3.5\n2025-12-01,2800,3.0\n"
            << "2025-12-02,3450,4.0\n2025-12-03,2700,3.1\n2025-12-04,3200,3.5\n"
            << "2025-12-05,3050,3.3\n2025-12-06,2900,3.5\n2025-12-07,3600,4.2\n"
            << "2025-12-08,3100,3.5\n2025-12-09,2750,2.8\n2025-12-10,3300,3.7\n"
            << "2025-12-11,3150,3.5\n2025-12-12,2850,3.0\n2025-12-13,3000,3.4\n"
            << "2025-12-14,3550,3.9\n2025-12-15,3200,3.5\n2025-12-16,2950,3.2\n"
            << "2025-12-17,3100,3.6\n2025-12-18,2800,3.1\n2025-12-19,3400,3.8\n"
            << "2025-12-20,3250,3.5\n2025-12-21,2900,3.3\n2025-12-22,3050,3.5\n"
            << "2025-12-23,3700,4.5\n2025-12-24,3300,3.5\n2025-12-25,3500,3.0\n"
            << "2025-12-26,2800,3.5\n2025-12-27,3150,3.4\n2025-12-28,3000,3.5\n"
            << "2025-12-29,100,0\n";
        file.close();
    }

    // Now load it normally so m_history and dashboard values are populated
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

#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDir>

bool HealthController::saveData() {
    // 1. Get the path and force the folder name
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

    // Ensure the directory exists
    QDir dir;
    if (!dir.exists(path)) {
        dir.mkpath(path);
    }

    QString filePath = path + "/daily_stats.txt";
    QFile file(filePath);

    // 2. Open with WriteOnly (truncates existing file)
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qCritical() << "CRITICAL: Could not open file for writing at:" << filePath;
        qCritical() << "Error message:" << file.errorString();
        return false;
    }

    // 3. Write data
    QTextStream out(&file);
    out << m_consumedCalories << "\n";
    out << m_consumedWater << "\n";

    // 4. FORCE the data to the physical disk
    out.flush();
    file.flush();
    file.close();
    //C:\Users\dobin\AppData\Roaming\HealthTracker\HealthTracker
    qDebug() << "SUCCESS: Data saved to:" << filePath;
    return true;
}

void HealthController::loadData() {
    // 1. Point to your specific file
    // If the file is in the project folder, use a relative path.
    // If it's in the AppData folder, use QStandardPaths.
    QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/daily_stats.txt";
    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Could not open file at:" << filePath;
        return;
    }

    m_history.clear();
    QTextStream in(&file);

    while (!in.atEnd()) {
        QString line = in.readLine().trimmed();
        if (!line.isEmpty()) {
            m_history.append(line);
        }
    }
    file.close();

    // 2. Automatically update today's dashboard if today's date is in the file
    QString today = QDate::currentDate().toString(Qt::ISODate);
    for (const QString &record : m_history) {
        if (record.startsWith(today)) {
            QStringList parts = record.split(",");
            if (parts.size() >= 2) m_consumedCalories = parts[1].toInt();
            if (parts.size() >= 3) m_consumedWater = parts[2].toDouble();
        }
    }

    // 3. CRITICAL: Trigger the UI refresh
    emit historyChanged();
    emit statsChanged();
    qDebug() << "Successfully loaded" << m_history.size() << "days of history.";
}
