CC      = gcc
CCFLAGS = -g -O0 -std=c99
SOURCES = $(wildcard *.m) $(wildcard ../*.m)
OBJECTS = $(SOURCES:%.m=%.o)

TARGET  = test

$(TARGET): $(OBJECTS)
	$(CC) $(CCFLAGS) $(OBJECTS) -o $@ -framework Foundation

.m.o:
	$(CC) $(CCFLAGS) -I../ -c $< -o $@

clean:
	rm -f $(TARGET) $(OBJECTS) ./*.html ./*.xml
