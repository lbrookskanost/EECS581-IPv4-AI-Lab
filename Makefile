CXX      = g++
CXXFLAGS = -Wall -Wextra -std=c++17
TARGET   = ipv4
SRC      = ipv4.cpp

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)
