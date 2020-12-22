pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--platformo
--by jake bruce

function _init()
	cfg={
		g=0.9, --gravity
		px=6, --player start location
		py=6,
		pa=0.5, --player acceleration
		pv=3, --max player speed
	 jv=8, --jump speed
		cs=0.25, --camera speed
	}
	
	cx=0
	cy=0

	entities={}
	player=make_player()
	add(entities,player)
end
-->8
--updates

function _update()
	for e in all(entities) do
		e:update()
	end
	glide_camera()
end


function glide_camera()
	x=player.x-64
	y=player.y-64
	cx=cfg.cs*x+(1-cfg.cs)*cx
	cy=cfg.cs*y+(1-cfg.cs)*cy
end


function _collide(x,y,pt)
	mx=(x+pt[1]+0.5)/8
	my=(y+pt[2]+0.5)/8
	s=mget(flr(mx),flr(my))
	return fget(s,0)
end


function collide(e,fr)
	pts={
		{4,7,4}, --bottom
		{4,0,2}, --top
		{0,4,1}, --left
		{7,4,3}, --right
	}
	fi=0
	for pt in all(pts) do
		pset(e.x+pt[1],e.y+pt[2],pt[3])
	 i=pt[3]
	 c=false
		while _collide(e.x,e.y,pt) do
			c=true
			if i==1 then
				e.x+=0.5
				e.vx=0
			elseif i==2 then
				e.y+=0.5
				e.vy=0
			elseif i==3 then
				e.x-=0.5
				e.vx=0
			elseif i==4 then
				e.y-=0.5
				e.vy=0
			end
		end
		if (c and fi==0) fi=i
	end
	return fi
end
-->8
--draws

function _draw()
	cls()
	camera(cx,cy)
	map()
	for e in all(entities) do
		e:draw()
	end
end
-->8
--entities

function make_player()
	return {
		x=cfg.px*8,
		y=cfg.py*8,
		vx=0,
		vy=0,
		n={17,18,19,20}, --anim frames
		ni=1, --animation idx
		ns=0.25, --animation speed
		jump=true,
		left=true,
		path={},
		update=function(s)
			add(s.path,{s.x,s.y})
			while #s.path>30 do
				deli(s.path,1)
			end
			
			if btn(➡️) or btn(⬅️) then
				--advance animation
				s.ni=s.ni+s.ns
				if s.ni>=#s.n+1 then
					s.ni=1
				end
				
				--move left/right
				if (btn(⬅️)) s.vx-=cfg.pa
				if (btn(➡️)) s.vx+=cfg.pa
			else
				s.ni=1
				if (not s.jump) s.vx=0
			end
			
			--gravity
			s.vy+=cfg.g
			
			--jump
			if btnp(⬆️) and not s.jump then
				s.vy=-cfg.jv
			 s.jump=true
			end
			
			if (btn(⬅️)) s.left=true
			if (btn(➡️)) s.left=false
			
			s.vx=mid(-cfg.pv,s.vx,cfg.pv)
			
			s.x += s.vx
			s.y += s.vy
			
		 c=collide(s)
		 if (s.jump) s.jump=c!=4
		 if (s.vy>1) s.jump=true
		end,
		draw=function(s)
			for pt in all(s.path) do
				pset(pt[1]+4,pt[2]+4,1)
			end
			
			spr(s.n[flr(s.ni)],s.x,s.y,
				1,1,s.left,false)
		end,
	}
