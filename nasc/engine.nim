import sdl2/sdl

type
  NascEngine* = object
    window*: sdl.Window # Window pointer
    renderer*: sdl.Renderer # Rendering state pointer
const
  Title = "Zelda II Rewrite"
  ScreenW = 640 # Window width
  ScreenH = 480 # Window height
  WindowFlags = 0
  RendererFlags = sdl.RendererAccelerated or sdl.RendererPresentVsync

proc events(pressed: var seq[sdl.Keycode]): bool =
  result = false
  var e: sdl.Event
  if pressed != nil:
    pressed = @[]

  while sdl.pollEvent(addr(e)) != 0:

    # Quit requested
    if e.kind == sdl.Quit:
      return true

proc loop*(nasc: var NascEngine) =
  var
    done = false
    pressed: seq[sdl.Keycode] = @[] # Pressed keys
  while not done:
    done = events(pressed)
    

proc init*(nasc: var NascEngine): bool =
  # Initialization
  if sdl.init(sdl.InitVideo or sdl.InitTimer) != 0:
      sdl.logCritical(sdl.LogCategoryError, "Can't initialize SDL: %s", sdl.getError())
  nasc.window = sdl.createWindow(
    Title,
    sdl.WindowPosUndefined,
    sdl.WindowPosUndefined,
    ScreenW,
    ScreenH,
    WindowFlags)
  if nasc.window == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't create window: %s",
                    sdl.getError())
  # Create renderer
  nasc.renderer = sdl.createRenderer(nasc.window, -1, RendererFlags)
  if nasc.renderer == nil:
    sdl.logCritical(sdl.LogCategoryError, "Can't create renderer: %s", sdl.getError())
    return false

  # Set draw color
  if nasc.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0xFF) != 0:
    sdl.logWarn(sdl.LogCategoryVideo, "Can't set draw color: %s", sdl.getError())
    return false

  sdl.logInfo(sdl.LogCategoryApplication, "SDL initialized successfully")
  return true