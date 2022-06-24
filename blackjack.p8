pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

function blackjack()
    state=1
    game.update = bj_update
    game.draw = bj_draw

    updates={bet_update,game_update,dealer_update,post_update}
    draws={bet_draw,game_draw,dealer_draw,post_draw}
    
    sm={0,0,0,10,2,0,5,6,2,4,0,3,1,5,8,6}

    sel=1
    round=1
    round_str="round: "..round
    
    suits=to_t("HDSC")vals=to_t("A23456789TJQK")faces=to_t("JQK")reds=to_t("HD")d_pays="blackjack pays 3 to 2"d_strat="dealer must stand on 17"deck=create_deck()
    mode="choose mode:"vs="vs. dealer     vs. player"
    flp=true

    bet_holder=0
    cbets={"bet", "1"}
    cplay={"hit", "stand"}
    p = {
        posx = 56,
        posy = 88,
        hand = {},
        money = 100,
        bet = 1,
        score = 0
    }
    d  = {
        posy = 12,
        hand = {},
        score = 0,
        display = "??"
    }

end

function bj_update()
    updates[state]()
end

function bj_draw()
    draws[state]()
end


function create_deck()
    arr = {}
    for s = 1,4 do
        for v = 1,13 do
            add(arr, vals[v]..suits[s])
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

