#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/classes/texture2d.hpp>
#include <godot_cpp/variant/string_name.hpp>
#include <godot_cpp/variant/typed_array.hpp>
#include <godot_cpp/classes/shape2d.hpp>

namespace godot
{
    class Bullet : public Node2D
    {
        GDCLASS(Bullet, Node2D)
        
        private:
            StringName barrel_group;
            bool local_rotation;
            Ref<Texture2D> texture;
            float speed;
            TypedArray<Node2D> barrels;
            Ref<Shape2D> hitbox;
            bool grazable;
            bool collide_areas;
            bool collide_bodies;
            
        protected:
            static void _bind_methods();
        public:
            Bullet();
            ~Bullet();

            void set_texture(const Ref<Texture2D> tex);
            Ref<Texture2D> get_texture() const;

            void set_barrel_group(const StringName group);
            StringName get_barrel_group() const;

            void set_local_rotation(const bool localrot);
            bool get_local_rotation() const;

            void set_speed(const float value);
            float get_speed() const;

            void set_hitbox(const Ref<Shape2D> hitbox);
            Ref<Shape2D> get_hitbox() const;

            void set_grazable(const bool value);
            bool get_grazable() const;
    };
    
}