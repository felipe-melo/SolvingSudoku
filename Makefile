LAST := 1
DIFICULTY := 0.9
INSTANCE := 10
NUMBERS := $(shell seq 1 ${LAST})
JOBS := $(addprefix job,${NUMBERS})
.PHONY: all ${JOBS}
all: ${JOBS} ; echo "$@ success"
${JOBS}: job%: ; julia run_fill_ga.jl $(DIFICULTY) $(INSTANCE) 100 > Results/_ga_fill_$(DIFICULTY)_$(INSTANCE)_$*
