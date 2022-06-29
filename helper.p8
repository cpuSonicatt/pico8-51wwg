pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

-- HELPER VARS
BLACK,DBLUE,DRED,DGREEN,BROWN,DGREY,GREY,WHITE,RED,ORANGE,YELLOW,GREEN,BLUE,PURPLE,PINK,PEACH=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
LEFT,RIGHT,UP,DOWN,OH,EX=0,1,2,3,4,5

-- HELPER FUNCTIONS

-- center a string vertically
function c(str)
    return 64-#str*2
end

-- check if value is in array
function includes(a,v)
    for x in all(a)do
        if (x==v)return true
    end
    return false
end

-- get index (from 1) of value in array
function index_of(a,v)
    local c=1
    for x in all(a)do
        if(x==v)return c
        c+=1
    end
    return-1
end

-- linear interpolation
function lerp(a,b,t)
    return a*(1-t) + b*t
end

function eoq(t)
    t-=1
    return 1-t*t
end


function drawstars()
local c,b=0
  for i in all(stars) do
    b=flr(i.c)
    if (i.c-b<.5) pset(i.x,i.y,i.c)
    i.c+=.0625
    if (flr(i.c)>b) i.c-=1
    i.y=i.y%128+.5
    c+=1
  end
  if (c==0) stars={}
  if c<64 then
    b={}
    b.x=rnd(128)
    b.y=rnd(128)
    b.c=1+rnd(14)
    add(stars,b)
  end
end

function to_t(str)
    local ret={}
    for x=1,#str do
        add(ret,sub(str,x,x))
    end
    return ret
end

function prints(str,x,y,c,sc)
    ?str,x,y+1,sc
    ?str,x,y,c
end