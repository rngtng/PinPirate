#define DEBUG

#include <ByteBuffer.h>

#ifdef DEBUG
#define BAUD_RATE 115200
#define LOG_OUT 100 //TODO this need to be better
#define lprint(data) logBuffer.put(data)
#define lputs(data) logBuffer.put(data); logBuffer.put(111)
#define lping() logBuffer.put(254)
#define linit() Serial.begin(BAUD_RATE); logBuffer.init(256)
#define lsend() while( logBuffer.getSize() > 0 ) Serial.print(logBuffer.get(), BYTE)
extern ByteBuffer logBuffer;

#else
#define lprint(data)
#define lputs(data)
#define linit()
#define lsend()
#endif
