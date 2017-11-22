import memfiles

type
    memoryLocations* = enum
        
        linkWalkingSprite2  = 0x01EB3B,
        linkWalkingSprite3  = 0x01EB41,
        linkDuckingSprite   = 0x01EB47,
        linkStandingSprite  = 0x01EB4D,
        linkPreStabSprite   = 0x01EB53,
        linkStabSprite      = 0x01EB59, 
        linkDuckStabSprite  = 0x01EB65,
        linkUpStabSprite    = 0x01EB6B,
        linkWalkingSprite1  = 0x020010,


type
    ZeldaIIRom* = object
        memFile*: MemFile
        address*: pointer

proc init*(rom: var ZeldaIIRom, path: string) =
    rom.memFile = memFiles.open(path, mode = fmRead, allowRemap = true)
    rom.address = rom.memFile.mapMem(mappedSize = rom.memFile.size)

proc getSprite*(rom: var ZeldaIIRom, sprite: memoryLocations): array[64, char] = 
    #echo rom.memFile.size
    
    
    # LOL, so much for memory safety
    rom.address = cast[pointer](cast[uint](rom.address) + cast[uint](sprite))
    return cast[ptr array[result.len, char]](rom.address)[]