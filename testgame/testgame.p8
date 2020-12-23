pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--testgame
--by qutico-8: jake and rob

function _init()
	init_entities()
	init_camera()
	music(0)
end

function init_camera()
	cam_xy={player.x,player.y}
	cam_tau=0.1
end

function init_entities()
	player=make_player(63,63)
	entities={player}
end
-->8
--updates

function _update60()
	update_camera()
	for e in all(entities) do
		e:update()
	end
end

function update_camera()
	local x,y=player.x,player.y
	cam_xy={
		x*cam_tau+cam_xy[1]*(1-cam_tau),
		y*cam_tau+cam_xy[2]*(1-cam_tau),
	}
end

function handle_input(s)
	if     btn(⬅️) then
		s.x-=s.speed
		s.fx=true
	end if btn(➡️) then
	 s.x+=s.speed
	 s.fx=false
	end if btn(⬆️) then
	 s.y-=s.speed
	end if btn(⬇️) then
	 s.y+=s.speed
	end
	
	if (btnp(🅾️)) sfx(0)
	if (btnp(❎)) sfx(1)	
end

function update_player(s)
	handle_input(s)
end
-->8
--draws

function _draw()
	cls()
	camera(cam_xy[1]-63,cam_xy[2]-63)
	map()
	for e in all(entities) do
		e:draw()
	end
	camera()
	rect(0,0,127,127,7)
	rect(1,1,126,126,6)
	rect(2,2,125,125,5)
end

function draw_player(s)
	spr(s.sprite,s.x,s.y,s.w,s.h,s.fx)
end
-->8
--entities

function make_player(x,y)
	return {
		x=x,
		y=y,
		speed=2,
		sprite=1,
		w=1,
		h=1,
		fx=false,
		update=update_player,
		draw=draw_player,
	}
end
__gfx__
0
0000000004444403333333333333333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004fcfc03333333333333333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700004ffef033333333333333335333333333333bb300000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000ff00033333333b3443333333333333333bb3300000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000088888f3333b33b33334333333334333bbbb33300000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700f88888003333bb3b3333433333333433333bb33300000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000111100333333bb33333333333334433333bb3300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001001003333333333333333333333433333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333333333333933333433333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333333333333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333333333333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333333333333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000033333443353333333bbb33333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000333334333333333333bb33333933333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333433333333333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333433333333333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333433333333334333333333335333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333333393334333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333333333334333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333333333333335333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333333333333333333334333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000333333bbb3b33333333333334333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000033333333b3b33339333333334333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000033333333bbb33333333333343333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000333333333b333333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333333333333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000333333333333333333333333bb33b33300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003393333334433333333333333b3b333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333443333333353333333bbb333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333334333333333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333333333333333333933333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333333333333333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0203040502030405020304050203040502020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1213141512131415020304051213141502020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2223242522232425121314152223242502020304050202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3233343532333435222324253233343502121314150202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203040502030402323334350203040502222324250202020202020304050202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1213141502030405131415151213141502323334350202020202121314150202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2223242512131415232425252223242502020202030405020202222324250202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3233343522232425333435353233343502020212131415020202323334350202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203040532333435020304050203040502020222232425020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1213141512131415121314151213141502020232333435020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2223242522232425222324252223242502020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3233343532333435323334353233343502020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203040502030405020304050203040502020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1213141512131415121314151213141502020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2223242522232425222324252223242502020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3233343532333435323334353233343502020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000e05014050160501b0502204025040280402b0302c0200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000030030280401f05019050100400b0300a03000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01200000005550055500555005550055500555005550055503555035550355503555035550355503555035550855508555085550855508555085550a5550a5550755507555075550755502555025550355503555
01200000005550055500555005550055500555005550055503555035550355503555035550355503555035550855508555085550855508555085550a5550a555075550755507555075550b5550b5550b5550b555
0120000000002000020c0520e0520f05211052130521605218052000020000200002180521a0521a0521a0521b0521d0521f05222052000020000200002000020000200002000020000200002000020000200002
012000000000200002000023c00220052200522005220052240522305224052230520000200002000020000200002000020000200002240522305224052260522305200002000020000200002000020000200002
012000000007300000066330000000000000730663300000000730000006633000000000000073066330000000073000000663300000000000007306633000000007300000066330000000000000000663300000
012000000007300000066330000000000000730663300000000730000006633000000000000000066330000000073000000663300000000000007306600066330000000073066330000000000000000663306633
__music__
01 02424344
00 03424344
01 02040644
02 03050744

