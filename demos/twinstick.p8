pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--twinstick
--by jake

function _init()
	trauma=0
	
	--enable keyboard and mouse
	poke(0x5f2d,1)
	
	init_keytracker()
	
	player=make_player(63,63)
	ents={player}
	
	for i=1,10 do
		add(ents,make_enemy())
	end

	for i=1,20 do
		add(ents,make_star())
	end
end

function _draw()
	cls()
	camera((rnd(2)-1)*trauma,(rnd(2)-1)*trauma)
	for e in all(ents) do
		e:draw()
	end
	draw_crosshair()
end

function _update60()
	trauma*=0.8
	for e in all(ents) do
		e:update()
	end
end

function get_key()
	if stat(30) then
		return stat(31)
	else
		return false
	end
end

function get_mouse()
	return {
		x=stat(32),
		y=stat(33),
		b=stat(34),
		w=stat(36),
	}
end

function init_keytracker()
	keystate={
		["w"]=false,
		["a"]=false,
		["s"]=false,
		["d"]=false,
	}
end
-->8
--entities

function make_bullet(s,x,y,vx,vy)
	return {
		x=x,
		y=y,
		vx=vx,
		vy=vy,
		c=rnd({7,8,9,10}),
		owner=s,
		ent=3,
		update=update_bullet,
		draw=draw_bullet,	
	}
end

function make_player(x,y)
	return {
		x=x,
		y=y,
		s=0.5,
		tx=0,
		ty=0,
		ent=1,
		update=update_player,
		draw=draw_player,
	}
end

function make_enemy()
	return {
		x=rnd(127),
		y=rnd(127),
		vx=0,
		vy=0,
		ent=2,
		update=update_enemy,
		draw=draw_enemy,
	}
end

function make_shrapnel(x,y)
	return {
		x=x,
		y=y,
		vx=(rnd(2)-1)*3,
		vy=(rnd(2)-1)*3,
		ent=4,
		c=rnd({7,8,9,10}),
		update=update_shrapnel,
		draw=draw_shrapnel,
	}
end

function make_star()
	return {
		x=rnd(128),
		y=rnd(128),
		update=noop,
		draw=function(s) pset(s.x,s.y,7) end,
	}
end
-->8
--updates

function update_shrapnel(s)
	s.x+=s.vx
	s.y+=s.vy
	if offscreen(s) then
		del(ents,s)
	end
end

function update_bullet(s)
	s.x+=s.vx
	s.y+=s.vy
	if offscreen(s) then
		del(ents,s)
	end
	for e in all(ents) do
		-- if not a bullet
		if (e.ent==1 or e.ent==2) and s.owner!=e then
			dx=s.x-e.x
			dy=s.y-e.y
			d=mag(dx,dy)
			if d<2 then
				explode(s,e)
			end
		end
	end
end

function explode(bullet,ent)
	for i=1,flr(rnd(20))+1 do
		add(ents,make_shrapnel(ent.x,ent.y))
	end
	del(ents,bullet)
	del(ents,ent)
	trauma+=5
end

function update_player(s)
	if (btn(⬅️)) s.x-=s.s
	if (btn(➡️)) s.x+=s.s
	if (btn(⬆️)) s.y-=s.s
	if (btn(⬇️)) s.y+=s.s
	m=get_mouse()
	s.tx=m.x
	s.ty=m.y
	if m.b==1 then
		dx=s.tx-s.x
		dy=s.ty-s.y
		d=mag(dx,dy)
		vx=dx/d
		vy=dy/d
		b=make_bullet(s,s.x+vx,s.y+vy,vx,vy)
		add(ents,b)
	end
end

function update_enemy(s)
	s.vx+=(rnd(2)-1)*0.03
	s.vy+=(rnd(2)-1)*0.03
	if (s.x>120) s.vx-=0.01
	if (s.y>120) s.vy-=0.01
	if (s.x<8) s.vx+=0.01
	if (s.y<8) s.vy+=0.01
	s.x+=s.vx
	s.y+=s.vy
	if rnd()<0.003 then
		dx=(player.x-s.x)+rnd(20)-10
		dy=(player.y-s.y)+rnd(20)-10
		d=mag(dx,dy)
		ux=dx/d
		uy=dy/d
		add(ents,make_bullet(s,s.x+ux,s.y+uy,ux,uy))
	end
end
-->8
--draws

function draw_shrapnel(s)
	pset(s.x,s.y,s.c)
end

function draw_crosshair()
	x=player.tx
	y=player.ty
	line(x-1,y-1,x+1,y+1,7)
	line(x+1,y-1,x-1,y+1,7)
end

function draw_player(s)
	draw_cross(s.x,s.y,3)	
end

function draw_enemy(s)
	draw_cross(s.x,s.y,8)
end

function draw_bullet(s)
	pset(s.x,s.y,s.c)
end

function draw_cross(x,y,c)
	line(x-1,y,x+1,y,c)	
	line(x,y-1,x,y+1,c)
end
-->8
--utils

function offscreen(s)
	return s.x<0 or s.y<0 or s.x>128 or s.y>128
end

function mag(a,b)
 local a0,b0=abs(a),abs(b)
 return max(a0,b0)*0.9609+min(a0,b0)*0.3984
end

function noop() end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
