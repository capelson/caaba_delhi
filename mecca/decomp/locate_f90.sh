#! /bin/sh

F90RAW="/soft/g95_64/v0.93/bin/g95"

# remove potential prefix (e.g. for profiling, tracing, etc.) and spaces
PREF90=""
if [ "$PREF90" != "" ] ; then
   F90RAW="`echo "$F90RAW" | sed 's|'"$PREF90"'||g' | sed 's|^ *||g'`"
else
   F90RAW="`echo "$F90RAW" | sed 's|^ *||g'`"
fi

case $F90RAW in
  mpif9*)
     F90="`mpif90 -show | grep '\-l' | awk '{print $1}'`"
     ;;
  */mpif9*)
     F90="`$F90RAW -show | grep '\-l' | awk '{print $1}'`"
     ;;
  sxmpif9*)
     F90="`echo $F90RAW | sed 's|mp||' | sed 's|sxi|sx|'`"
     ;;
  mpxlf9*)
     F90="`echo $F90RAW | sed 's|mp||'`"
     ;;
  *)
     F90=$F90RAW
     ;;
esac

#echo $PREF90
#echo $F90RAW
#echo $F90
