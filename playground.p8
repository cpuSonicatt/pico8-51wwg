pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

a={1,2,3,4,5,6,7,8,9}

x=rnd(a)
del(a,x)
foreach(a,print)