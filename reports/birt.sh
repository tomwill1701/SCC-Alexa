export BIRT_HOME=$HOMEDIR/birt
echo $BIRT_HOME
cd $HOMEDIR/tmp
cp $HOMEDIR/reports/$1.rptdesign .
ls
sh $HOMEDIR/birt/ReportEngine/genReport.sh -f pdf $1.rptdesign

