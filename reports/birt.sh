export BIRT_HOME=$1/birt
cd $1/tmp
cp $1/reports/$2.rptdesign .
sh $1/birt/ReportEngine/genReport.sh -f pdf $2.rptdesign

