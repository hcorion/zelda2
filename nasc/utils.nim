import sdl2/sdl,
       sdl2/sdl_image as img, 
       sdl2/sdl_ttf as ttf
type
  Image* = ref ImageObj
  ImageObj* = object of RootObj
    texture: sdl.Texture # Image texture
    w, h: int # Image dimensions

proc newImage*(): Image = Image(texture: nil, w: 0, h: 0)

# Render texture to screen
proc render*(obj: Image, renderer: sdl.Renderer, x, y: int): bool =
  var rect = sdl.Rect(x: 0, y: 0, w: x, h: y)
  if renderer.renderCopy(obj.texture, nil, addr(rect)) == 0:
    return true
  else:
    return false


# Render transformed texture to screen
proc renderEx*(obj: Image, renderer: sdl.Renderer, x, y: int,
              w = 0, h = 0, angle = 0.0, centerX = -1, centerY = -1,
              flip = sdl.FlipNone): bool =
  var
    rect = sdl.Rect(x: x, y: y, w: obj.w, h: obj.h)
    centerObj = sdl.Point(x: centerX, y: centerY)
    center: ptr sdl.Point = nil
  if w != 0: rect.w = w
  if h != 0: rect.h = h
  if not (centerX == -1 and centerY == -1): center = addr(centerObj)
  if renderer.renderCopyEx(obj.texture, nil, addr(rect),
                           angle, center, flip) == 0:
    return true
  else:
    return false

# Load image from file
# Return true on success or false, if image can't be loaded
proc load*(obj: Image, renderer: sdl.Renderer, file: string): bool =
  result = true
  # Load image to texture
  obj.texture = renderer.loadTexture(file)
  if obj.texture == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't load image %s: %s",
                    file, img.getError())
    return false
  # Get image dimensions
  var w, h: cint
  if obj.texture.queryTexture(nil, nil, addr(w), addr(h)) != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't get texture attributes: %s",
                    sdl.getError())
    sdl.destroyTexture(obj.texture)
    return false
  obj.w = w
  obj.h = h