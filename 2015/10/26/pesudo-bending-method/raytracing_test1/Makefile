CXX = g++
CFLAGS = -std=c++11
main: main.o m.o
	${CXX} -o main main.o m.o ${CFLAGS}

m.o: m.hh m.cpp
	${CXX} -o m.o m.cpp -c ${CFLAGS}

main.o: m.hh main.cpp
	${CXX} -o main.o main.cpp -c ${CFLAGS}

clean:
	rm main m.o main.o -rf
