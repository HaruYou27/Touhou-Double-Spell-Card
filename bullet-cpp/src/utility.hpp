#ifndef UTILITY_HPP
#define UTILITY_HPP

#include <godot_cpp/classes/engine.hpp>

#define SET_GET(var, type) void set_##var(const type value); type get_##var() const;
#define BIND_SETGET(var, class) ClassDB::bind_method(D_METHOD("set_"#var, #var), &class::set_##var); ClassDB::bind_method(D_METHOD("get_"#var), &class::get_##var);
#define GETTER(var, type, class) type class::get_##var() const {return var;}
#define SETTER_GETTER(var, type, class) void class::set_##var(const type value) {var = value;} GETTER(var, type, class)

#define ADD_PROPERTY_BOOL(var)         ADD_PROPERTY(PropertyInfo(Variant::BOOL, #var), "set_" #var, "get_" #var);
#define ADD_PROPERTY_FLOAT(var)        ADD_PROPERTY(PropertyInfo(Variant::FLOAT, #var), "set_" #var, "get_" #var);
#define ADD_PROPERTY_INT(var)          ADD_PROPERTY(PropertyInfo(Variant::INT, #var), "set_" #var, "get_" #var);
#define ADD_PROPERTY_NODEPATH(var)     ADD_PROPERTY(PropertyInfo(Variant::NODE_PATH, #var), "set_" #var, "get_" #var);
#define ADD_PROPERTY_OBJECT(var, type) ADD_PROPERTY(PropertyInfo(Variant::OBJECT, #var, PROPERTY_HINT_RESOURCE_TYPE, #type), "set_" #var, "get_" #var);
#define ADD_PROPERTY_COLLISION(var)    ADD_PROPERTY(PropertyInfo(Variant::INT, #var, PROPERTY_HINT_LAYERS_2D_PHYSICS), "set_" #var, "get_" #var);

#define FILL_ARRAY_HOLE(array) array[index] = array[count_bullet];
#define CHECK_CAPACITY if (count_bullet == max_bullet) {return;}
#define CHECK_MULTIPLAYER_AUTHORITY if (!is_multiplayer_authority()) {return;}
#define BIND_FUNCTION(func, class) ClassDB::bind_method(D_METHOD(#func), &class::func);
#define CHECK_EDITOR if (Engine::get_singleton()->is_editor_hint()) {set_physics_process(false); set_process(false); set_process_input(false); set_process_unhandled_input(false); set_process_unhandled_key_input(false); set_process_shortcut_input(false); return;}

#define RPC_CONFIG(config, mode, transfer) config["mode"] = #mode; config["transfer_mode"] = #transfer; config["sync"] = "call_remote";

using namespace godot;

#endif