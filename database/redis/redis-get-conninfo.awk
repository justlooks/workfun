#!/bin/awk

# 获取客户端连接信息
# redis-cli -a pass client list| awk -f get_conninfo.awk

{
split($2,a,":");
gsub("=","",$8);
if(!match(re[substr(a[1],6)],$8))
        {re[substr(a[1],6)]=re[substr(a[1],6)]" "$8}
}
END{
for(i in re)
if(!match(i,"127.0.0.1"))
{
        cmd="nslookup "i
        while((cmd | getline result) > 0)
        {
                if(match(result,"name"))
                        {split(result,h," ");gsub(/\./,"",h[4])}
        }
        close(cmd)
        {print i"("h[4]") "re[i]}
}
}
