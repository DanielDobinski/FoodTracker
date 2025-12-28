#include "healthcontroller.h"
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <cmath>

HealthController::HealthController(QObject *parent)
    : QObject(parent)
{
    // Inicjalizacja Twoich danych bazowych
    m_weight = 105.0;
    m_height = 189.0;
    m_age = 33;

    // Obliczamy zapotrzebowanie (BMR) przy starcie
    calculateBMR();

    // Próba wczytania zapisanych danych z dzisiaj
    loadData();
}

void HealthController::calculateBMR() {
    // Wzór Mifflin-St Jeor dla mężczyzn:
    // P = 10 * waga + 6.25 * wzrost - 5 * wiek + 5
    m_bmr = static_cast<int>(10 * m_weight + 6.25 * m_height - 5 * m_age + 5);

    // Dodajemy mały mnożnik aktywności (lekka aktywność sportowa)
    m_bmr *= 1.2;
}

double HealthController::bmi() const {
    // BMI = kg / m^2
    double heightInMeters = m_height / 100.0;
    return m_weight / (heightInMeters * heightInMeters);
}

int HealthController::dailyTarget() const {
    return m_bmr;
}

int HealthController::consumedCalories() const {
    return m_consumedCalories;
}

double HealthController::hydrationProgress() const {
    // Zakładamy cel 3.5 litra dla osoby o Twojej masie
    double target = 3.5;
    double progress = m_consumedWater / target;
    return (progress > 1.0) ? 1.0 : progress;
}

void HealthController::addMeal(int calories) {
    if (calories > 0) {
        m_consumedCalories += calories;
        emit statsChanged(); // Powiadamiamy QML o zmianie!
        saveData();
    }
}

void HealthController::addWater(double liters) {
    if (liters > 0) {
        m_consumedWater += liters;
        emit statsChanged();
        saveData();
    }
}

void HealthController::resetDay() {
    m_consumedCalories = 0;
    m_consumedWater = 0.0;
    emit statsChanged();
    saveData();
}

// --- Logika zapisu danych (Persistence) ---

void HealthController::saveData() {
    // Zapisujemy w folderze AppData użytkownika
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(path); // Upewnij się, że folder istnieje

    QFile file(path + "/daily_stats.txt");
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << m_consumedCalories << "\n";
        out << m_consumedWater << "\n";
        file.close();
        qDebug() << "Dane zapisane w: " << file.fileName();
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
        emit statsChanged();
    }
}
