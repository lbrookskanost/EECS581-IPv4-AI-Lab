CXX      = g++
CXXFLAGS = -Wall -Wextra -std=c++17
TARGET   = ipv4
SRC      = ipv4.cpp

.PHONY: all clean test

all: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRC)

test: $(TARGET)
	@bash test.sh

clean:
	rm -f $(TARGET)