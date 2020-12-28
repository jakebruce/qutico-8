pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--juico
--by jake

function _init()
	make_background()
	make_player(63,16)
	make_terrain()
	make_camera()
	entities={}
end

function _update60()
	update_player()
	update_camera()
	for e in all(entities) do
		e:update()
	end
end

function _draw()
	cls()
	camera()
	draw_background()
	set_camera()
	draw_terrain()
	draw_player()
	for e in all(entities) do
		e:draw()
	end
end
-->8
--player

function make_player(x,y)
	player={
		x=x,
		y=y,
		vx=0,
		vy=0,
		time_in_air=1,
		fx=false,
	}
end

function update_player()
	player.x+=player.vx
	player.y+=player.vy
	
	if (player.time_in_air<=0 and not landed()) player.time_in_air=1
	if (not landed()) player.time_in_air+=1
	
	spd=1
	if (player.time_in_air>0) spd/=3
	
	if     btn(⬅️) then
		player.vx-=0.1*spd
		player.fx=true
	elseif btn(➡️) then
		player.vx+=0.1*spd
		player.fx=false
	end
	
	player.vx=mid(-1,player.vx,1)
		
	if player.time_in_air<=0 and not btn(⬅️) and not btn(➡️) then
		player.vx*=0.9
	end
		
	if player.time_in_air<=0 then
		player.vy=0
		if btnp(⬆️) then
			jump()
		end
		
	else --player.time_in_air>0
		if player.time_in_air<7 and btnp(⬆️) then
			jump()
		elseif player.time_in_air<20 and btn(⬆️) then
			player.vy-=0.2
			player.vy=mid(-2,player.vy,0)
		elseif landed() then
			slam()
			player.time_in_air=0
			player.vy=0
		else
			player.vy+=0.1
		end
	end

	if mag(player.vx,player.vy)/200>rnd()*rnd() then
		make_particles(player.x+3,player.y+7,1)
	end

	collide(player)
end

function slam()
	trauma+=abs(player.vy*5)
	make_particles(
		player.x+3,
		player.y+7,
		flr(2*abs(player.vy)*abs(player.vy)))
	sfx(1)
end

function jump()
	sfx(0)
	player.vy=-2
	if player.time_in_air<=0 then
		player.time_in_air=1
	end
end

function draw_player()
	if player.time_in_air<=0 then
		if abs(player.vx)>0.01 then
			s=3+flr(time()*4)%2
		else
			s=1+flr(time()*2)%2
		end
	else
		if player.vy<0.25 then
			s=17
		else
			s=18
		end
	end
	spr(s,player.x,player.y,1,1,player.fx)
end
-->8
--terrain

function make_terrain()
	terrain={}
	for x=-1024,1024 do
		terrain[x]=flr(14+rnd(2))
	end
end

function draw_terrain()
	for x,y in pairs(terrain) do
		spr(8,x*8,y*8)
	end
end
-->8
--camera

function make_camera()
	camx=0
	camy=0
	tcamx=0
	tcamy=0
	trauma=0
end

function update_camera()
	tau=0.2
	
	if player.fx then
		tcamx=player.x-63
		tcamy=player.y-63
	else
		tcamx=player.x-63
		tcamy=player.y-63
	end
	
	camx=tau*tcamx+(1-tau)*camx
	camy=tau*tcamy+(1-tau)*camy
	camy+=trauma*(rnd(2)-1)
	trauma*=0.8
end

function set_camera()
	camera(camx,camy)
end
-->8
--physics

function landed()
	x=player.x
	y=player.y
	return hit(x,y,{3,8})	
end

function hit(x,y,pt)
	px=x+pt[1]
	py=y+pt[2]
	wx=flr(px/8)
	wy=flr(py/8)
	ty=terrain[wx]
	return wy==ty
end

function collide(s)
	d=0.5
	pts={
		{0, 3,-d, 0},
		{3, 0, 0,-d},
		{7, 3, d, 0},
		{3, 7, 0, d},
	}
	collision=false
	cpt=nil
	for pt in all(pts) do
		while hit(s.x,s.y,pt) do
			s.x-=pt[3]
			s.y-=pt[4]
			collision=true
			cpt=pt
		end
	end
	return collision,cpt
end

-->8
--particles

function make_particles(x,y,n)
	for i=1,n do
		add(entities,{
			x=x,
			y=y,
			vx=n/8*(rnd(2)-1),
			vy=n/32*(rnd(2)-1),
			t=rnd(30),
			c=rnd({5,6,7}),
			update=update_particle,
			draw=draw_particle,
		})
	end
end

function update_particle(s)
	s.x+=s.vx
	s.y+=s.vy
	s.vx+=0.1*(rnd(2)-1)
	s.vy+=0.1*(rnd(2)-1)
	s.t-=1
	if (s.t<0) del(entities,s)
end

function draw_particle(s)
	pset(s.x,s.y,s.c)
end
-->8
--utils

function mag(a,b)
 local a0,b0=abs(a),abs(b)
 return max(a0,b0)*0.9609+min(a0,b0)*0.3984
end
-->8
--background

function make_background()
	background={}
	colors={1,2,3,4}
	for i=1,100 do
		add(background,{
			x=rnd(128),
			y=rnd(128),
			r=rnd(32),
			c=rnd(colors),
		})
	end
end

function draw_background()
	for c in all(background) do
		circfill(c.x,c.y,c.r+1,0)
		circfill(c.x+2,c.y+2,c.r,0)
	 circfill(c.x,c.y,c.r,c.c)	
	end
end
__gfx__
00000000000ff00000000000000ff000000000000000000000000000000000006777777700000000000000000000000000000000000000000000000000000000
0000000000fcfc00000ff00000fcfc00000ff0000000000000000000000000005666666700000000000000000000000000000000000000000000000000000000
0070070000ffef0000fcfc0000ffef0000fcfc000000000000000000000000005666666700000000000000000000000000000000000000000000000000000000
00077000000ff00000ffef00090ff000000fe0900000000000000000000000005666666700000000000000000000000000000000000000000000000000000000
00077000009999000009900000999900009999000000000000000000000000005666666700000000000000000000000000000000000000000000000000000000
00700700000990000099990000099090090990000000000000000000000000005666666700000000000000000000000000000000000000000000000000000000
00000000000dd000000dd00000ddd000000ddd000000000000000000000000005666666700000000000000000000000000000000000000000000000000000000
0000000000d00d0000d00d000d00d000000d00d00000000000000000000000005555555600000000000000000000000000000000000000000000000000000000
00000000000cfc00000ff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ffff0000ffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ffef0000fcfc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ff090090fe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000090990000009909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000dd000000dd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dd00000000dd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000200000c730107511776122741167011a7011e70123701277012c7013170135701397013e7013b7010070100701007010070100701007010070100701007010070100701007010070100701007010070100701
000200001701315013130230f0430d0430b0430803307023030230000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003
