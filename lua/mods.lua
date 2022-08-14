if not P1 or not P2 then
	backToSongWheel('Two Players Required')
	return
end
-- set slump, it's unlockable at 80.01% to further frustrate you slight smile
	slumpo = false 
	for pn = 1, 2 do
		if GAMESTATE:IsPlayerEnabled(pn-1) then 
			if GAMESTATE:GetCurrentSteps(pn-1):GetDifficulty() == 5 then
				slumpo = true
			end
		end
	end
-- judgment / combo proxies
	for pn = 1, 2 do
		setupJudgeProxy(PJ[pn], P[pn]:GetChild('Judgment'), pn)
		setupJudgeProxy(PC[pn], P[pn]:GetChild('Combo'), pn)
	end
-- player proxies
	for pn = 1, #PP do
		PP[pn]:SetTarget(P[pn])
		P[pn]:hidden(1)
	end
-- your code goes here here here here here here here:
-- define mods
	definemod{'rotx','roty','rotz',function(xDegrees, yDegrees, zDegrees, plr)
		local axes = xDegrees ~= 0 and 1 or 0 + yDegrees ~= 0 and 1 or 0 and zDegrees ~= 0 and 1 or 0
		local angles
		local DEG_TO_RAD = math.pi / 180
		if axes > 1 then
			local function mindf_reverseRotation(angleX, angleY, angleZ)
				local sinX = math.sin(angleX);
				local cosX = math.cos(angleX);
				local sinY = math.sin(angleY);
				local cosY = math.cos(angleY);
				local sinZ = math.sin(angleZ);
				local cosZ = math.cos(angleZ);
				return { math.atan2(-cosX*sinY*sinZ-sinX*cosZ,cosX*cosY),
						math.asin(-cosX*sinY*cosZ+sinX*sinZ),
						math.atan2(-sinX*sinY*cosZ-cosX*sinZ,cosY*cosZ) }
			end
			angles = mindf_reverseRotation(xDegrees * DEG_TO_RAD, yDegrees * DEG_TO_RAD, zDegrees * DEG_TO_RAD)
		else
			angles = { -xDegrees * -DEG_TO_RAD, -yDegrees * DEG_TO_RAD, -zDegrees * DEG_TO_RAD }
		end
		local rotationx,rotationy,rotationz=
			xDegrees,
			yDegrees,
			zDegrees
		local confusionxoffset,confusionyoffset,confusionzoffset=
			(angles[1]*100),
			(angles[2]*100),
			(angles[3]*100)

		return rotationx,rotationy,rotationz,confusionxoffset,confusionyoffset,confusionzoffset
	end,
	'rotationx','rotationy','rotationz','confusionxoffset','confusionyoffset','confusionzoffset'
	}

	local p1DefaultX = P1:GetX()
	local p2DefaultX = P2:GetX()

	definemod{ 'centerPlayfields', function(percent) 
		local scale = percent / 100
		P1:x((scale*scx) + ((1-scale)*p1DefaultX))
		P2:x((scale*scx) + ((1-scale)*p2DefaultX))
	end }
	pi = 3.14

	function FastVibrate(start,length,intensity)
		for i = start,start+length-1/16,1/16 do
			ease
			{i,1/32,linear,-intensity,'x'}
			{i+1/32,1/32,linear,intensity,'x'}
		end
		ease {start+length,1/32,linear,0,'x'}
	end
-- set the tables
	--[[
	bg_flash1onoff = {
		{0,64},
		{96,156},
		{176,240}
	}
	bg_flash2onoff = {
		{80,92},
		{160,172}
	}
	]]--
	anger_wiggle = {
		{98,2},
		{102,1},
		{106,2},
		{98+16,2},
		{102+16,1},
		{106+16,2},
	}
	annoy_yell_normal = {
		{35.000-32,0,2},
		{36.500-32,1,1},
		{37.000-32,2,1},
		{37.750-32,1,1},
		{38.500-32,3,1},
		{38.750-32,0,1},
		{39.000-32,3,1},
		{39.250-32,0,1},
		{39.500-32,3,1},
		{35.000,0,2},
		{36.500,1,1},
		{37.000,2,1},
		{37.750,1,1},
		{38.500,3,1},
		{38.750,0,1},
		{39.000,3,1},
		{39.250,0,1},
		{39.500,3,1},
	}
	annoy_yell_slumpo = {
		{35.000-32,3,2},
		{36.500-32,2,1},
		{37.000-32,2,1},
		{37.750-32,0,1},
		{38.500-32,2,1},
		{38.750-32,1,1},
		{39.000-32,2,1},
		{39.250-32,1,1},
		{39.500-32,3,1},
		{35.000,0,2},
		{35.000,3,2},
		{36.500,2,1},
		{37.000,2,1},
		{37.750,0,1},
		{38.500,2,1},
		{38.750,1,1},
		{39.000,2,1},
		{39.250,1,1},
		{39.500,3,1},
	}
	-- I'm lazy
	enrage_vibrate = {
		{128,0.25,15},
		{132,0.5,20},
		{136,0.25,25},
		{138,0.25,25},
		{140,1,30},
		{142,1.75,30},
		{128+16,0.5,35},
		{132+16,0.5,20},
		{136+16,0.5,15},
		{138+16,0.5,15},
	}
