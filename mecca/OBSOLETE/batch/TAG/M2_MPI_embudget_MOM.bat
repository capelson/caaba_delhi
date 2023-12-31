# -*- Shell-script -*-

# Authors:
# Patrick Joeckel (2008, 2011),
# - this is similar to ts2000, but includes Hg-chemistry
# - create SCAV-L-mechanism with: (Sc && !I)
# Domenico Taraborrelli and Sergey Gromov (2014),
# - MOM mechanism, COS updates
# - extended chemistry budgeting

# The shell variables defined here will be used by xmecca 
# when it is run in batch mode (i.e. not interactive).

 set apn          = 0                 # number of aerosol phases [0...99, default=0]
 set gaseqnfile   = eqn/tag/mom.eqn
 set gasspcfile   = eqn/tag/mom.spc
 set gastexfile   = eqn/tag/mom.tex
 set rplfile      = mom-COS           #
#eval:
 set wanted       = "(((Tr && (G || Het) && \!I) || St) && \!Hg)"
 set enthalpy     = n                 # activate enthalpy in kJ/mol?
 set mcfct        = n                 # Monte-Carlo factor?
 set diagtracfile =                   # diagnostic tracers?
 set rxnrates     = n                 # calculate accumulated reaction rates?
 set tag          = y                 # perform (isotope) tagging?
 set tagcfg       = mF                # methane carbon and HCOOH from HCHO
 set embud        = o                 # ext. budgeting
 set kppoption    = k#4               # k=kpp, 4=kp4, q=quit
#set integr       = rosenbrock_posdef_h211b_qssa # integrator
#set integr       = rosenbrock_posdef # integrator
 set integr       = rosenbrock_mz     # integrator
#set integr       = rosenbrock_vec    # integrator
 set vlen         = 256               # only for kp4 and integr=rosenbrock_vec
 set decomp       = 1                 # remove indirect indexing
                                      # kp4: 0/1/2/3/q; kpp: y/n/q
 set deltmpkp4    = y                 # delete temporary kp4 files?
 set latex        = n                 # latex list of reactions?
 set graphviz     = n                 # graphviz plots?
 set deltmp       = y                 # delete temporary xmecca files?