end
__gfx__
00000000444444443333333367777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000445444443333333356666667000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700444444443444333456666667000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000444444444444434456666667000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000444445444444444456666667000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700444444444444445456666667000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444444444544444456666667000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444444444444444455555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000ff00000000000000ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ff00000077000000ff000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000770000007700000077000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000077000000cc00000077000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000cc00000ccc000000cc000000fcc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000cc00000f0f000000cc00000f00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000f00000f00ff00000f000000ff0f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ff0000ff00000000ff00000000ff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000677777770000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555555560000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000677777770000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555555560000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000677777770000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555555560000000000000000000
00000000000000000000000000000000000000000000067777777677777776777777700000000000000000000000000000000677777770000000000000000000
00000000000000000000000000000000000000000000056666667566666675666666700000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000056666667566666675666666700000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000056666667566666675666666700000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000056666667566666675666666700000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000056666667566666675666666700000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000056666667566666675666666700000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000055555556555555565555555600000000000000000000000000000000555555560000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000677777770000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555555560000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000677777770000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000100100000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000100000000100000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000100000000000000100000000000000000000000000000000000000555555560000000000000000000
00000677777776777777700000000000000000000000000000000000000000000000000000000000000000000000000000000677777770000000000000000000
0000056666667566666670000000000000000000000010000000000000000000000ff00000000000000000000000000000000566666670000000000000000000
00000566666675666666700000000000000000000000000000000000000000000107700000000000000000000000000000000566666670000000000000000000
00000566666675666666700000000000000000000000000000000000000000000007700000000000000000000000000000000566666670000000000000000000
0000056666667566666670000000000000000000000000000000000000000000000cc00000000000000000000000000000000566666670000000000000000000
0000056666667566666670000000000000000000010000000000000000000000000cc00000000000000000000000000000000566666670000000000000000000
0000056666667566666670000000000000000000000000000000000000000000000f000000000000000000000000000000000566666670000000000000000000
0000055555556555555560000000000000000000000000000000000000000000000ff00000000000000000000000000000000555555560000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000067777777000000000000000000000000677777770000000000000000000
00000000000000000000000000000000000000100000000000000000000000000000056666667000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000056666667000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000056666667000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000056666667000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000056666667000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000056666667000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000010000000000000000000000000000000055555556000000000000000000000000555555560000000000000000000
00000000000000000000000000000000000000000000000000000333333333333333333333333000000000000000000000000677777770000000000000000000
00000000000000000000000000000000000000000000000000000333333333333333333333333000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000344433343444333434443334000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000444443444444434444444344000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000444444444444444444444444000000000000000000000000566666670000000000000000000
00000000000000000000000000000000001000000000000000000444444544444445444444454000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000454444444544444445444444000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000444444444444444444444444000000000000000000000000555555560000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000677777770000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555555560000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000677777770000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555555560000000000000000000
00000000000000000000000000000677777776777777700000000000000006777777700000000000000000000000000000000677777770000000000000000000
00000000000000000000000000000566666675666666700000000000000005666666700000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000566666675666666700000000000000005666666700000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000566666675666666700000000000000005666666700000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000566666675666666700000000000000005666666700000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000566666675666666700000000000000005666666700000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000566666675666666700000000000000005666666700000000000000000000000000000000566666670000000000000000000
00000000000000000000000000000555555565555555600000000000000005555555600000000000000000000000000000000555555560000000000000000000
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333330000000000000000000
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333330000000000000000000
43334344433343444333434443334344433343444333434443334344433343444333434443334344433343444333434443334344433340000000000000000000
44344444443444444434444444344444443444444434444444344444443444444434444444344444443444444434444444344444443440000000000000000000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444440000000000000000000
44454444444544444445444444454444444544444445444444454444444544444445444444454444444544444445444444454444444540000000000000000000
44444454444444544444445444444454444444544444445444444454444444544444445444444454444444544444445444444454444440000000000000000000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444440000000000000000000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444440000000000000000000
44444445444444454444444544444445444444454444444544444445444444454444444544444445444444454444444544444445444440000000000000000000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444440000000000000000000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444440000000000000000000
44544444445444444454444444544444445444444454444444544444445444444454444444544444445444444454444444544444445440000000000000000000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444440000000000000000000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444440000000000000000000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444440000000000000000000

__gff__
0001010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0300000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000030303000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000303000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000030000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000202020000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000303000003000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