-- background shit
	-- turn on bg
	bg_black:diffuse(0,0,0,1)
	bg_quadpanel:diffuse(0,0,0,1)
	bg_quadpanel:xy(scx,scy)
	bg_quadpanel:zoomto(sw*3,sw*3)

	-- set the quadpanel bg
	definemod{'quadpanelbgzoom', 'quadpanelbgspeedx', 'quadpanelbgspeedy', 'quadpanelbgrotation', function(zoom,x,y,rot)
		bg_quadpanel:customtexturerect(0,0,zoom,zoom)
		bg_quadpanel:texcoordvelocity(x,y)
		bg_quadpanel:rotationz(rot)
	end}

	setdefault{100,'quadpanelbgzoom'}

	-- fade in
	func_ease{0,16,inQuad,0.5,0,function(a)
		bg_fadein:diffuse(0,0,0,a)
	end}

	--[[
	for i,v in ipairs(bg_flash1onoff) do
		for j = v[1],v[2] do
			func_ease {j,1,outCubic,1,0,function(a)
				bg_vignette:diffusealpha(60/255,10/255,0,a)
			end}
		end
	end
	]]--
	func_ease{0,32,inQuad,0.25,0.9,function(a)
		bg_vignette:zoom(a)
	end}
	func_ease{64,80-64,inQuad,0.9,0.6,function(a)
		bg_vignette:zoom(a)
	end}
	func_ease{80,92-80,inQuad,0.6,0.8,function(a)
		bg_vignette:zoom(a)
	end}
	func_ease{156,4,inQuad,0.8,0.6,function(a)
		bg_vignette:zoom(a)
	end}
	func_ease{160,172-160,inQuad,0.6,0.8,function(a)
		bg_vignette:zoom(a)
	end}
	func_ease{236,4,inQuad,0.8,0.6,function(a)
		bg_vignette:zoom(a)
	end}
	func_ease{240,270-240,inQuad,0.6,0.25,function(a)
		bg_vignette:zoom(a)
	end}
	func_ease{271,1,outCubic,0.25,0,function(a)
		bg_vignette:zoom(a)
	end}
	-- colors

	for i = 0,31 do
		func_ease {i,1,outCubic,1,0,function(a)
			bg_vignette:diffuse(70/255,40/255,0,a)
		end}
	end

	for i = 32,59 do
		func_ease {i,1,outCubic,1,0,function(a)
			bg_vignette:diffuse(70/255,25/255,0,a)
		end}
	end
	
	func_ease{60,1,outCubic,1,0.25,function(a)
		bg_vignette:diffuse(70/255,25/255,0,a)
	end}

	func_ease{61,2,linear,0,1,function(a)
		bg_vignette:diffuse((70 + a*10)/255,(25 - a*15)/255,0,(0.25 + a*0.75))
	end}

	ease {61,3,inQuad,80,'quadpanelbgzoom',90,'quadpanelbgrotation'}

	func_ease{64,1,outCubic,1,0,function(a)
		bg_vignette:diffuse(140/255,10/255,0/255,a)
	end}

	func_ease{65,6,linear,0,0.25,function(a)
		bg_vignette:diffuse(140/255,(10 - a*40)/255,0/255,a)
	end}

	for i = 71,72 do
		func_ease{i,1,outCubic,1,0.25,function(a)
			bg_vignette:diffuse(140/255,0/255,0/255,a)
		end}
	end

	func_ease{73,7,linear,0.25,0.5,function(a)
		bg_vignette:diffuse(140/255,0/255,0/255,a)
	end}

	for i = 80,91 do
		func_ease{i,0.5,outCubic,1,0.25,function(a)
			bg_vignette:diffuse(140/255,0/255,0/255,a)
		end}
		func_ease{i+0.5,0.5,outCubic,1,0.25,function(a)
			bg_vignette:diffuse(140/255,0/255,40/255,a)
		end}
	end

	func{92,function()
		bg_vignette:diffuse(140/255,0/255,40/255,0.5)
	end}

	for i = 96,128 do
		func_ease{i,1,outCubic,1,0.25,function(a)
			bg_vignette:diffuse(140/255,0/255,60/255,a)
		end}
	end

	for i = 128,156 do
		func_ease{i,1,outCubic,1,0.25,function(a)
			bg_vignette:diffuse(140/255,0/255,100/255,a)
		end}
	end

	for i = 160,167 do
		func_ease{i,0.5,outCubic,0.75,0.25,function(a)
			bg_vignette:diffuse(140/255,0/255,0/255,a)
		end}
		func_ease{i+0.5,0.5,outCubic,0.75,0.25,function(a)
			bg_vignette:diffuse(140/255,0/255,40/255,a)
		end}
	end

	for i = 168,171 do
		func_ease{i,0.5,outCubic,1,0.25,function(a)
			bg_vignette:diffuse(140/255,0/255,0/255,a)
		end}
		func_ease{i+0.5,0.5,outCubic,1,0.25,function(a)
			bg_vignette:diffuse(140/255,0/255,40/255,a)
		end}
	end

	func{172,function()
		bg_vignette:diffuse(170/255,0/255,60/255,0.5)
	end}

	for i = 176,208 do
		func_ease{i,1,outCubic,1,0.25,function(a)
			bg_vignette:diffuse(170/255,0/255,60/255,a)
		end}
	end

	for i = 208,236 do
		func_ease{i,1,outCubic,1,0.25,function(a)
			bg_vignette:diffuse(170/255,0/255,120/255,a)
		end}
	end

	func_ease{240,1,outCubic,1,0.25,function(a)
		bg_vignette:diffuse(60/255,30/255,60/255,a)
	end}

	for i = 241,270 do
		func_ease{i,1,outCubic,0.66,0.25,function(a)
			bg_vignette:diffuse(60/255,30/255,60/255,a)
		end}
	end

	ease{64,92-64,inQuad,360*8+90,'quadpanelbgrotation',30,'quadpanelbgzoom'}
	set 
	{92,20,'quadpanelbgzoom',0,'quadpanelbgrotation'}
	{92.75,15,'quadpanelbgzoom'}
	for i = 93.5,94.75,0.25 do
		set {i,20+(i-92.75)*35,'quadpanelbgzoom'}
	end
	for i = 95,95.5,0.25 do
		set {i,80-(i-95)*40,'quadpanelbgzoom'}
	end
	ease 
	{96,32,linear,360*2,'quadpanelbgrotation'}
	{128,32,linear,0,'quadpanelbgrotation'}
	{156,4,linear,80,'quadpanelbgzoom'}
	ease{160,172-160,inQuad,360*4+90,'quadpanelbgrotation',30,'quadpanelbgzoom'}
	set 
	{172,20,'quadpanelbgzoom',0,'quadpanelbgrotation'}
	{172.75,15,'quadpanelbgzoom'}
	for i = 173.5,174.75,0.25 do
		set {i,20+(i-172.75)*35,'quadpanelbgzoom'}
	end
	for i = 175,175.5,0.25 do
		set {i,80-(i-175)*40,'quadpanelbgzoom'}
	end
	ease 
	{176,32,linear,360*3,'quadpanelbgrotation'}
	{208,32,linear,0,'quadpanelbgrotation'}
	{236,4,linear,80,'quadpanelbgzoom'}
-- ARROWS!
	setdefault{3.5,'xmod',100,'halgun',125,'drawsizefront',
		-100,'drawsizeback',100,'stealthtype',100,'stealthpastreceptors'
		,100,'dizzyholds',100,'centerPlayfields',1,'zbuffer',
		100,'disablemines'}
		

