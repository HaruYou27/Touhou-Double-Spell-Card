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
            Texture2D texture;
            float speed;
            TypedArray<Node2D> barrels;
            Shape2D hitbox;
        protected:
            
        public:
            Bullet();
            ~Bullet();

            void set_texture(const Texture2D tex);
            Texture2D get_texture() const;

            void set_barrel_group(const StringName group);
            StringName get_barrel_group() const;

            void set_local_rotation(const bool localrot);
            bool get_local_rotation() const;

            void set_speed(const float value);
            float get_speed() const;

            void set_hitbox(const Shape2D hitbox);
    };
    
}