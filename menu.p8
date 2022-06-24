pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

function menu()
    game.update = menu_update
    game.draw = menu_draw
    gl={" \f7blackjack"," \f7chess"," \f7yacht dice"," \f7koi-koi"," \f7mancala"}tmr=0 max=120 sel=1 gsel=false ipos={46,70}

end

function menu_update()

    if(btnp(2)and sel-1>0)sel-=1
    if(btnp(3)and sel+1<=5)sel+=1
end

function menu_draw()
    cls()
    drawstars()
    draw_icons()
    spr(45,36,70+10*(sel-1))
    if(btnp(4)or btnp(5))blackjack()
end

function draw_icons() -- box around?
    space=0
    for x=1,5 do
        spr(39+x,ipos[1],ipos[2]+space)
        print(gl[x],52,72+space)
        space += 10
    end
end
