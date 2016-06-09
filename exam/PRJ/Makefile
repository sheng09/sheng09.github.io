export BIN=../bin

SUBS = prj_sub1 prj_sub2 prj_sub3
SUBS_make    = $(foreach sub, ${SUBS}, ${sub}.make)
SUBS_clean   = $(foreach sub, ${SUBS}, ${sub}.clean)
SUBS_install = $(foreach sub, ${SUBS}, ${sub}.install)

all: ${SUBS_make}

${SUBS_make}:%.make:%
	make -C $<

install: ${SUBS_install}

${SUBS_install}:%.install:%
	-make -C $< install

clean: ${SUBS_clean}

${SUBS_clean}:%.clean:%
	-make -C $< clean
