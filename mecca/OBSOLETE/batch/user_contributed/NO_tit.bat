# -*- Shell-script -*-

# The shell variables defined here will be used by xmecca 
# when it is run in batch mode (i.e. not interactive).

set apn          = 0                 # number of aerosol phases [0...99, default=0]
set gaseqnfile   = gas.eqn
set rplfile      = 				     # no replacements
set wanted       = "Tr && G && \!Cl && \!Br && \!I && \!Hg"
set setfixlist   = "O2; N2; H2; H2O; H2O2; O3;"
set mcfct        = n                 # Monte-Carlo factor?
set diagtracfile =                   # diagnostic tracers?
set rxnrates     = y                 # calculate accumulated reaction rates?
set tagdbl       = n                 # tagging, doubling, both, none ??
set kppoption    = k                 # k=kpp, 4=kp4, q=quit
set integr       = rosenbrock_posdef # integrator
set decomp       = n                 # remove indirect indexing
set latex        = n                 # latex list of reactions
set graphviz     = n                 # graphviz plots?
set deltmp       = y                 # delete temporary xmecca files?
set latex        = y                 # latex list of reactions?
set ignoremassbalance                # MCM violates the mass balance