-- Section 1: Bother
	for i = 0,60 do
		ease
		{i-0.250,0.250,inCubic,100*9/10,'zoomx'}
		{i-0.250,0.250,inCubic,100*10/9,'zoomy'}
		{i+0.000,0.125,outExpo,100*7/6,'zoomx'}
		{i+0.000,0.125,outExpo,100*5/8,'zoomy'}
		{i+0.125,0.375,outCubic,100,'zoomx'}
		{i+0.125,0.375,outCubic,100,'zoomy'}
	end
	add {0,0,linear,200,'zoom'}
	ease {0,1,outExpo,100,'zoom'}

	-- I get it this is a super messy implementation
	if slumpo then
		for i,v in ipairs(annoy_yell_slumpo) do
			-- :agony:
			if v[3] ~= 1 then
				if v[2] < 2 then
					ease
					{v[1],0.5/2,outExpo,-25*pi,'confusionoffset'..v[2]}
					{v[1]+0.5/2,0.5*3/2,outCubic,0,'confusionoffset'..v[2]}
					{v[1],0.5/2,outExpo,-300,'tiny'..v[2]}
					{v[1]+0.5/2,0.5*3/2,outCubic,0,'tiny'..v[2]}
				else
					ease
					{v[1],0.5/2,outExpo,25*pi,'confusionoffset'..v[2]}
					{v[1]+0.5/2,0.5*3/2,outCubic,0,'confusionoffset'..v[2]}
					{v[1],0.5/2,outExpo,-300,'tiny'..v[2]}
					{v[1]+0.5/2,0.5*3/2,outCubic,0,'tiny'..v[2]}
				end
			elseif v[2] < 2 then
				ease
				{v[1],0.25/2,outExpo,-25*pi,'confusionoffset'..v[2]}
				{v[1]+0.25/2,0.25*3/2,outCubic,0,'confusionoffset'..v[2]}
				{v[1],0.25/2,outExpo,-300,'tiny'..v[2]}
				{v[1]+0.25/2,0.25*3/2,outCubic,0,'tiny'..v[2]}
			else
				ease
				{v[1],0.25/2,outExpo,25*pi,'confusionoffset'..v[2]}
				{v[1]+0.25/2,0.25*3/2,outCubic,0,'confusionoffset'..v[2]}
				{v[1],0.25/2,outExpo,-300,'tiny'..v[2]}
				{v[1]+0.25/2,0.25*3/2,outCubic,0,'tiny'..v[2]}
			end
		end
	else
		for i,v in ipairs(annoy_yell_normal) do
			if v[3] ~= 1 then
				ease
					{v[1],0.5/2,outExpo,-25*pi,'confusionoffset'..v[2]}
					{v[1]+0.5/2,0.5*3/2,outCubic,0,'confusionoffset'..v[2]}
					{v[1],0.5/2,outExpo,-300,'tiny'..v[2]}
					{v[1]+0.5/2,0.5*3/2,outCubic,0,'tiny'..v[2]}
			elseif v[2] < 2 then
				ease
				{v[1],0.25/2,outExpo,-25*pi,'confusionoffset'..v[2]}
				{v[1]+0.25/2,0.25*3/2,outCubic,0,'confusionoffset'..v[2]}
				{v[1],0.25/2,outExpo,-300,'tiny'..v[2]}
				{v[1]+0.25/2,0.25*3/2,outCubic,0,'tiny'..v[2]}
			else
				ease
				{v[1],0.25/2,outExpo,25*pi,'confusionoffset'..v[2]}
				{v[1]+0.25/2,0.25*3/2,outCubic,0,'confusionoffset'..v[2]}
				{v[1],0.25/2,outExpo,-300,'tiny'..v[2]}
				{v[1]+0.25/2,0.25*3/2,outCubic,0,'tiny'..v[2]}
			end
		end
	end

	for i = 0,16,16 do
		ease
		{i+3.0,0.25,outCubic,100,'invert'}
		{i+3.5,0.25,outCubic,0,'invert'}
		{i+4.0,0.25,outCubic,100,'invert'}
		{i+5.0,0.25,outCubic,0,'invert'}
		{i+5.5,0.25,outCubic,100,'invert'}
		{i+6.0,0.25,outCubic,0,'invert'}
		{i+7.0,0.25,outCubic,100,'flip'}
		{i+8.0,0.25,outCubic,0,'flip'}

		{i+11.0,0.25,outCubic,100,'invert'}
		{i+11.5,0.25,outCubic,0,'invert'}
		{i+12.0,0.25,outCubic,100,'invert'}
		{i+13.0,0.25,outCubic,0,'invert'}
		{i+13.5,0.25,outCubic,100,'invert'}
		{i+14.0,0.25,outCubic,0,'invert'}
		{i+14.5,0.25,outCubic,100,'flip'}
		{i+15.0,0.25,outCubic,0,'flip'}
	end
	plr = 1
	ease
	{13.5,0.5,outExpo,
		-15,'rotationz',
		-15,'reverse',
		-sw*3/32,'x',
		50,'stealth'
	}
	{14.0,0.5,outExpo,
		15,'rotationz',
		sw*3/32,'x'
	}
	{15.5,0.5,outExpo,
		0,'rotationz',
		-25,'reverse',
		0,'x'
		
	}
	{16,0.5,outExpo,
		0,'reverse',
		0,'stealth'
	}
	plr = nil
	add
	{16,0.125,outExpo,
		30,'zoomx',
		-15,'zoomy'
	}
	plr = 2
	add
	{30,0.25,outExpo,
		-90,'zoomx',
		75,'zoomy'
	}
	{30.5,0.25,outExpo,
		120,'zoomx',
		-70,'zoomy'
	}
	set {31, -sh/4,'y'}
	ease
	{31,0.25,outExpo,-300,'tiny'}
	{31,1,inQuad,
		-200,'flip',
		sh*5/4,'y',
		200*pi,'confusionoffset'
	}
	plr = 1
	ease
	{31,1,inCubic,-15,'reverse'}
	add
	{31,1,inCubic,
		50,'zoomx',
		-75,'zoomy',
		
	}
	ease
	{31,0.5,outCubic,75,'brake'}
	plr = nil
	ease
	{32,0.125,outBack,125,'reverse'}
	{32.125,0.375,outCubic,100,'reverse'}

-- Section 2: Dishearten
	plr = 2
	set {32,
		0,'flip',
		0,'y',
		0,'confusionoffset',
		0,'tiny'
	}
	plr = 1
	set {32, 0,'brake'}
	plr = nil
	local dishearten_space = 200
	set {32,
		50, 'flip',
		-dishearten_space, 'movex0',
		dishearten_space, 'movex3',
		-dishearten_space, 'movez1',
		dishearten_space, 'movez2',
		2.75,'xmod'
	}
	
	add {32,0.333,outExpo,
		50,'zoomx',
		-33,'zoomy'
	}

	-- halo
	ease {32,60-32,linear,
		360*4,'rotationy',
		-200*pi*4,'confusionyoffset',
		166,'zoomz'
	}
	add
	{48,0.25,outExpo,-400,'tiny'}
	{48.25,0.75,outCubic,400,'tiny'}
	{48,0.25,linear,240*pi,'confusionoffset'}
	{48.25,0.75,outCubic,-40*pi,'confusionoffset'}

	-- transition out of halo
	ease {60,1,linear,
		0, 'flip',
		0, 'movex0',
		0, 'movex3',
		0, 'movez1',
		0, 'movez2',
		100,'zoomz'
	}
	{61.0,0.25,outCubic,100,'invert'}
	{61.5,0.25,outCubic,0,'invert'}
	{62.0,0.25,outCubic,100,'invert'}
	{62.5,0.25,outCubic,100,'flip'}
	{62.5,0.25,outCubic,0,'invert'}
	{63.0,0.25,outCubic,0,'flip'}
	
	{60.0,3.00,inQuad,
		100,'centered',
		1.75,'xmod',
		-400,'mini',
		50,'brake'
	}
	{63.000,0.875,outCubic,
		-60,'rotationx',
		
	}
	{63.875,0.25,outCubic,
		10,'rotationx',
		0,'reverse',
		0,'brake',
	}
	{64.000,0.125,outCubic,-800,'mini',2.25,'xmod'}
	{64.125,0.25,outCubic,
		0,'rotationx',
		0,'mini',
	}

