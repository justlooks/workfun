#!/bin/awk -f

# 统计redis-rdb-tools 的每个DB的所有key占用空间
# 要求有memory.csv文件 , 运行方法 : func memory.csv

BEGIN{
FS=","
}
NR!=1{
a[$1]+=$4;
}
END{
for(i in a){
print "DB "i" (BYTES): "a[i]
}
}
