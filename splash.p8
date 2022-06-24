pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

-- MAX LENGTH: 31
-- compress after
mws = {
    "<3",
    "love",
    ":heart:",
    " \f8\135",
    "love'); drop table students;--",
    "bad lua",
    "6c 5f 76 65",
    "0 errors, "..3+flr(rnd(9))+1 .." warnings",
    "sv_cheats 1",
    "motherlode",
    "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
    "lots of swearing",
    "bad ideas",
    ".-.. --- ...- .",
    "            \fct\fer\f7a\fen\fcs \f7rights!",
    "                \f8r\f9a\fai\fbn\fcb\fdo\few\f7s!",
    "-- todo: add more taglines","redstone",
    "______","?\"love\",56,68,7"
}

mode="open"

function splash()
    game.update=splash_update
    game.draw=splash_draw
    mwt="made with"mw=rnd(mws)jt="by jacq"tmr=t()+4
end

function splash_update()
    if (tmr==t()) then
        menu()
    end
end

function splash_draw()
    palt(14)
    cls(3)
    if (t()+3.5 > tmr) spr(12,60,50) -- shyguy
    if (t()+3 > tmr) ?mwt,c(mwt),60,7 -- "made with"
    if (t()+2.5 > tmr) ?mw,c(mw),68,7 -- random
    if (t()+3 > tmr) ?jt,c(jt),76,7 -- "by jacq"
end