-- Section 3: Irritate
	plr = 1
	set {64,100,'reverse'}
	
	plr = nil
	ease
	{64,24,linear,360*6,'rotx',-400*pi*6,'confusionxoffset'}
	{88,4,linear,360*2,'rotx',-400*pi*2,'confusionxoffset'}
	set {88,800,'confusion'}
	set {92,0,'confusion'}

	-- extra oomph
	for i = 71,72 do
		ease
		{i,0.5,pop,-800,'tiny'}
	end

	perframe {64, 16, function(beat, poptions)
		poptions[1].centered = 100 + math.sin(beat/4 * math.pi) * 10
		poptions[2].centered = 100 - math.sin(beat/4 * math.pi) * 10
	end
	}
	for i = 80,87 do
		plr = 1
		ease
		{i+0.0,0.25,outCubic,225,'centered'}
		{i+0.5,0.25,outCubic,-25,'centered'}
		plr = 2
		ease
		{i+0.0,0.25,outCubic,-25,'centered'}
		{i+0.5,0.25,outCubic,225,'centered'}
		plr = nil
		ease
		{i+0.00,0.50,pop,50,'bumpyx'}
		{i+0.50,0.50,pop,50,'bumpyx'}
		{i+0.00,0.25,outCubic, 80,'zoomx'}
		{i+0.25,0.25, inCubic,100,'zoomx'}
		{i+0.50,0.25,outCubic,125,'zoomx'}
		{i+0.75,0.25, inCubic,100,'zoomx'}
		{i+0.00,0.25,outCubic,125,'zoomy'}
		{i+0.25,0.25, inCubic,100,'zoomy'}
		{i+0.50,0.25,outCubic, 80,'zoomy'}
		{i+0.75,0.25,inCubic,100,'zoomy'}
	end

	ease {88,0.25,outCubic,100,'centered'}

	for i = 80,87.5,0.5 do
		ease {i,0.5,pop,-200,'tiny'}
	end

	ease{92,0.25,outCubic,0,'centered'}
	{92,0.25,outCubic,50,'stealth',plr=1}
	{92.75,0.25,outCubic,0,'reverse',plr=1}
	{92.75,0.25,outCubic,100,'reverse',plr=2}

	for i = 93.5,95,0.5 do
		plr = 1
		set
		{i+0.0,0,'stealth'}
		{i+0.25,100,'stealth'}
		{i+0.0,0,'dark'}
		{i+0.25,100,'dark'}
		{i+0.0,0,'hidenoteflash'}
		{i+0.25,100,'hidenoteflash'}
		{i+0.0,10-(i-93.5)*5,'rotz'}
		{i+0.25,0,'rotz'}
		plr = 2
		set
		{i+0.0,100,'stealth'}
		{i+0.25,0,'stealth'}
		{i+0.0,100,'dark'}
		{i+0.25,0,'dark'}
		{i+0.0,100,'hidenoteflash'}
		{i+0.25,0,'hidenoteflash'}
		{i+0.0,0,'rotz'}
		{i+0.25,10-(i-93.75)*5,'rotz'}
	end
	plr = 1
	set {95.5,0,'stealth',0,'dark',100,'centered',0,'hidenoteflash'}
	plr = 2
	set {95.5,100,'stealth',100,'dark',0,'rotz'}
	plr = nil
	ease
	{95.5,0.5,inCubic,0,'centered',3.25,'xmod'}
	{95.5,0.25,inCubic,100,'tiny'}
	{95.5,0.25,inCubic,50,'mini'}

-- Section 4: Anger
	func{95.5,function() PP[2]:hidden(1) end}

	for i = 96,112,16 do
		for j = i,i+8,4 do
			FastVibrate(j,0.5,15)
		end
	end
	-- speen
	add
	{96,30,linear,720*15/16,'rotz'}

	-- time to flip off someone
	for i = 96,96+24,4 do
		ease
		{i,0.25,outExpo,-20,'flip'}
		{i+0.25,0.75,inCubic,12.5,'flip'}
		{i+2,0.5,outCubic,50,'flip'}
		{i+3,0.25,outCubic,120,'flip'}
		{i+3.25,0.75,inCubic,50,'flip'}
	end

	ease 
	{96+16,0.5,outCubic,0,'flip'}
	{124,0.5,outCubic,0,'flip'}
	
	-- Jumpscare
	for i = 96,96+28,4 do
		ease
		{i-0.125,0.125,inCubic,50,'tiny'}
		{i-0.125,0.125,inCubic,25,'mini'}
		{i+0.000,0.125,outExpo,-200,'tiny'}
		{i+0.000,0.125,outExpo,-100,'mini'}
		{i+0.125,0.625,inCubic,0,'tiny'}
		{i+0.125,0.625,inCubic,0,'mini'}
		for j = 1,3,2 do
			ease
			{j+i-0.250,0.250,inCubic,10,'tiny'}
			{j+i-0.250,0.250,inCubic,5,'mini'}
			{j+i+0.000,0.125,outExpo,-100,'tiny'}
			{j+i+0.000,0.125,outExpo,-50,'mini'}
			{j+i+0.125,0.625,inCubic,0,'tiny'}
			{j+i+0.125,0.625,inCubic,0,'mini'}
		end
	end
	add
	{111.125,0.625,inCubic,100,'tiny'}
	{111.125,0.625,inCubic,50,'mini'}

	-- tilt (no this is not a pun)
	for i = 96,96+16,16 do
		ease
		{i+0.000,0.125,outExpo,-45,'rotx'}
		{i+0.125,0.875,inCubic,0,'rotx'}
		{i+1.000,0.125,outExpo,30,'rotx'}
		{i+1.125,0.875,inCubic,0,'rotx'}
		{i+4.000,0.125,outExpo,-45,'roty'}
		{i+4.125,0.875,inCubic,0,'roty'}
		{i+5.000,0.125,outExpo,30,'roty'}
		{i+5.125,0.875,inCubic,0,'roty'}
		{i+8.000,0.125,outExpo,45,'rotx'}
		{i+8.125,0.875,inCubic,0,'rotx'}
		{i+9.000,0.125,outExpo,-30,'rotx'}
		{i+9.125,0.875,inCubic,0,'rotx'}
	end
	

	-- wiggle wiggle wiggle
	for i,v in ipairs(anger_wiggle) do
		set {v[1],50,'bumpyx'}
		ease{v[1],v[2],inCubic,100,'bumpyx'}
		set {v[1]+v[2],0,'bumpyx'}
	end
	for i = 96,96+16,16 do
		for j = 96,96+8,4 do
			set {i+j,200,'bumpyz'}
			ease{i+j,1,outExpo,0,'bumpyz'}
		end
	end

	-- blacklolita hi-tech funnies
	set {108,500,'bumpyx'}
	ease{108,1,inQuint,0,'bumpyx'}
	set {109.5,100,'bumpyy'}
	set {110,200,'bumpyy'}
	set {111,0,'bumpyy'}

	for j = 108,110,2 do
		--[[
		for i = j,j+15/16,1/16 do
			ease
			{i,1/32,linear,-30,'x'}
			{i+1/32,1/32,linear,30,'x'}
		end
		ease {j+1,1/32,linear,0,'x'}
		]]--
		FastVibrate(j,1,30)
	end

	for i = 109,109.5,0.5 do
		add
		{i+0.00,0.25,outCubic,-50*pi,'confusionxoffset'}
		{i+0.25,0.25,outCubic,50*pi,'confusionxoffset'}
	end

	-- Transition into Enrage
	set 
	{124,-400,'beat',200,'beatmult'}
	{124.75,0,'beat'}
	add
	{126.000,0.125,outCubic,-22.5,'rotz'}
	{126.125,0.375,inCubic,45,'rotz'}
	{126.500,1.500,linear,22.5,'rotz'}
	for i = 126.5,127.75,0.25 do
		set {i,0,'centered2'}
		ease {i,0.25,linear,100,'centered2'}
	end
	set {128,0,'centered2'}
	add {127.50,0.50,inCubic,100,'mini'}
	ease
	{128.00,0.25,outExpo,-200,'mini'}
	{128.25,0.75,outCubic,0,'mini'}
