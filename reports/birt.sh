export BIRT_HOME=$1/birt-runtime-4_5_0
cd $1/tmp
cp $1/reports/$2.rptdesign .
sh $1/birt/ReportEngine/genReport.sh -f pdf $3.rptdesign

