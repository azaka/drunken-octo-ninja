#include <QtCore/QCoreApplication>
#include <libavformat/avformat.h>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    AVFormatContext* context = avformat_alloc_context();
    
    return a.exec();
}