-- Section 5: Enrage
	local inv = 1
	set {128,3.5,'xmod'}
	for j = 128,144,16 do
		ease
		{j-0.5,0.5,inCubic,80,'zoomx'}
		{j+0,0.125,outCubic,150,'zoomx'}
		{j+0.125,0.375,outCubic,100,'zoomx'}
		{j-0.5,0.5,inCubic,120,'zoomy'}
		{j+0,0.125,outCubic,66,'zoomy'}
		{j+0.125,0.375,outCubic,100,'zoomy'}
		set {j,0,'rotx',0,'roty',0,'rotz'}
		for i = j,j+4,4 do
			ease
			{i+0.0,2.0,inQuad,-50,'flip'}
			{i+2.0,1.0,outExpo,0,'flip'}
			{i+0.0,2.0,inQuad,-360*inv,'roty'}
			{i+2.0,1.0,outExpo,180*inv,'roty'}
			{i+0.5,1.5,inQuad,300,'bumpy'}
			{i+0.0,2.0,inQuad,30*inv,'rotx'}
			{i+2.0,1.0,outExpo,0,'rotx'}
			{i+3.5,0.5,inCubic,80,'zoomx'}
			{i+4.250,0.125,outCubic,133,'zoomx'}
			{i+4.375,0.375,outCubic,100,'zoomx'}
			{i+3.5,0.5,inCubic,120,'zoomy'}
			{i+4.250,0.125,outCubic,75,'zoomy'}
			{i+4.375,0.375,outCubic,100,'zoomy'}

			set
			{i+0.5,100,'bumpy',150,'bumpyperiod'}
			{i+4.0,0,'bumpy'}
			inv = inv*-1
		end
		add
		{j+2.00,2.000,inQuad,360,'roty'}
		{j+6.00,1.000,inQuad,-180,'roty'}
		ease
		{j+1.50,0.50,inCubic,100,'mini'}
		{j+2.00,0.25,outExpo,-200,'mini'}
		{j+2.25,0.75,outCubic,0,'mini'}
		{j+5.50,0.50,inCubic,50,'mini'}
		{j+6.00,0.25,outExpo,-100,'mini'}
		{j+6.25,0.75,outCubic,0,'mini'}

		{j+4.00,0.25,outExpo,100,'reverse'}
		{j+8.00,0.25,outExpo,0,'reverse'}

		{j+7.50,1.00,pop,sh/15,'y'}

		add
		{j+7.0,0.5,outCubic,30,'rotx'}
		{j+7.0,0.5,outCubic,-30,'roty'}
		{j+7.0,0.5,outCubic,30,'rotz'}
		{j+7.5,0.5,outCubic,-60,'rotx'}
		{j+7.5,0.5,outCubic,60,'roty'}
		{j+7.5,0.5,outCubic,-60,'rotz'}
		{j+8.0,0.5,outCubic,30,'rotx'}
		{j+8.0,0.5,outCubic,-30,'roty'}
		{j+8.0,0.5,outCubic,30,'rotz'}
	end
	for i,v in ipairs(enrage_vibrate) do
		FastVibrate(v[1],v[2],v[3])
	end
	for j = 136,138,2 do
		for i = 0,1 do
			add
			{j,0.5,pop,-50,'movex'..i}
			{j,0.5,pop,-50,'movey'..i}
			{j,0.5,pop,50*pi,'confusionoffset'..i}
		end
		for i = 2,3 do
			add
			{j,0.5,pop,50,'movex'..i}
			{j,0.5,pop,-50,'movey'..i}
			{j,0.5,pop,-50*pi,'confusionoffset'..i}
		end
		set {j,0,'y',0,'bumpyy',0,'roty'}
		add {j,0.5,pop,-75,'flip'}
		if not slumpo then
			add {j,2,inQuad,-360*inv,'roty'}
		end
		ease
		{j,2,outCubic,100,'bumpyy'}
		{j,0.25,outExpo,30*inv,'rotz'}
		{j+0.5,1.5,inCubic,0,'rotz'}
		{j-0.5,0.5,inCubic,80,'zoomx'}
		{j+0.250,0.125,outCubic,133,'zoomx'}
		{j+0.375,0.375,outCubic,100,'zoomx'}
		{j-0.5,0.5,inCubic,120,'zoomy'}
		{j+0.250,0.125,outCubic,75,'zoomy'}
		{j+0.375,0.375,outCubic,100,'zoomy'}
		inv = inv*-1
	end
	ease
	{138,0.25,outExpo,100,'reverse'}
	{140,0.25,outExpo,0,'reverse'}
	{140.250,0.125,outCubic,133,'zoomx'}
	{140.375,0.375,outCubic,100,'zoomx'}
	{140-0.5,0.5,inCubic,120,'zoomy'}
	{140.250,0.125,outCubic,75,'zoomy'}
	{140.375,0.375,outCubic,100,'zoomy'}
	set {140,0,'bumpyy'}

	-- return of the blacklolita hi-tech funnies
	set {140,500,'bumpyx'}
	ease{140,1,inQuint,0,'bumpyx'}
	set {141.5,25,'bumpyy'}
	set {142,50,'bumpyy'}
	set {143,0,'bumpyy'}

	ease
	{140-0.125,0.125,inCubic,50,'tiny'}
	{140-0.125,0.125,inCubic,25,'mini'}
	{140.000,0.125,outExpo,-200,'tiny'}
	{140.000,0.125,outExpo,-100,'mini'}
	{140.125,0.625,inCubic,0,'tiny'}
	{140.125,0.625,inCubic,0,'mini'}

	-- Player 2 returns
	func{141,function() PP[2]:hidden(0) end}
	plr = 2
	set {141,0,'dark'}
	ease
	{141.5,0.5,outExpo,
		-15,'rotationz',
		-15,'reverse',
		-sw*5/32,'x',
		75,'stealth'
	}
	{142.0,0.5,outExpo,
		15,'rotationz',
		sw*11/32,'x'
	}
	{143.5,0.5,outExpo,
		0,'rotationz',
		-25,'reverse',
		0,'x'
		
	}
	{144,0.5,outExpo,
		0,'reverse',
		0,'stealth'
	}
	plr = nil
	add
	{144,0.125,outExpo,
		50,'zoomx',
		-50,'zoomy'
	}

	-- ON THE DANCE FLOOR
	ease
	{153,0.25,outCubic,100,'alternate',-200,'tiny1',-200,'tiny3'}
	{153.25,0.25,outCubic,0,'tiny1',0,'tiny3'}
	{153.5,0.25,outCubic,0,'alternate',100,'reverse',-200,'tiny0',-200,'tiny2'}
	{153.75,0.25,outCubic,0,'tiny0',0,'tiny2'}
	{154-0.125,0.125,inCubic,50,'tiny'}
	{154-0.125,0.125,inCubic,25,'mini'}
	{154.000,0.125,outExpo,-200,'tiny'}
	{154.000,0.125,outExpo,-100,'mini'}
	{154.125,0.25,inCubic,0,'tiny'}
	{154.125,0.25,inCubic,0,'mini'}
	{155,0.25,outCubic,-100,'split',-200,'tiny2',-200,'tiny3'}
	{155.25,0.25,outCubic,0,'tiny2',0,'tiny3'}
	{155.5,0.25,outCubic,0,'split',0,'reverse',-200,'tiny0',-200,'tiny1'}
	{155.75,0.25,outCubic,0,'tiny0',0,'tiny1'}

	-- Transition into Infuriate
	for i = 156,158 do
		ease
		{i,0.166,outCubic,-33,'rotz'}
		{i+0.166,1-0.166,inCubic,0,'rotz'}
	end

	ease 
	{157,0.25,outCubic,100,'reverse'}
	{158,0.25,outCubic,0,'reverse'}

	plr = 2
	ease {159,0.25,outCubic,100,'reverse'}

	plr = nil
	ease {159.5,0.5,inBack,100,'centered'}

