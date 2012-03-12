#!/bin/bash
cd "`/usr/bin/dirname "$0"`"
echo "==== loadsql start =====" >> /tmp/loadsql.out
thereWhereProblems=0
for file in sql/*.sql;do
    echo "SQL executing $file" |tee --append /tmp/loadsql.out
    /usr/bin/psql --file="$file" >> /tmp/loadsql.out 2>&1 || let thereWhereProblems=thereWhereProblems+1
done
if [[ $thereWhereProblems -eq 0 ]]; then
    /bin/mv /tmp/loadsql.out /tmp/loadsql.done
else
    echo "There where $thereWhereProblems SQL problems, see /tmp/loadsql.out"
    exit 1
fi
