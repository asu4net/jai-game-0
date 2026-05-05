#load "core/app_state.jai";
#load "core/time.jai";
#load "core/math.jai";
#load "core/keycode.jai";
#load "core/backend/sdl/window.jai";
#load "core/backend/sdl/input.jai";
#load "core/input_action.jai";

#import, file "core/queue.jai";
#import, file "core/sparse_set.jai";
#import, file "core/enum_array.jai";

#if IMGUI then {
     #load "core/imgui.jai";
     #load "core/imgui_interface.jai";
}