-- Section 6: Infuriate -- This part should be similar to Section 3: Irritate
	set {160,0,'rotx',0,'roty',0,'rotz',0,'confusionxoffset',2.25,'xmod'}
	plr = 1
	set {160,100,'reverse'}
	plr = 2
	set {160,0,'reverse'}
	plr = nil
	ease
	{160,10,linear,360*3,'rotx',-400*pi*3,'confusionxoffset'}
	{170,2,linear,360,'rotx',-400*pi,'confusionxoffset'}
	set 
	{168,800,'confusion'}
	{172,0,'confusion'}

	perframe {160, 8, function(beat, poptions)
		poptions[1].centered = 100 + math.sin(beat/4 * math.pi) * 10
		poptions[2].centered = 100 - math.sin(beat/4 * math.pi) * 10
	end
	}

	for i = 168,169 do
		plr = 1
		ease
		{i+0.0,0.25,outCubic,225,'centered'}
		{i+0.5,0.25,outCubic,-25,'centered'}
		plr = 2
		ease
		{i+0.0,0.25,outCubic,-25,'centered'}
		{i+0.5,0.25,outCubic,225,'centered'}
		plr = nil
		ease
		{i+0.00,0.50,pop,50,'bumpyx'}
		{i+0.50,0.50,pop,50,'bumpyx'}
		{i+0.00,0.25,outCubic, 80,'zoomx'}
		{i+0.25,0.25, inCubic,100,'zoomx'}
		{i+0.50,0.25,outCubic,125,'zoomx'}
		{i+0.75,0.25, inCubic,100,'zoomx'}
		{i+0.00,0.25,outCubic,125,'zoomy'}
		{i+0.25,0.25, inCubic,100,'zoomy'}
		{i+0.50,0.25,outCubic, 80,'zoomy'}
		{i+0.75,0.25,inCubic,100,'zoomy'}
	end
	ease 
	{170,0,outCubic,100,'centered'}
	{160,12,linear,-50,'mini',2,'xmod'}
	for i = 160,164,4 do
		ease {i,0.5,pop,-800,'tiny'}
	end
	set {172,0,'mini',2.25,'xmod'}

	ease{172,0.25,outCubic,0,'centered'}
	{172,0.25,outCubic,50,'stealth',plr=1}
	{172.75,0.25,outCubic,0,'reverse',plr=1}
	{172.75,0.25,outCubic,100,'reverse',plr=2}

	for i = 173.5,175,0.5 do
		plr = 1
		set
		{i+0.0,0,'stealth'}
		{i+0.25,100,'stealth'}
		{i+0.0,0,'dark'}
		{i+0.25,100,'dark'}
		{i+0.0,0,'hidenoteflash'}
		{i+0.25,100,'hidenoteflash'}
		{i+0.0,10-(i-173.5)*5,'rotz'}
		{i+0.25,0,'rotz'}
		plr = 2
		set
		{i+0.0,100,'stealth'}
		{i+0.25,0,'stealth'}
		{i+0.0,100,'dark'}
		{i+0.25,0,'dark'}
		{i+0.0,100,'hidenoteflash'}
		{i+0.25,0,'hidenoteflash'}
		{i+0.0,0,'rotz'}
		{i+0.25,10-(i-173.75)*5,'rotz'}
	end
	plr = 1
	set {175.5,0,'stealth',0,'dark',100,'centered',0,'hidenoteflash'}
	plr = 2
	set {175.5,100,'stealth',100,'dark',0,'rotz'}
	plr = nil
	ease
	{175.5,0.5,inCubic,0,'centered',3.25,'xmod'}
	{175.5,0.25,inCubic,100,'tiny'}
	{175.5,0.25,inCubic,50,'mini'}
	
