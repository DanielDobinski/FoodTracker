#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include "healthcontroller.h"

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle("Basic");
    QGuiApplication app(argc, argv);

    // 1. Create the backend logic object
    HealthController healthController;

    QQmlApplicationEngine engine;

    // 2. Push the C++ object into QML context
    // Now "healthCtrl" is a global variable inside your QML files
    engine.rootContext()->setContextProperty("healthCtrl", &healthController);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);

    engine.loadFromModule("FoodTracker", "Main");

    return app.exec();
}
