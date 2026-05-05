CC      = gcc
CFLAGS  = -Wall -O2
LDFLAGS = -lcrypto
TARGET  = readmylogin
SRC     = readmylogin.c

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)
	@echo "Done: ./$(TARGET)"

clean:
	rm -f $(TARGET)