-- Section 7: Aggravate -- This part should be similar to Section 4: Anger
	func{175.5,function() PP[2]:hidden(1) end}
	set {176,3.5,'xmod',0,'rotx',0,'roty',0,'rotz'}

	for i = 176,192,16 do
		for j = i,i+8,4 do
			FastVibrate(j,0.5,15)
		end
	end
	-- speen
	add
	{176,30,linear,-720*15/16,'rotz'}
	{176,0.125,outExpo,-100,'tiny'}

	-- Jumpscare
	for i = 176,176+28,4 do
		ease
		{i-0.125,0.125,inCubic,50,'tiny'}
		{i-0.125,0.125,inCubic,25,'mini'}
		{i+0.000,0.125,outExpo,-250,'tiny'}
		{i+0.000,0.125,outExpo,-125,'mini'}
		{i+0.125,0.625,inCubic,0,'tiny'}
		{i+0.125,0.625,inCubic,0,'mini'}
		for j = 1,3,2 do
			ease
			{j+i-0.250,0.250,inCubic,10,'tiny'}
			{j+i-0.250,0.250,inCubic,5,'mini'}
			{j+i+0.000,0.125,outExpo,-100,'tiny'}
			{j+i+0.000,0.125,outExpo,-50,'mini'}
			{j+i+0.125,0.625,inCubic,0,'tiny'}
			{j+i+0.125,0.625,inCubic,0,'mini'}
		end
	end

	-- time to flip off someone... again
	for i = 176,192,16 do
		ease
		{i+1,1,inSine,100,'flip'}
		{i+2,1,inSine,0,'flip'}
		{i+3,1,inSine,100,'flip'}
		{i+5,1,inSine,0,'flip'}
		{i+6,1,inSine,100,'flip'}
		{i+7,1,inSine,0,'flip'}
		{i+1,1,inSine,45,'roty'}
		{i+2,1,inSine,-45,'roty'}
		{i+3,1,inSine,0,'roty'}
		{i+5,1,inSine,-45,'rotx'}
		{i+6,1,inSine,45,'rotx'}
		{i+7,1,inSine,0,'rotx'}

		
		{i+9,0.5,inCubic,150,'flip'}
		{i+9.5,1,inQuint,100,'flip'}


		{i+9.0,0.5,inCubic,100,'tiny'}
		{i+9.0,0.5,inCubic,50,'mini'}
		{i+9.5,0.125,outExpo,-200,'tiny'}
		{i+9.5,0.125,outExpo,-100,'mini'}
		{i+9.625,0.875,inQuint,0,'tiny'}
		{i+9.625,0.875,inQuint,0,'mini'}

		FastVibrate(i+9.5,1,35)

		set {i+0,25,'bumpyx'}
		set {i+1,100,'bumpyx'}
		set {i+4,50,'bumpyx'}
		set {i+9.5,200,'bumpyx'}
		ease{i+9.5,1,inQuint,0,'bumpyx'}
	end

	FastVibrate(188,1,35)
	ease
	{187.5,0.5,inCubic,-50,'flip'}
	{188,1,inQuint,0,'flip'}

	{187.5,0.5,inCubic,100,'tiny'}
	{187.5,0.5,inCubic,50,'mini'}
	{188,0.125,outExpo,-200,'tiny'}
	{188,0.125,outExpo,-100,'mini'}
	{188.125,0.875,inQuint,0,'tiny'}
	{188.125,0.875,inQuint,0,'mini'}

	for i = 189,191.5,0.5 do
		add
		{i+0.00,0.25,outCubic,-50*pi,'confusionxoffset'}
		{i+0.25,0.25,outCubic,50*pi,'confusionxoffset'}
	end

	-- even more blacklolita hi-tech funnies
	set {188,200,'bumpyx'}
	ease{188,1,inQuint,0,'bumpyx'}
	set {189.5,100,'bumpyy'}
	set {190,150,'bumpyy'}
	set {192,0,'bumpyy'}

	-- Transition into Exasperate
	ease
	{204,0.5,outCubic,0,'flip'}
	set 
	{204,-400,'beat',200,'beatmult'}
	{204.75,0,'beat'}
	add
	{206.000,0.125,outCubic,22.5,'rotz'}
	{206.125,0.375,inCubic,-45,'rotz'}
	{206.500,1.500,linear,-22.5,'rotz'}
	for i = 206.5,207.75,0.25 do
		set {i,0,'centered2'}
		ease {i,0.25,linear,100,'centered2'}
	end
	set {208,0,'centered2'}
	add {207.50,0.50,inCubic,100,'mini'}
	ease
	{208.00,0.25,outExpo,-200,'mini'}
	{208.25,0.75,outCubic,0,'mini'}

-- Section 8: Exasperate -- This part should be similar to Section 5: Enrage
	set {208,3.5,'xmod'}

	for i,v in ipairs(enrage_vibrate) do -- rushing code amirite this is not readable at all
		FastVibrate(v[1]+80,v[2],v[3])
	end

	for j = 208,224,16 do
		ease
		{j-0.5,0.5,inCubic,80,'zoomx'}
		{j+0,0.125,outCubic,150,'zoomx'}
		{j+0.125,0.375,outCubic,100,'zoomx'}
		{j-0.5,0.5,inCubic,120,'zoomy'}
		{j+0,0.125,outCubic,66,'zoomy'}
		{j+0.125,0.375,outCubic,100,'zoomy'}
		set {j,0,'rotx',0,'roty',0,'rotz'}
		for i = j,j+4,4 do
			ease
			{i+0.0,2.0,inQuad,-50,'flip'}
			{i+2.0,1.0,outExpo,0,'flip'}
			{i+0.0,2.0,inQuad,-360*inv,'roty'}
			{i+2.0,1.0,outExpo,180*inv,'roty'}
			{i+0.5,1.5,inQuad,300,'bumpy'}
			{i+0.0,2.0,inQuad,30*inv,'rotx'}
			{i+2.0,1.0,outExpo,0,'rotx'}
			{i+3.5,0.5,inCubic,80,'zoomx'}
			{i+4.250,0.125,outCubic,133,'zoomx'}
			{i+4.375,0.375,outCubic,100,'zoomx'}
			{i+3.5,0.5,inCubic,120,'zoomy'}
			{i+4.250,0.125,outCubic,75,'zoomy'}
			{i+4.375,0.375,outCubic,100,'zoomy'}

			set
			{i+0.5,100,'bumpy',150,'bumpyperiod'}
			{i+4.0,0,'bumpy'}
			inv = inv*-1
		end
		add
		{j+2.00,2.000,inQuad,360,'roty'}
		{j+6.00,1.000,inQuad,-180,'roty'}
		ease
		{j+1.50,0.50,inCubic,100,'mini'}
		{j+2.00,0.25,outExpo,-200,'mini'}
		{j+2.25,0.75,outCubic,0,'mini'}
		{j+5.50,0.50,inCubic,50,'mini'}
		{j+6.00,0.25,outExpo,-100,'mini'}
		{j+6.25,0.75,outCubic,0,'mini'}

		{j+4.00,0.25,outExpo,100,'reverse'}
		{j+8.00,0.25,outExpo,0,'reverse'}

		{j+7.50,1.00,pop,sh/15,'y'}

		add
		{j+7.0,0.5,outCubic,30,'rotx'}
		{j+7.0,0.5,outCubic,-30,'roty'}
		{j+7.0,0.5,outCubic,30,'rotz'}
		{j+7.5,0.5,outCubic,-60,'rotx'}
		{j+7.5,0.5,outCubic,60,'roty'}
		{j+7.5,0.5,outCubic,-60,'rotz'}
		{j+8.0,0.5,outCubic,30,'rotx'}
		{j+8.0,0.5,outCubic,-30,'roty'}
		{j+8.0,0.5,outCubic,30,'rotz'}
	end
	for i,v in ipairs(enrage_vibrate) do
		FastVibrate(v[1],v[2],v[3])
	end
	for j = 216,218,2 do
		for i = 0,1 do
			add
			{j,0.5,pop,-50,'movex'..i}
			{j,0.5,pop,-50,'movey'..i}
			{j,0.5,pop,50*pi,'confusionoffset'..i}
		end
		for i = 2,3 do
			add
			{j,0.5,pop,50,'movex'..i}
			{j,0.5,pop,-50,'movey'..i}
			{j,0.5,pop,-50*pi,'confusionoffset'..i}
		end
		set {j,0,'y',0,'bumpyy',0,'roty'}
		add {j,0.5,pop,-75,'flip'}
		if not slumpo then
			add {j,2,inQuad,-360*inv,'roty'}
		end
		ease
		{j,2,outCubic,100,'bumpyy'}
		{j,0.25,outExpo,30*inv,'rotz'}
		{j+0.5,1.5,inCubic,0,'rotz'}
		{j-0.5,0.5,inCubic,80,'zoomx'}
		{j+0.250,0.125,outCubic,133,'zoomx'}
		{j+0.375,0.375,outCubic,100,'zoomx'}
		{j-0.5,0.5,inCubic,120,'zoomy'}
		{j+0.250,0.125,outCubic,75,'zoomy'}
		{j+0.375,0.375,outCubic,100,'zoomy'}
		inv = inv*-1
	end
	ease
	{218,0.25,outExpo,100,'reverse'}
	{220,0.25,outExpo,0,'reverse'}
	{220.250,0.125,outCubic,133,'zoomx'}
	{220.375,0.375,outCubic,100,'zoomx'}
	{220-0.5,0.5,inCubic,120,'zoomy'}
	{220.250,0.125,outCubic,75,'zoomy'}
	{220.375,0.375,outCubic,100,'zoomy'}
	set {220,0,'bumpyy'}

	-- return of the blacklolita hi-tech funnies
	set {220,500,'bumpyx'}
	ease{220,1,inQuint,0,'bumpyx'}
	set {221.5,25,'bumpyy'}
	set {222,50,'bumpyy'}
	set {223,0,'bumpyy'}

	ease
	{220-0.125,0.125,inCubic,50,'tiny'}
	{220-0.125,0.125,inCubic,25,'mini'}
	{220.000,0.125,outExpo,-200,'tiny'}
	{220.000,0.125,outExpo,-100,'mini'}
	{220.125,0.625,inCubic,0,'tiny'}
	{220.125,0.625,inCubic,0,'mini'}

	-- Player 2 returns
	func{221,function() PP[2]:hidden(0) end}
	plr = 2
	set {221,0,'dark'}
	ease
	{221.5,0.5,outExpo,
		-15,'rotationz',
		-15,'reverse',
		-sw*11/32,'x',
		75,'stealth'
	}
	{222.0,0.5,outExpo,
		15,'rotationz',
		sw*5/32,'x'
	}
	{223.5,0.5,outExpo,
		0,'rotationz',
		-25,'reverse',
		0,'x'
		
	}
	{224,0.5,outExpo,
		0,'reverse',
		0,'stealth'
	}
	plr = nil
	add
	{224,0.125,outExpo,
		50,'zoomx',
		-50,'zoomy'
	}

	-- ON THE DANCE FLOOR
	ease
	{233,0.25,outCubic,100,'alternate',-200,'tiny1',-200,'tiny3'}
	{233.25,0.25,outCubic,0,'tiny1',0,'tiny3'}
	{233.5,0.25,outCubic,0,'alternate',100,'reverse',-200,'tiny0',-200,'tiny2'}
	{233.75,0.25,outCubic,0,'tiny0',0,'tiny2'}
	{234-0.125,0.125,inCubic,50,'tiny'}
	{234-0.125,0.125,inCubic,25,'mini'}
	{234.000,0.125,outExpo,-200,'tiny'}
	{234.000,0.125,outExpo,-100,'mini'}
	{234.125,0.25,inCubic,0,'tiny'}
	{234.125,0.25,inCubic,0,'mini'}
	{235,0.25,outCubic,-100,'split',-200,'tiny2',-200,'tiny3'}
	{235.25,0.25,outCubic,0,'tiny2',0,'tiny3'}
	{235.5,0.25,outCubic,0,'split',0,'reverse',-200,'tiny0',-200,'tiny1'}
	{235.75,0.25,outCubic,0,'tiny0',0,'tiny1'}

	-- Transition into Dishearten
	{236-0.125,0.125,inCubic,25,'mini'}
	{236.000,0.125,outExpo,-200,'tiny'}
	{236.000,0.125,outExpo,-100,'mini'}
	{236.125,0.375,inCubic,0,'tiny'}
	{236.125,0.375,inCubic,0,'mini'}
	{236,0.5,outCubic,-15,'roty'}
	{236.5,3.5,outSine,360*2,'roty'}

	set {236.5,100,'bumpyx'}
	ease{236.5,3.5,outSine,10,'bumpyx'}

