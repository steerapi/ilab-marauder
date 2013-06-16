LUAC = luac

all: .tmp/togglebutton.lua.bin .tmp/snapper.lua.bin .tmp/pin.lua.bin .tmp/main.lua.bin .tmp/button.lua.bin .tmp/InputKeyboard.lua.bin .tmp/Camera.lua.bin .tmp/b64enc.lua.bin .tmp/inspect.lua.bin .tmp/Json.lua.bin .tmp/rest.lua.bin .tmp/de_DE.lua.bin .tmp/en_GB.lua.bin .tmp/ru_RU.lua.bin .tmp/sv_SE.lua.bin .tmp/kinvey.lua.bin .tmp/firebase.lua.bin .tmp/server.lua.bin .tmp/here.lua.bin .tmp/TextWrap.lua.bin .tmp/socket.lua.bin

.tmp/togglebutton.lua.bin: togglebutton.lua
	$(LUAC) -o ".tmp/togglebutton.lua.bin" "togglebutton.lua"

.tmp/snapper.lua.bin: snapper.lua
	$(LUAC) -o ".tmp/snapper.lua.bin" "snapper.lua"

.tmp/pin.lua.bin: pin.lua
	$(LUAC) -o ".tmp/pin.lua.bin" "pin.lua"

.tmp/main.lua.bin: main.lua
	$(LUAC) -o ".tmp/main.lua.bin" "main.lua"

.tmp/button.lua.bin: button.lua
	$(LUAC) -o ".tmp/button.lua.bin" "button.lua"

.tmp/InputKeyboard.lua.bin: InputKeyboard.lua
	$(LUAC) -o ".tmp/InputKeyboard.lua.bin" "InputKeyboard.lua"

.tmp/Camera.lua.bin: Camera.lua
	$(LUAC) -o ".tmp/Camera.lua.bin" "Camera.lua"

.tmp/b64enc.lua.bin: util/b64enc.lua
	$(LUAC) -o ".tmp/b64enc.lua.bin" "util/b64enc.lua"

.tmp/inspect.lua.bin: util/inspect.lua
	$(LUAC) -o ".tmp/inspect.lua.bin" "util/inspect.lua"

.tmp/Json.lua.bin: util/Json.lua
	$(LUAC) -o ".tmp/Json.lua.bin" "util/Json.lua"

.tmp/rest.lua.bin: util/rest.lua
	$(LUAC) -o ".tmp/rest.lua.bin" "util/rest.lua"

.tmp/de_DE.lua.bin: locale/de_DE.lua
	$(LUAC) -o ".tmp/de_DE.lua.bin" "locale/de_DE.lua"

.tmp/en_GB.lua.bin: locale/en_GB.lua
	$(LUAC) -o ".tmp/en_GB.lua.bin" "locale/en_GB.lua"

.tmp/ru_RU.lua.bin: locale/ru_RU.lua
	$(LUAC) -o ".tmp/ru_RU.lua.bin" "locale/ru_RU.lua"

.tmp/sv_SE.lua.bin: locale/sv_SE.lua
	$(LUAC) -o ".tmp/sv_SE.lua.bin" "locale/sv_SE.lua"

.tmp/kinvey.lua.bin: kinvey/kinvey.lua
	$(LUAC) -o ".tmp/kinvey.lua.bin" "kinvey/kinvey.lua"

.tmp/firebase.lua.bin: firebase/firebase.lua
	$(LUAC) -o ".tmp/firebase.lua.bin" "firebase/firebase.lua"

.tmp/server.lua.bin: server/server.lua
	$(LUAC) -o ".tmp/server.lua.bin" "server/server.lua"

.tmp/here.lua.bin: here.lua
	$(LUAC) -o ".tmp/here.lua.bin" "here.lua"

.tmp/TextWrap.lua.bin: TextWrap.lua
	$(LUAC) -o ".tmp/TextWrap.lua.bin" "TextWrap.lua"

.tmp/socket.lua.bin: socket.lua
	$(LUAC) -o ".tmp/socket.lua.bin" "socket.lua"

