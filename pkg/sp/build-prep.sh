# run before R CMD build sp
VERSION=`awk '/Version:/{print $2}' DESCRIPTION`
sed -e 's/@VERSION@/'$VERSION'/' src/sp.h.in > src/sp.h
cp src/sp.h inst/include
cp src/sp_xports.c inst/include
grep SP_VERSION inst/include/sp.h
svn up
svn2cl
cp ChangeLog inst
svn commit -m tidy inst/ChangeLog
svn up
