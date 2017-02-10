qwert:
    num1=1 ; while [[ $$num1 -le 3 ]] ; do \
        num2=1 ; while [[ $$num2 -le 100 ]] ; do \
            echo julia run_sa.jl 1 $($$num1) 0.9 1000 500000 > Results/sa_$(1)_$(num1)_$(num3) ; \
            ((num2 = num2 + 1)) ; \
        done ; \
        ((num1 = num1 + 1)) ; \
    done
