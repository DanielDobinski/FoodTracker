#ifndef HEALTHCONTROLLER_H
#define HEALTHCONTROLLER_H

#include <QObject>
#include <QDateTime>
#include <QVector>

struct Activity {
    QString name;
    int calories;
    QDateTime timestamp;
};

class HealthController : public QObject {
    Q_OBJECT
    // These properties allow QML to "read" values and update automatically
    Q_PROPERTY(double bmi READ bmi NOTIFY statsChanged)
    Q_PROPERTY(int dailyTarget READ dailyTarget NOTIFY statsChanged)
    Q_PROPERTY(int consumedCalories READ consumedCalories NOTIFY statsChanged)
    Q_PROPERTY(double hydrationProgress READ hydrationProgress NOTIFY statsChanged)
    Q_PROPERTY(QStringList history READ history NOTIFY historyChanged)

public:
    explicit HealthController(QObject *parent = nullptr);

    // Q_INVOKABLE means we can call these functions from a QML Button
    Q_INVOKABLE void addMeal(int calories);
    Q_INVOKABLE void addWater(double liters);
    Q_INVOKABLE void resetDay();

    double bmi() const;
    int dailyTarget() const;
    int consumedCalories() const;
    double hydrationProgress() const;
    QStringList history() const { return m_history; }

signals:
    void statsChanged(); // Fired whenever data changes to refresh UI
    void historyChanged();

private:
    void calculateBMR();
    bool saveData();
    void loadData();

    double m_weight = 105.0; // Your weight
    double m_height = 189.0; // Your height
    int m_age = 33;
    int m_consumedCalories = 0;
    double m_consumedWater = 0.0;
    int m_bmr = 0;
    QStringList m_history;
};

#endif
