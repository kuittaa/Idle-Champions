#include %A_LineFile%\..\json.ahk
#include %A_LineFile%\..\SH_SharedFunctions.ahk
; Build a map of key inputs used by the script
; KeyMap keys contains all basic keys built (e.g. "a", "b") as well as dictionaries of those keys (e.g. "{a}", "{b}")
; GetKeyVK() built in function to get the virtual key. Value is formatted to hex for use in SendMessage calls
class KeyHelper
{
    ; Updates virtual and scancode keymaps.
    BuildVirtualKeysMap(ByRef vKeys, ByRef scKeys)
    {
        sharedFunctions := new SH_SharedFunctions
        fileName := A_LineFile . "/../ScanCodes.json"
        scancodes := sharedFunctions.LoadObjectFromJSON(fileName)
        
        for key,sc in scancodes
        {
            index := "{" . key . "}"
            formattedSC := Format("sc{:X}", sc)     ; Reformat for use in GetKeyVK (sc + hex. e.g. scC0)
            vk := GetKeyVK(formattedSC)             ; Get virtual key value (dec)
            formattedVK := Format("0x{:X}", vk)     ; convert virtual key to hex code 
            vKeys[index] := formattedVK
            vKeys[v] := formattedVK
            scKeys[index] := sc
            scKeys[v] := sc
        }
    }

    WriteScanCodesToJSON()
    {
        sharedFunctions := new SH_SharedFunctions
        output := {}
        fileName := A_LineFile . "/../ScanCodes.json"
        alphabet := ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        extraKeys := ["Left","Right","Esc","Shift","Alt","Ctrl","``","RCtrl","LCtrl"]
        fKeys := ["F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"]
        numKeys := ["0","1","2","3","4","5","6","7","8","9"]
        allKeys := {}
        allKeys.Push(alphabet*)
        allKeys.Push(extraKeys*)
        allKeys.Push(fKeys*)
        allKeys.Push(numKeys*)

        for k,v in allKeys
        {
            output[v] := Format("0x{:X}", GetKeySC(v)) . ""
        }
        output["ClickDmg"] := 0x29

        sharedFunctions.WriteObjectToJSON( fileName, output )
        return
    }         
}