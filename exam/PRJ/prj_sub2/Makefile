CC = gcc
EXEC = d e
OBJ  = $(foreach exe, ${EXEC}, ${exe}.o)

all: ${OBJ} ${EXEC}

${EXEC}:%:%.o
	${CC} -o $@ $<

${OBJ}:%.o:%.c
	${CC} -c -o $@ $<

install:
	cp ${EXEC} ${BIN}

clean:
	rm ${EXEC} ${OBJ}