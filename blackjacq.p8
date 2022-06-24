pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

function _init()
    -- PICO8 helpers
    BLACK,GREEN,GREY,WHITE,RED,BLUE,PINK = 0,3,5,7,8,12,14

    state = 0

    suits = {"H", "D", "S", "C"}
    values = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K"}
    faces = {"J", "Q", "K"}
    reds = {"H", "D"}
    choices_map = {
        {"bet", "1"},
        {"stand", "hit", "double down"},
        {"stand", "hit", "double down", "split"}
    }
    d_pays = "blackjack pays 3 to 2"
    d_strat = "dealer must stand on 17"
    deck = create_deck()

    p = {
        posx = 51,
        posy = 90,
        hand = {},
        pointerx = 1,
        active_choice = choices_map[1],
        money = 100,
        bet = 1
    }
    d  = {
        posx = 51,
        posy = 15,
        hand = {}
    }

    
end

function create_deck()
    arr = {}
    for s = 1,4 do
        for v = 1,13 do
            add(arr, values[v]..suits[s])
        end
    end
    return shuffle(arr)
end


function deal(amt)
    --rnd(t) ?
    hand = {}
    for x = 1,amt do
        add(hand, deck[1])
        del(deck, deck[1])
    end
    return hand
end

function _update()

    if (btnp(1) and p.pointerx + 1 <= #p.active_choice) p.pointerx += 1
    if (btnp(0) and p.pointerx - 1 > 0) p.pointerx -= 1

    if (state == 0) then
        bet_update()
    elseif (state == 1) then
        play_update()
    end

end

function bet_update()
    bump = 0
    p.active_choice[2] = tostr(p.bet)

    if (btn(5)) then 
        bump = 10
    else
        bump = 1
    end

    if (btnp(2) and p.bet + bump <= 100) then
        p.bet += bump
    elseif (btnp(2) and p.bet + bump > 100) then
        p.bet = 100
    end

    if (btnp(3) and p.bet - bump > 1) then
        p.bet -= bump
    elseif (btnp(3) and p.bet - bump < 1) then
        p.bet = 1
    end

    if (p.pointerx == 1 and btnp(4)) then
        start_game()
    end
end

function play_update()

end

function start_game()
    state = 1
    p.active_choice = get_active_choice()
    p.hand = deal(2)
    d.hand = deal(2)
end

function _draw()
    cls(GREEN)

    print(d_pays, c(d_pays), 42, WHITE)
    print(d_strat, c(d_strat), 48, WHITE)

    for x=1,#p.hand do
        draw_card(p.hand[x], p.posx + ((x-1)*9), p.posy - ((x-1)*9), false)
        if (x != #p.hand) draw_shadow(p.posx + ((x)*9) - 1, p.posy - ((x)*9) + 1)
    end

    for x=1,#d.hand do
        local flip = false
        if (x == 1) flip = true 
        draw_card(d.hand[x], d.posx + ((x-1)*9), d.posy - ((x-1)*9), flip)
        if (x != #d.hand) draw_shadow(d.posx + ((x)*9) - 1, d.posy - ((x)*9) + 1)
    end

    draw_menu(p.active_choice, p.pointerx)
end

function draw_card(card, posx, posy, isBlank)

    if (#deck == 52) return

    if (isBlank) then
        --top
        spr(3, posx, posy)
        spr(4, posx + 8, posy, 1, 1)

        --mid
        spr(5, posx, posy + 8)
        spr(6, posx + 8, posy + 8)

        --bottom
        spr(4, posx, posy + 16, 1, 1, true, true)
        spr(3, posx + 8, posy + 16, 1, 1, true, true)

        return
    end

    v,s = sub(card,1,1), sub(card,2,2)
    isFace = includes(faces, v)
    isRed = includes(reds,s)
    suitIndex = 6


    -- detemine colour of card (face cards have inverted colours)
    cColour = WHITE
    wColour = GREY
    if isRed then wColour = RED end
    if isFace then
        cColour, wColour = wColour, cColour 
    end

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
    pal()

    --VALUE
    pal(BLUE, wColour)
    spr(index_of(values, v) + 15, posx, posy)
    spr(index_of(values, v) + 15, posx + 8, posy + 16, 1, 1, true, true)
    pal()

end

function draw_shadow(posx, posy)
    pal(WHITE,GREEN)
    spr(2, posx, posy + 8)
    spr(1, posx, posy + 16, 1, 1, false, true)
    pal()
end

function draw_menu(choices,pntr)
    cls(GREEN)
    rectfill(0, 119, 128, 128, WHITE)
    rectfill(0, 119, 10, 128, RED)
    print("p1", 2, 121, WHITE)
    if (choices == choices_map[1]) then
        print(p.money, 96, 121, GREEN)
        spr(11, 116, 120)
    end

    space = 0
    for x=1,#choices do
        if x == pntr then
            rectfill(8 + (4*x) + space, 120, 10 + (4*x) + space + (4*#choices[x]), 126, GREEN)
            print(choices[x], 10 + (4*x) + space, 121, WHITE)
        else 
            print(choices[x], 10 + (4*x) + space, 121, GREEN)
        end
        space += #choices[x] * 4
    end
end

function get_active_choice()
    if (sub(p.hand[1],1,1) == sub(p.hand[2],1,1)) return choices_map[2]
    return choices_map[1]
end

-- HELPER FUNCTIONS
function shuffle(t)
    for n=1,#t*2 do -- #t*2 times seems enough
        local a,b=flr(1+rnd(#t)),flr(1+rnd(#t))
        t[a],t[b]=t[b],t[a]
    end
    return t
end

function c(str)
    return 64-#str*2
end

function includes(arr,v)
    for x in all(arr) do
        if (x == v) return true
    end
    return false
end

function index_of(arr,v)
    count = 1
    for x in all(arr) do
        if (x == v) return count
        count += 1
    end
    return -1
end

__gfx__
00000000007777777777777700777777777777007778787878787877088008800008800000055000005555000000000000000000000000000000000000000000
000000000077777777777777007777777777770077878787878787778888888800888800005555000055550000087000000c7000000000000000000000000000
007007007777777777777777777778787878777777787878787878778888888808888880055555500055550000788800007ccc00000000000000000000000000
000770007777777777777777777787878787877777878787878787778888888808888880555555555555555500287200001c7100000000000000000000000000
00077000777777777777777777787878787878777778787878787877888888880888888055555555555555550072280000711c00000000000000000000000000
007007007777777777777777778787878787877777878787878787770888888008888880055005505550055500287200001c7100000000000000000000000000
00000000777777777777777777787878787878777778787878787877008888000088880000055000000550000002200000011000000000000000000000000000
00000000777777777777777777878787878787777787878787878777000880000008800005555550055555500000000000000000000000000000000000000000
00777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
777ccc77000ccc00000ccc00000c0c00000ccc00000c0000000ccc00000ccc00000ccc00000c0ccc000ccc00000ccc00000c0c00000000000000000000000000
777c7c7700000c0000000c00000c0c00000c0000000c000000000c00000c0c00000c0c00000c0c0c0000c000000c0c00000c0c00000000000000000000000000
777ccc77000ccc000000cc00000ccc00000ccc00000ccc0000000c00000ccc00000ccc00000c0c0c0000c000000c0c00000cc000000000000000000000000000
777c7c77000c000000000c0000000c0000000c00000c0c0000000c00000c0c0000000c00000c0c0c0000c000000cc000000c0c00000000000000000000000000
777c7c77000ccc00000ccc0000000c00000ccc00000ccc0000000c00000ccc0000000c00000c0ccc000cc00000000c00000c0c00000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
