CC      = gcc
SOURCES = $(wildcard *.m) $(wildcard ../*.m)
OBJECTS = $(SOURCES:%.m=%.o)

TARGET  = test

$(TARGET): $(OBJECTS)
	$(CC) -g -O0 $(OBJECTS) -o $@ -framework Foundation

.m.o:
	$(CC) -g -O0 -I../ -c $< -o $@

clean:
	rm -f $(TARGET) $(OBJECTS) ./*.html
