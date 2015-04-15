export BIRT_HOME=$HOMEDIR/birt
cd $HOMEDIR/tmp
cp $HOMEDIR/reports/$1.rptdesign .
sh $HOMEDIR/birt/ReportEngine/genReport.sh -f pdf $1.rptdesign

