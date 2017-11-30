import sdl2/sdl,
       sdl2/sdl_image as img, 
       sdl2/sdl_ttf as ttf
import utils
type
  NascEngine* = object
    window*: sdl.Window # Window pointer
    renderer*: sdl.Renderer # Rendering state pointer
    image*: Image

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
    discard nasc.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0xFF)
    if nasc.renderer.renderClear() != 0:
      sdl.logWarn(sdl.LogCategoryVideo,
                  "Can't clear screen: %s",
                  sdl.getError())
    discard render(nasc.image, nasc.renderer, ScreenW, ScreenH)
    nasc.renderer.renderPresent()

proc init*(nasc: var NascEngine): bool =
  # Initialization
  if sdl.init(sdl.InitVideo or sdl.InitTimer) != 0:
      sdl.logCritical(sdl.LogCategoryError, "Can't initialize SDL: %s", sdl.getError())
  if img.init(img.InitPng) == 0:
    sdl.logCritical(sdl.LogCategoryError, "Can't initialize SDL_Image: %s", img.getError())
  if ttf.init() != 0:
    sdl.logCritical(sdl.LogCategoryError, "Can't initialize SDL_TTF: %s", ttf.getError())
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
    return false
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
  #SDL_SetHint (SDL_HINT_RENDER_SCALE_QUALITY, Value);
  discard sdl.setHint("SDL_HINT_RENDER_SCALE_QUALITY", "0")
  nasc.image = newImage()
  discard load(nasc.image, nasc.renderer, "nasc/NESscreen.png")
  if nasc.image == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't load image NESscreen.png: %s",
                    img.getError())
  return true