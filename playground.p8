pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

#include helper.p8

function _init()

    suits=to_t("HDSC")vals=to_t("A23456789TJQK")faces=to_t("JQK")reds=to_t("HD")

    c1="AH"
    c2="TC"


    sm = {
        0,0,0,10,
        2,0,5,6,
        2,4,0,3,
        1,5,8,6
    }

    cx=64
    cy=64



end

function _update()
    if(btn(UP)) cy-=1
    if(btn(DOWN)) cy+=1
    if(btn(RIGHT)) cx+=1
    if(btn(LEFT)) cx-=1
end

function _draw()
    cls(3)
    
    draw_card(c1, 56, 52)
    draw_card(c2, cx, cy)

end

function draw_card(card, posx, posy)

    v,s = sub(card,1,1), sub(card,2,2)
    isFace = includes(faces, v)
    isRed = includes(reds,s)
    suitIndex = 6


    -- detemine colour of card (face cards have inverted colours)
    cColour = WHITE
    wColour = DGREY
    if isRed then wColour = RED end
    if isFace then
        cColour, wColour = wColour, cColour 
    end


    sp()
    draw_card_shadow(posx,posy)
    -- CARD
    pal(WHITE, cColour)
    --top
    spr(1, posx, posy)
    spr(1, posx + 8, posy, 1, 1, true, false)

    --mid
    spr(2, posx, posy + 8)
    spr(2, posx + 8, posy + 8)

    --bottom
    spr(1, posx, posy + 16, 1, 1, false, true)
    spr(1, posx + 8, posy + 16, 1, 1, true, true)

    if (v == "A") rect(posx + 2, posy + 4, posx + 13, posy + 20, wColour)

    --SUIT
    pal(cColour, WHITE)
    spr(suitIndex + index_of(suits, s), posx + 4, posy + 8)
    sp()

    --VALUE
    pal(BLUE, wColour)
    spr(index_of(vals, v) + 15, posx, posy)
    spr(index_of(vals, v) + 15, posx + 8, posy + 16, 1, 1, true, true)
    sp()

end

function draw_card_shadow(x,y)
    pset(x+1,y+1,sm[pget(x+1,y+1)+1])
    pset(x+14,y+22,sm[pget(x+15,y+23)+1])
    for i=0,19 do
        pset(x-1,y+3+i,sm[pget(x-1,y+3+i)+1]) 
    end
    pset(x,y+22,sm[pget(x,y+22)+1])
    for i=0,2 do
        pset(x+1,y+22+i,sm[pget(x+1,y+22+i)+1])
    end
    for i=0,10 do
        pset(x+2+i,y+24,sm[pget(x+2+i,y+24)+1])
    end
    --
    if (pget(x+1,y) != 3) pset(x+1,y,sm[pget(x+1,y)+1])
    if (pget(x,y+1) != 3) pset(x,y+1,sm[pget(x,y+1)+1])
    if (pget(x-1,y+1) != 3) pset(x-1,y+1,sm[pget(x-1,y+1)+1])
    if (pget(x-1,y+2) != 3) pset(x-1,y+2,sm[pget(x-1,y+2)+1])
    for i=0,13 do
        if (pget(x+1+i,y-1) != 3) pset(x+1+i,y-1,sm[pget(x+1+i,y-1)+1])
    end

end

function sp()
    pal()
    pal(10,131,1)
end

function draw_card_frame(posx,posy)
    spr(1, posx, posy)
    spr(1, posx + 8, posy, 1, 1, true, false)

    --mid
    spr(2, posx, posy + 8)
    spr(2, posx + 8, posy + 8)

    --bottom
    spr(1, posx, posy + 16, 1, 1, false, true)
    spr(1, posx + 8, posy + 16, 1, 1, true, true)
end


__gfx__
00000000007777777777777700777777777777007778787878787877088008800008800000055000005555000000000000000000000000000000000000000000
00000000007777777777777700777777777777007787878787878777888888880088880000555500005555000000000000000000000000000000000000000000
00700700777777777777777777777878787877777778787878787877888888880888888005555550005555000000000000000000000000000000000000000000
00077000777777777777777777778787878787777787878787878777888888880888888055555555555555550000000000000000000000000000000000000000
00077000777777777777777777787878787878777778787878787877888888880888888055555555555555550000000000000000000000000000000000000000
00700700777777777777777777878787878787777787878787878777088888800888888005500550555005550000000000000000000000000000000000000000
00000000777777777777777777787878787878777778787878787877008888000088880000055000000550000000000000000000000000000000000000000000
00000000777777777777777777878787878787777787878787878777000880000008800005555550055555500000000000000000000000000000000000000000
00777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
777ccc77000ccc00000ccc00000c0c00000ccc00000c0000000ccc00000ccc00000ccc00000c0ccc000ccc00000ccc00000c0c00000000000000000000000000
777c7c7700000c0000000c00000c0c00000c0000000c000000000c00000c0c00000c0c00000c0c0c0000c000000c0c00000c0c00000000000000000000000000
777ccc77000ccc000000cc00000ccc00000ccc00000ccc0000000c00000ccc00000ccc00000c0c0c0000c000000c0c00000cc000000000000000000000000000
777c7c77000c000000000c0000000c0000000c00000c0c0000000c00000c0c0000000c00000c0c0c0000c000000cc000000c0c00000000000000000000000000
777c7c77000ccc00000ccc0000000c00000ccc00000ccc0000000c00000ccc0000000c00000c0ccc000cc00000000c00000c0c00000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
