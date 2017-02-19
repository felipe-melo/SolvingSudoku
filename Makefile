LAST := 5
DIFICULTY := 3
INSTANCE := 1
NUMBERS := $(shell seq 1 ${LAST})
JOBS := $(addprefix job,${NUMBERS})
.PHONY: all ${JOBS}
all: ${JOBS} ; echo "$@ success"
${JOBS}: job%: ; julia run_fill_ga.jl $(DIFICULTY) $(INSTANCE) 100 > Results/ga_fill_$(DIFICULTY)_$(INSTANCE)_$*
