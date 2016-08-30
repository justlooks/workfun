# 将过期时间为－1的key筛选出来,然后置一个过期时间
local keys=redis.call('keys','*');
local exs={};
for _,v in next,keys,nil do
  local ttl=redis.call('ttl',v);
  print(_,v);
  if ttl < 0 then
    exs[#exs + 1] = v;
    redis.call('expire',v,28800);
  end
end
return exs;

运行命令
redis-cli -a xZ7ScgiMV1Acv3h4 -n 20 --eval "redis-find-expirekey.lua" 0


# 找出对应ip 连接redis的哪个库
redis-cli -a xZ7ScgiMV1Acv3h4 client list| awk '{split($2,a,":");gsub("=","",$8);if(!match(re[substr(a[1],6)],$8)){re[substr(a[1],6)]=re[substr(a[1],6)]" "$8}}END{for(i in re)print i" "re[i]}'
