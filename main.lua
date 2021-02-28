function love.load()
	
	math.randomseed( os.time() )
	
	love.graphics.setBackgroundColor( 255, 255, 255 )
	
	require( "physics" )
	DebugDraw = require( "debugWorldDraw" )
	
	GAME_WORLD = love.physics.newWorld( 0, 0, true )

	VehicleBody = Physics:NewBody( {
	
		x = 0,
		y = 0,
		Type = "dynamic",
		Width = 18.52,
		Height = 48.69,
		Density = 1,
		Color = { 127, 127, 127 }
			
	} )
	
	local function NewWheel( x, y, Weld )
		
		local __x, __y = VehicleBody.Body:getPosition()
		
		local Wheel = Physics:NewBody( {
				
			x = __x + x,
			y = __y + y,
			Type = "dynamic",
			Width = 3.65,
			Height = 7.0866,
			Density = 1,
			Color = { 32, 32, 32 }

		} )

		Wheel.Traction = 1
		
		if ( Weld ) then
		
			Wheel.Joint = love.physics.newWeldJoint( VehicleBody.Body, Wheel.Body, x, y, false )
			
		else
			
			Wheel.Joint = love.physics.newRevoluteJoint( VehicleBody.Body, Wheel.Body, x, y, false )
			Wheel.Joint:setLimitsEnabled( true )
			Wheel.Joint:setLimits( 0, 0 )
			
		end
		
		function Wheel:ApplySpin( Spin )
			
			local FinalSpin = Spin * self.Traction
			
			self.Body:applyForce( self:GetForward():Multiply( FinalSpin ):Unpack() )
			
		end
		
		function Wheel:TickForce( Time, Rear )

			local LateralVelocity = Wheel:GetLateralVelocity()
			local Multiplier = 1 / ( LateralVelocity:Length() / 200 + 1 )

			local Impulse = LateralVelocity:Multiply( -Wheel.Body:getMass() * Multiplier )

			Wheel.Body:applyLinearImpulse( Impulse:Unpack() )

			local Force = Wheel:GetForwardVelocity():Multiply( -1 / 10 )

			Wheel.Body:applyForce( Force:Unpack() )
			
		end
		
		return Wheel
		
	end
	
	local Vertical = VehicleBody.Width / 2 - 3.65 / 2
	local Horizontal = 16
	
	VehicleWheelFL = NewWheel( -Vertical, Horizontal, false )
	VehicleWheelFR = NewWheel( Vertical, Horizontal, false )
	VehicleWheelRL = NewWheel( -Vertical, -Horizontal, true )
	VehicleWheelRR = NewWheel( Vertical, -Horizontal, true )
	VehicleWheelAngle = 0
	VehicleBraking = false
	
	GameTime = 0
	GameJoystick = love.joystick.getJoysticks()[ 1 ]

end

function love.update( Time )

	if ( GameJoystick ) then

		print( GameJoystick:getAxes() )

	end

	local x1, y1, x2, y2 = GameJoystick:getAxes()

	local Force = 0
	
	if ( love.keyboard.isDown( " " ) ) then
		
		VehicleBraking = true
		
	else
		
		VehicleBraking = false
		
	end
	
	if ( love.keyboard.isDown( "w" ) and not ( VehicleBraking ) ) then
		
		Force = 1
		
	elseif ( love.keyboard.isDown( "s" ) and not ( VehicleBraking ) ) then
		
		Force = -1
		
	end

	Force = -y2
	
	local Limit = 35--math.clamp( 35 - VehicleBody:GetForwardVelocity():Length() / 35, 5, 35 )

	local Speed = 5
	
	if ( GameJoystick ) then

		if ( love.keyboard.isDown( "a" ) ) then
			
			VehicleWheelAngle = VehicleWheelAngle - Limit * Speed * Time
			
		elseif ( love.keyboard.isDown( "d" ) ) then
			
			VehicleWheelAngle = VehicleWheelAngle + Limit * Speed * Time
			
		else
			
			-- VehicleWheelAngle = VehicleWheelAngle + ( 0 - VehicleWheelAngle ) * ( Speed * 2 ) * Time
			
		end

	end

	VehicleWheelAngle = VehicleWheelAngle + ( ( x1 * 35 ) - VehicleWheelAngle ) * ( Speed ) * Time
	
	VehicleWheelAngle = math.clamp( VehicleWheelAngle, -Limit, Limit )
	
	VehicleWheelFL.Joint:setLimits( math.rad( VehicleWheelAngle ), math.rad( VehicleWheelAngle ) )
	VehicleWheelFR.Joint:setLimits( math.rad( VehicleWheelAngle ), math.rad( VehicleWheelAngle ) )
	
	VehicleWheelRL:ApplySpin( Force * 200 )
	VehicleWheelRR:ApplySpin( Force * 200 )
	
	VehicleWheelFL:TickForce( Time, false )
	VehicleWheelFR:TickForce( Time, false )
	VehicleWheelRL:TickForce( Time, true )
	VehicleWheelRR:TickForce( Time, true )
		
	GameTime = GameTime + Time
	
	GAME_WORLD:update( Time )
	
end

function love.draw()
	
	local x, y = VehicleBody.Body:getPosition()
	
	love.graphics.scale( 2 )
	love.graphics.translate( -x + love.window.getWidth() / 4, -y + love.window.getHeight() / 4 )
	
	for x = 0, 50 do
		
		for y = 0, 50 do
			
			love.graphics.setColor( 255 / 50 * x, 255 / 50 * y, 255 - 255 / 50 * ( ( x + y ) / 2 ) )
			love.graphics.circle( "fill", x * love.window.getHeight() / 4, y * love.window.getHeight() / 4, 32 )
			
		end
		
	end
	
	DebugDraw( GAME_WORLD, x - love.window.getWidth() / 2, y - love.window.getHeight() / 2, love.window.getWidth(), love.window.getHeight() )
	
	local x1, y1 = VehicleBody.Body:getLinearVelocity()
	
	love.graphics.setLineWidth( 1 )
	love.graphics.setColor( 0, 0, 0 )
	love.graphics.line( x, y, x + x1 / 3, y + y1 / 3 )
	
end

function math.clamp( a, b, c )
	
	if ( a < b ) then
		
		a = b
		
	elseif ( a > c ) then
		
		a = c
		
	end
	
	return a
	
end