pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--lando
--by jake

maxlandingspeed=0.01
maxangle=0.01
maxslope=0.01


gravity=0.02
turnrate=0.01
thrust=0.01


function cprint(s,x,y,c)
	print(s,x-flr(#s/2*4)-2,y-3,c)
end

function draw_lose()
	draw_game()
	draw_explosion()
	camera()
	rectfill(4,4,124,16,8)
	rect(3,3,125,17,9)
	cprint("you lose! ❎ or 🅾️ to restart",63,11,6)
end

function update_lose()
	if btnp(❎) or btnp(🅾️) then
		_init()
	end
end

function update_win()
	if btnp(❎) or btnp(🅾️) then
		_init()
	end
end

function draw_explosion()
	for i=1,300 do
		dx=rnd()*(rnd(2)-1)*16
		dy=rnd()*(rnd(2)-1)*16
		pset(ship.x+dx,ship.y+dy,
							rnd({8,9,10}))
	end
end

function draw_win()
	draw_game()
	camera()
	rectfill(4,4,124,16,3)
	rect(3,3,125,17,11)
	cprint("you win! ❎ or 🅾️ to restart",63,11,6)
end

function _init()
	_update=update_game
	_draw=draw_game	
	ship={
		x=63,
		y=10,
		vx=0,
		vy=0,
		t=0,
	}
	particles={}
	make_terrain()
end

function make_terrain()
	terrain={}
	x=-256
	y=120
	repeat
		dx=rnd(16)
		dy=rnd(16)-8
		if (y+dy>127) dy=127-y
		add(terrain,{
			x1=x,y1=y,x2=x+dx,y2=y+dy
		})
		x+=dx
		y+=dy
	until x>256+128
end

function update_game()
	ship.vy+=gravity
	
	if (btn(⬅️)) ship.t+=turnrate
	if (btn(➡️)) ship.t-=turnrate
	
	if btn(⬆️) then
		spawn_particle()
		dx,dy=rot(0,4,ship.t)
		ship.vx-=dx*thrust
		ship.vy-=dy*thrust
	end
	
	ship.x+=ship.vx
	ship.y+=ship.vy
	
	for p in all(particles) do
		p.x+=p.vx
		p.y+=p.vy
		p.vx+=rnd(0.02)-0.01
		p.vy+=rnd(0.02)-0.01
		if p.x<ship.x-128 or p.y<ship.y-128 or p.x>ship.x+128 or p.y>ship.y+128 then
			del(particles,p)
		end
	end
	
	if landed() then
		win_time=time()
		_update=update_win
		_draw=draw_win
	elseif crashed() then
		lose_time=time()
		_update=update_lose
		_draw=draw_lose	
	end
end

function mag(a,b)
 local a0,b0=abs(a),abs(b)
 return max(a0,b0)*0.9609+min(a0,b0)*0.3984
end

function spawn_particle()
	x,y=rot(0,6,ship.t)
	add(particles,{
		x=ship.x+x,
		y=ship.y+y,
		vx=ship.vx+x*0.1+rnd(0.2)-0.1,
		vy=ship.vy+y*0.1+rnd(0.2)-0.1,
		c=flr(rnd({8,9,10})),
	})
end

function hit_terrain()
	for i,seg in pairs(terrain) do
		m=(seg.y2-seg.y1)/(seg.x2-seg.x1)
		c=seg.y2-m*seg.x2
		sy=m*ship.x+c
		if ship.x>seg.x1 and ship.x<seg.x2 and abs(sy-ship.y)<4 then
		 return i
		end
	end
	return -1	
end

function slow()
	return mag(ship.vx,ship.vy)<maxlandingspeed
end

function upright()
	return abs(ship.t)<maxangle
end

function crashed()
	t=hit_terrain()
	return t>0 and (not slow() or not upright() or not flat(t))
end

function flat(t)
	seg=terrain[t]
	m=(seg.y2-seg.y1)/(seg.x2-seg.x1)
	return abs(m)<maxslope
end

function landed()
	t=hit_terrain()
	return t>0 and slow() and upright() and flat(t)
end

function draw_game()
	cls()
	camera(ship.x-63,ship.y-32)
	x=ship.x
	y=ship.y
	x1,y1=rot(-4,4,ship.t)
	x2,y2=rot(0,-4,ship.t)
	x3,y3=rot(4,4,ship.t)
	x4,y4=rot(0,4,ship.t)
	line(x+x1,y+y1,x+x2,y+y2,6)
	line(x+x2,y+y2,x+x3,y+y3,6)
	line(x+x3,y+y3,x+x1,y+y1,6)
	rectfill(x+x4-1,y+y4-1,
										x+x4+1,y+y4+1,6)

	for p in all(particles) do
		pset(p.x,p.y,p.c)
	end
	
	for seg in all(terrain) do
		line(seg.x1,seg.y1,seg.x2,seg.y2,6)
	end
end

function rot(x,y,t)
	rx=x*cos(t)-y*sin(t)
	ry=y*cos(t)+x*sin(t)	
	return rx,ry
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