function bet_update()
    if(btnp(LEFT)and sel-1>0)sel-=1
    if(btnp(RIGHT)and sel+1<=#cplay)sel+=1

    cbets[2] = tostr(p.bet)

    bump = 0
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

    if (sel == 1 and btnp(OH)) then
        start()
    end

end

function start()
    p.money -= p.bet
    p.hand = deal(2)
    p.score = 0
    d.hand = deal(2)
    d.score = 0
    d.display = "??"
    state=2
    flp=true
    getscores()
end

function bet_draw()
    cls(DGREEN)
    table_details()
    draw_bet_menu()
end

function draw_bet_menu()
    rectfill(0, 119, 128, 128, WHITE)
    rectfill(0, 119, 10, 128, RED)
    prints("p1", 2, 121, WHITE,DRED)
    print("money: "..p.money, 84, 121, DGREEN)

    space=0
    for x=1,#cbets do
        local sel_str="\#3\f7"
        if(x!=sel)sel_str="\#7\f3"
        print(sel_str..cbets[x], 10 + (4*x) + space, 121)
        space += #cbets[x] * 4
    end

end

function game_update()
    set_choices()
    
    if(btnp(LEFT)and sel-1>0)sel-=1
    if(btnp(RIGHT)and sel+1<=#cplay)sel+=1
    if(btnp(OH))handle_game_choice()
end

function handle_game_choice()
    choice = cplay[sel]
    if (choice == "hit") add(p.hand, deal(1)[1])
    if (choice == "stand") state=3
    getscores()
    check(p)
end

function game_draw()
    cls(DGREEN)

    sp()
    prints(round_str,4,4,WHITE,YELLOW)
    prints("dealer: "..d.display, 84, 98, WHITE, YELLOW)
    prints("player: "..p.score, 84, 106, WHITE, YELLOW)
    spr(11,100,89)
    prints(": "..p.bet,108,90,WHITE,YELLOW)

    table_details()

    draw_cards()

    draw_game_menu()
end

function draw_cards()
    for x=1,#p.hand do
        draw_card(p.hand[x], p.posx + ((x-1)*8) - ((#p.hand-1) * 4), p.posy - ((x-1)*8), false)
    end

    for x=1,#d.hand do
        if x==1 or state>=3 then flp=false
        else flp=true end
        draw_card(d.hand[x], 56 + ((x-1)*8) - ((#d.hand-1) * 4), d.posy, flp)
    end
end

function draw_game_menu()
    rectfill(0, 119, 128, 128, WHITE)
    rectfill(0, 119, 10, 128, RED)
    prints("p1", 2, 121, WHITE,DRED)

    space=0
    for x=1,#cplay do
        local sel_str="\#3\f7"
        if(x!=sel)sel_str="\#7\f3"
        print(sel_str..cplay[x], 10 + (4*x) + space, 121)
        space += #cplay[x] * 4
    end

end

function set_choices()
    cplay={"hit", "stand"}
    if #p.hand <= 2 then
        add(cplay, "double down")
        if (sub(p.hand[1],1,1) == sub(p.hand[2],1,1)) add(cplay, "split")
    end
end

function getscores()
    pvs={}
    for card in all(p.hand)do
        add(pvs, sub(card,1,1))
    end
    p.score = determine(pvs, p.score)

    dvs={}
    for card in all(d.hand)do
        add(dvs, sub(card,1,1))
    end
    if state>=3 then
        d.score = determine(dvs, d.score)
        d.display = ""..d.score
    end
    
end

function check(x)
    getscores()
    if(x.score>21 or#x.hand==5)state=4
end


function determine(vs,x)
    local score = 0

    for v in all(vs) do
        if includes(faces,v) or v == "T" then
            score += 10
        elseif v=="A" then
            score += 11
            if(score>21)score-=10
        else
            score += v
        end
    end
    return score
end

function dealer_update()
    check(d)
    if state == 3 then
        getscores()
        if (d.score < 17) then add(d.hand, deal(1)[1])
        else state=4 end
        
    end
end

function dealer_draw()
    cls(DGREEN)
    table_details()
    sp()
    prints(round_str,4,4,WHITE,YELLOW)
    prints("dealer: "..d.score, 84, 98, WHITE, YELLOW)
    prints("player: "..p.score, 84, 106, WHITE, YELLOW)
    spr(11,100,89)
    prints("      : "..p.bet,84,90,WHITE,YELLOW)

    draw_cards()
    draw_dealer_menu()
end

function draw_dealer_menu()
    rectfill(0, 119, 128, 128, WHITE)
    rectfill(0, 119, 10, 128, RED)
    prints("p1", 2, 121, WHITE,DRED)
end

function post_update()
    getscores()
    if (btnp(OH)) then
        if (round==7) then end --game over
        round += 1
        state=1
    end
end

function post_draw()
    cls(DGREEN)
    table_details()
    sp()
    prints(round_str,4,4,WHITE,YELLOW)
    prints("dealer: "..d.score, 84, 98, WHITE, YELLOW)
    prints("player: "..p.score, 84, 106, WHITE, YELLOW)
    spr(11,100,89)
    prints("      : "..p.bet,84,90,WHITE,YELLOW)

    draw_cards()
    draw_post_menu()

end

function draw_post_menu()
    rectfill(0, 119, 128, 128, WHITE)
    rectfill(0, 119, 10, 128, RED)
    prints("p1", 2, 121, WHITE,DRED)
    print(get_post_game().."next round",14,121,DGREEN)
end

function get_post_game()
    v1,v2=sub(p.hand[1],1,1),sub(p.hand[2],1,1)
    if(is_bj(v1,v2))then
        p.money+=p.bet*1.5
        return"blackjack!"
    end
    if(p.score>21)then
        return"bust!"
    end
    if(d.score>21)then
        p.money+=p.bet
        return"win!"
    end
    if(#p.hand==5)then
        p.money+=p.bet
        return"win!"
    end
    if(p.score==d.score)then
        return"push!"
    end
    if(p.score>d.score)then
        p.money+=p.bet
        return"win!"
    end
    if(d.score>p.score)then
        return"lose!"
    end
    if(d.score<22)then
        return"lose!"
    end

end

function is_bj(v1,v2)
    return (v1 == "A" or v2 == "A") and (includes(faces,v1) or includes(faces,v2))
end

function draw_card(card, posx, posy, isBlank)

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

        sp()
        draw_card_shadow(posx,posy)

        return
    end

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

function sp()
    pal()
    pal(10,131,1)
end

function draw_card_shadow(x, y)
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
    if (pget(x+1,y) != 3) pset(x+1,y,sm[pget(x+1,y)+1])
    if (pget(x,y+1) != 3) pset(x,y+1,sm[pget(x,y+1)+1])
    if (pget(x-1,y+1) != 3) pset(x-1,y+1,sm[pget(x-1,y+1)+1])
    if (pget(x-1,y+2) != 3) pset(x-1,y+2,sm[pget(x-1,y+2)+1])
    for i=0,13 do
        if (pget(x+1+i,y-1) != 3) pset(x+1+i,y-1,sm[pget(x+1+i,y-1)+1])
    end

end

function table_details()
    sp()
    prints(d_pays, c(d_pays), 40, WHITE, YELLOW)
    prints(d_strat, c(d_strat), 48, WHITE, YELLOW)
end
