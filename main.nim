# https://datacrystal.romhacking.net/wiki/Zelda_II:_The_Adventure_of_Link:Character_Data
# https://datacrystal.romhacking.net/wiki/Zelda_II:_The_Adventure_of_Link:ROM_map
import strutils
import romloader

proc main() =
    var rom: ZeldaIIRom
    rom.init("./Zelda 2 - The Adventure of Link (U).nes")

    var walkingSprite = rom.getSprite(linkWalkingSprite1)
    var newSprite: array[256, char]
    var derp = 0
    while derp < walkingSprite.len:
        for i in 0..7:
            var mask = 0b10000000
            for b in 0..7:
                var x = mask and (int)walkingSprite[derp + i]
                var y = mask and (int)walkingSprite[derp + i+8]
                y = y shr (7 - b)
                x = x shr (7 - b)
                mask = mask shr 1
                y = y shl 1
                newSprite[(derp*4)+(i*8)+b] = (char)(x or y)
                #echo (derp*4)+(i*8)+b
        derp += 16
    derp = 0
    var dd = 0
    var str = ""
    while derp < newSprite.len:
        
        var x = (int)newSprite[derp]
        case x:
            of 1:
                str &= "██"
            of 2:
                str &= "▒▒"
            of 3:
                str &= "░░"
            else:
                str &= "  "
        derp += 1
        if dd >= 7:
            dd = -1
            echo str
            str = ""
        dd += 1
        #[for x in 0..7:
            var str = ""
            for y in 0..7:
                if newSprite[derp + (x*8) + y] == (char)1:
                    str &= "██"
                elif newSprite[derp + (x*8)+y] == (char)2:
                    str &= "▒▒"
                elif newSprite[ derp + (x*8)+y] == (char)3:
                    str &= "░░"
                else:
                    str &= "  "
                    #str &= (int)newSprite[(x+1)*y]
            echo str
        ]#
        
    #[var walkingSprite1 = rom.getSprite(linkWalkingSprite1)
    echo "walkingSprite1"
    for i in walkingSprite1:
        echo toHex(i) & " = " & toBin((BiggestInt)i, 8)

    var walkingSprite2 = rom.getSprite(linkWalkingSprite2)
    echo "walkingSprite2"
    for i in walkingSprite2:
        echo toHex(i) & " = " & toBin((BiggestInt)i, 8)

    var walkingSprite3 = rom.getSprite(linkWalkingSprite3)
    echo "walkingSprite3"
    for i in walkingSprite3:
        echo toHex(i) & " = " & toBin((BiggestInt)i, 8)]#

when isMainModule:
    main()