#include <register_types.h>
#include <gdextension_interface.h>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

#include <bullet.hpp>
#include <seeker.hpp>
#include <item_manager.hpp>
#include <bullet_player.hpp>
#include <spinner.hpp>
#include <barrel_rotator_random.hpp>
#include <global_score.hpp>
#include <accelerator_sine.hpp>
#include <accelerator.hpp>
#include <accelerator_smooth.hpp>
#include <ricochetor.hpp>

using namespace godot;

void initialize_gdextension_types(ModuleInitializationLevel p_level)
{
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}
	GDREGISTER_CLASS(Bullet);
	GDREGISTER_CLASS(Spinner);
	GDREGISTER_CLASS(ItemManager);
	GDREGISTER_CLASS(BulletPlayer);
	GDREGISTER_CLASS(Seeker);
	GDREGISTER_CLASS(BarrelRotatorRandom);
	GDREGISTER_CLASS(GlobalScore);
	GDREGISTER_CLASS(AcceleratorSine);
	GDREGISTER_CLASS(Accelerator);
	GDREGISTER_CLASS(AcceleratorSmooth);
	GDREGISTER_CLASS(Ricochetor);
}

void uninitialize_gdextension_types(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}
}

extern "C"
{
	// Initialization
	GDExtensionBool GDE_EXPORT bullet_library_init(GDExtensionInterfaceGetProcAddress p_get_proc_address, GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization)
	{
		GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);
		init_obj.register_initializer(initialize_gdextension_types);
		init_obj.register_terminator(uninitialize_gdextension_types);
		init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

		return init_obj.init();
	}
}