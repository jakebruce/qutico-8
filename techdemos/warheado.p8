pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--warheado
--by jake

function _init()
	cam={
		x=-63,
		y=-63,
		t=0.05,
	}
	stars=generate_stars(100)
	planets=generate_planets(5)
	blasts={}
	ships=generate_ships(5)
	camera_target=player
	bullet=nil
	explosion=nil
end

function generate_ships(n)
	local ships={}
	local ship_sprites={1,2,3,4,5}
	for i=1,n do
		local p=rnd(planets)
		local a=rnd()
		local s={
			x=p.x+(p.r+4)*cos(a),
			y=p.y-(p.r+4)*sin(a),
			hp=10,
			firing_angle=a,
			active=i==1,
			player=i==1,
			sprite=rnd(ship_sprites),
		}
		add(ships,s)
		if (s.player) then
			player=s
		end
	end
	return ships
end

function generate_stars(n)
	local stars={}
	for i=1,n do
		add(stars,{
			x=rnd(256)-128,
			y=rnd(256)-128,
			d=true,
			c=7,
		})
	end
	return stars
end

function generate_planets(n)
	local planets={}
	local cs={
		{12,13,1},
		{6,13,5},
		{14,8,2},
		{10,11,3},
		{10,9,4},
	}
	while #planets<n do
		local p={
			x=rnd(256)-128,
			y=rnd(256)-128,
			r=rnd(32)+8,
			c=rnd(cs),
		}
		local clear=true
		for q in all(planets) do
			local d=p.r+q.r
			if mag(q.x-p.x,q.y-p.y)<d+10 then
				clear=false
			end
		end
		if (clear) add(planets, p)
	end
	return planets
end
-->8
--updates

function _update60()
	update_camera()
	handle_input()
	update_bullet()
	update_explosion()
end

function update_bullet()
	if (bullet==nil) return
	local b=bullet
	explode=false
	for p in all(planets) do
		dx=p.x-b.x
		dy=p.y-b.y
		d=mag(dx,dy)
		ux=dx/(d+0.01)
		uy=dy/(d+0.01)
		f=p.r/5/d
		b.vx+=f*ux
		b.vy+=f*uy
		if (d<p.r) explode=true
	end
	for bl in all(blasts) do
		if mag(b.x-bl.x,b.y-bl.y)<bl.r then
			explode=false
		end
	end
	if explode then
		explosion=make_explosion(b)
		bullet=nil
	else
		b.x+=b.vx
		b.y+=b.vy
	end
end

function update_explosion()
	if (explosion==nil) return
	explosion.t-=1
	if explosion.t<1 then
		explosion=nil
		camera_target=player
	end
end

function make_explosion(b)
	sfx(1)
	explosion={
		x=b.x,
		y=b.y,
		r=rnd(5)+5,
		t=60,
	}
	add(blasts,explosion)
	camera_target=explosion
	return explosion
end

function update_camera()
	cam.x=camera_target.x*cam.t+(1-cam.t)*cam.x
	cam.y=camera_target.y*cam.t+(1-cam.t)*cam.y
end
	
function handle_input()
	if (btn(⬅️)) player.firing_angle+=0.01
	if (btn(➡️)) player.firing_angle-=0.01
	if (btnp(❎)) fire()
end

function fire()
	if (camera_target!=player) return
	local dx= cos(player.firing_angle)
	local dy=-sin(player.firing_angle)
	bullet={
		x=player.x+8*dx,
		y=player.y+8*dy,
		vx=dx*2,
		vy=dy*2,
		sprite=16,
	}
	camera_target=bullet
	sfx(0)
end
-->8
--draws

function _draw()
	cls()
	camera(cam.x-63,cam.y-63)
	draw_stars()
	draw_planets()
	draw_blasts()
	draw_ships()
	draw_bullet()
	draw_explosion()
end

function draw_explosion()
	if (explosion==nil) return
	x=explosion
	t=cos(x.t/60/4-0.1)
	r=x.r*t
	circfill(x.x,x.y,r/1,10)
	circfill(x.x,x.y,r/2,9)
	circfill(x.x,x.y,r/3,8)
end

function draw_bullet()
	if (bullet==nil) return
	spr(bullet.sprite,bullet.x-4,bullet.y-4)
end

function draw_ships()
	for s in all(ships) do
		spr(s.sprite,s.x-4,s.y-4)
		if s.active then
			line(s.x,s.y,
				s.x+8*cos(s.firing_angle),
				s.y-8*sin(s.firing_angle),7)
		end
	end
end

function draw_stars()
	for s in all(stars) do
		pset(s.x,s.y,s.c)
	end
end

function draw_planets()
	for p in all(planets) do
		for i,c in pairs(p.c) do
			circfill(p.x,p.y,p.r/sqrt(i),c)
		end
	end
end

function draw_blasts()
	for b in all(blasts) do
		circfill(b.x,b.y,b.r,0)
	end
end
-->8
--entities
-->8
--utils

function sin(x)
	return cos(x-0.25)
end

function mag(a,b)
	local a0,b0=abs(a),abs(b)
 return max(a0,b0)*0.9609+min(a0,b0)*0.3984
end
__gfx__
00000000000000000a000a0000000000000000001111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd0000a55a000800b080006666601999f99f00000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700011111d000a555aa08888880055555601f76f76f00000000000000000000000000000000000000000000000000000000000000000000000000000000
000770001191911da055555008989b8b052e25601f77ff7900000000000000000000000000000000000000000000000000000000000000000000000000000000
000770001181811d0aa55550b898998005e8e5601ff76f7900000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070001111110000a55a0089b9b80052e256011f77f7900000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001111000aa0000a08888888055555000199999900000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000b0000000000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00056000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000200002f0502a0502705000000210501b0501705000000100500905002050000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400002461026610286102a6202c6302d6402f65030650336503565036660386603c6603c6603b6603a6603a66039660386603765034650316402d6302963024630206201b6201961016600106000d6000c600
