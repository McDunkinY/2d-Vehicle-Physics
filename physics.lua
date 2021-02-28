Physics = {

	Bodies = { }

}

function Physics:Vector( x, y )

	local Object = {

		x = x or 0,
		y = y or 0

	}

	function Object:Add( v )

		if ( type( v ) == "table" ) then

			return Physics:Vector( self.x + v.x, self.y + v.y )

		else

			return Physics:Vector( self.x + v, self.y + v )

		end

	end

	function Object:Multiply( v )

		if ( type( v ) == "table" ) then

			return Physics:Vector( self.x * v.x, self.y * v.y )

		else

			return Physics:Vector( self.x * v, self.y * v )

		end

	end

	function Object:Divide( v )

		if ( type( v ) == "table" ) then

			return Physics:Vector( self.x / v.x, self.y / v.y )

		else

			return Physics:Vector( self.x / v, self.y / v )

		end

	end

	function Object:Dot( v )

		return self.x * v.x + self.y * v.y

	end

	function Object:Length()

		return math.sqrt( self.x ^ 2 + self.y ^ 2 )

	end

	function Object:Normalize()

		return self:Divide( self:Length() )

	end

	function Object:Unpack()

		return self.x, self.y

	end

	return Object

end

function Physics:NewBody( Data )

	local PhysicsBody = {

		Body = love.physics.newBody( GAME_WORLD, Data.x, Data.y, Data.Type ),
		Shape = love.physics.newRectangleShape( Data.Width, Data.Height ),
		Width = Data.Width,
		Height = Data.Height

	}

	PhysicsBody.Fixture = love.physics.newFixture( PhysicsBody.Body, PhysicsBody.Shape, Data.Density )
	PhysicsBody.Color = Data.Color

	function PhysicsBody:Draw()

		local LineColor = { 234, 180, 180 }
		local BodyColor = { 139, 115, 115 }

		love.graphics.setColor( LineColor )
		love.graphics.polygon( "line", self.Body:getWorldPoints( self.Shape:getPoints() ) )

		love.graphics.setColor( BodyColor )
		love.graphics.polygon( "fill", self.Body:getWorldPoints( self.Shape:getPoints() ) )

	end

	function PhysicsBody:GetForward()

		return Physics:Vector( self.Body:getWorldVector( 0, 1 ) )

	end

	function PhysicsBody:GetForwardVelocity()

		local Normal = self:GetForward()

		return Normal:Multiply( Normal:Dot( Physics:Vector( self.Body:getLinearVelocity() ) ) )

	end

	function PhysicsBody:GetLateral()

		return Physics:Vector( self.Body:getWorldVector( 1, 0 ) )

	end

	function PhysicsBody:GetLateralVelocity()

		local Normal = self:GetLateral()

		return Normal:Multiply( Normal:Dot( Physics:Vector( self.Body:getLinearVelocity() ) ) )

	end

	table.insert( self.Bodies, PhysicsBody )

	return PhysicsBody

end

function Physics:NewAerodynamicBody( Data )

	local PhysicsBody = self:NewBody( Data )

	return PhysicsBody

end
