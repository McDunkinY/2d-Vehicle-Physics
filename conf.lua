function love.conf( T )

	T.identity = nil                   -- The name of the save directory (string)
	T.version = "0.9.0"                -- The LÖVE version this game was made for (string)
	T.console = true                  -- Attach a console (boolean, Windows only)

	T.window.title = "Drift Physics"        -- The window title (string)
	T.window.icon = nil                -- Filepath to an image to use as the window's icon (string)
	T.window.width = 1280             -- The window width (number)
	T.window.height = 720             -- The window height (number)
	T.window.borderless = false        -- Remove all border visuals from the window (boolean)
	T.window.resizable = false         -- Let the window be user-resizable (boolean)
	T.window.minwidth = 0              -- Minimum window width if the window is resizable (number)
	T.window.minheight = 0             -- Minimum window height if the window is resizable (number)
	T.window.fullscreen = false        -- Enable fullscreen (boolean)
	T.window.fullscreentype = "desktop" -- Standard fullscreen or desktop fullscreen mode (string)
	T.window.vsync = true              -- Enable vertical sync (boolean)
	T.window.fsaa = 8                  -- The number of samples to use with multi-sampled antialiasing (number)
	T.window.display = 1               -- Index of the monitor to show the window in (number)

	T.modules.audio = true             -- Enable the audio module (boolean)
	T.modules.event = true             -- Enable the event module (boolean)
	T.modules.graphics = true          -- Enable the graphics module (boolean)
	T.modules.image = true             -- Enable the image module (boolean)
	T.modules.joystick = true          -- Enable the joystick module (boolean)
	T.modules.keyboard = true          -- Enable the keyboard module (boolean)
	T.modules.math = true              -- Enable the math module (boolean)
	T.modules.mouse = true             -- Enable the mouse module (boolean)
	T.modules.physics = true           -- Enable the physics module (boolean)
	T.modules.sound = true             -- Enable the sound module (boolean)
	T.modules.system = true            -- Enable the system module (boolean)
	T.modules.timer = true             -- Enable the timer module (boolean)
	T.modules.window = true            -- Enable the window module (boolean)

end