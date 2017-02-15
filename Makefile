LAST := 25
DIFICULTY := 3
INSTANCE := 1
NUMBERS := $(shell seq 1 ${LAST})
JOBS := $(addprefix job,${NUMBERS})
.PHONY: all ${JOBS}
all: ${JOBS} ; echo "$@ success"
${JOBS}: job%: ; julia run_sa.jl $(DIFICULTY) $(INSTANCE) 0.9 70 16000000 > Results/sa_$(DIFICULTY)_$(INSTANCE)_$*
