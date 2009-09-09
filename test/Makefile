CC        = gcc
CCFLAGS   = -g -O0 -std=c99
SOURCES   = $(wildcard *.m) $(wildcard ../*.m) \
			$(wildcard ../BSJSONAdditions/*.m) \
			$(wildcard ../KissXML/*.m)
OBJECTS   = $(SOURCES:%.m=%.o)
INCLUDES  = -I../ \
			-I../BSJSONAdditions \
			-I../KissXML \
			$(shell xml2-config --cflags)
LIBRARIES = $(shell xml2-config --libs) -framework Foundation

TARGET  = test

$(TARGET): $(OBJECTS)
	$(CC) $(CCFLAGS) $(OBJECTS) $(LIBRARIES) -o $@

.m.o:
	$(CC) $(CCFLAGS) $(INCLUDES) -c $< -o $@

clean:
	rm -f $(TARGET) $(OBJECTS) ./*.html ./*.xml ./*.json
