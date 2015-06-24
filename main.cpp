#include <QtCore/QCoreApplication>
#include <libavutil/avutil.h>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    qDebug() << avutil_license();
    
    return a.exec();
}