-- Section 9: Dishearten -- This part should be similar to Section 2: Dishearten
	local depress_space = 150
	local depress_space2 = 300
	set {240,
		50, 'flip',
		-depress_space, 'movex0',
		depress_space, 'movex3',
		-depress_space, 'movez1',
		depress_space, 'movez2',
		2.75,'xmod',
		0,'rotationy',
		0,'confusionyoffset',
		0,'bumpyx'
	}

	for i = 240,268 do
		ease
		{i-0.250,0.250,inCubic,100*95/100,'zoomx'}
		{i-0.250,0.250,inCubic,100*100/95,'zoomy'}
		{i+0.000,0.125,outExpo,100*13/12,'zoomx'}
		{i+0.000,0.125,outExpo,100*13/16,'zoomy'}
		{i+0.125,0.375,outCubic,100,'zoomx'}
		{i+0.125,0.375,outCubic,100,'zoomy'}
	end

	add {240,0.333,outExpo,
		50,'zoomx',
		-33,'zoomy'
	}

	add
	{256,0.25,outExpo,-400,'tiny'}
	{256.25,0.75,outCubic,400,'tiny'}
	{256,0.25,linear,240*pi,'confusionoffset'}
	{256.25,0.75,outCubic,-40*pi,'confusionoffset'}

	-- halo
	ease {240,268-240,linear,
		360*4,'rotationy',
		-200*pi*4,'confusionyoffset',
		166,'zoomz'
	}

	ease {240,0.25,outCubic,100,'reverse'}

	{256,12,inSine,
		-depress_space2, 'movex0',
		depress_space2, 'movex3',
		-depress_space2, 'movez1',
		depress_space2, 'movez2',
	}

	for i = 240,270 do
		set {i,0,'dark'}
		ease{i,0.875,linear,95,'dark'}
	end
	set {271,0,'dark'}
	ease{271,0.25,outSine,100,'centered'}
	ease {268,1,outSine,
		0, 'flip',
		0, 'movex0',
		0, 'movex3',
		0, 'movez1',
		0, 'movez2',
		100,'zoomz',
		0,'reverse'
	}

	for i = 269.5,270.75,0.25 do
		set {i,0,'centered2'}
		ease {i,0.25,linear,100,'centered2'}
	end
	ease{270.5,0.5,inCubic,80,'zoomx',120,'zoomy',100,'mini'}
	set {271,0,'centered2',200,'zoomx',400,'zoomy',0,'mini'}
	ease{271,1,outCubic,400,'zoomx',0,'zoomy'}

-- spell the number card
	local function rgb(r, g, b, a)
		return {r / 255, g / 255, b / 255, a or 1}
	end

	-- set up the cards {start,end,name,difficulty,color}
	card{ 16,  32, 'Bother'    , 6, rgb(200, 170,  60)}
	card{ 32,  64, 'Dishearten',11, rgb(200, 100,  40)}
	card{ 64,  96, 'Irritate'  ,10, rgb(200,  40,  40)}
	card{ 96, 128, 'Anger'     ,12, rgb(200,  40, 100)}
	card{128, 160, 'Enrage'    ,13, rgb(200,  40, 140)}
	card{160, 176, 'Infuriate' ,10, rgb(255,  60,  60)} 
	card{176, 208, 'Aggravate' ,12, rgb(255,  60, 140)}
	card{208, 240, 'Exasperate',13, rgb(255,  60, 190)}
	card{240, 272, 'Depress'   , 8, rgb(100,  60, 100)}
	