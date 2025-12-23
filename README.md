# Godot Modules

A modular, composition-based set of reusable **Godot modules**.

This project follows a **composition-over-inheritance** approach, leveraging Godot’s scene system to build flexible and reusable gameplay behaviors.

---

## ⭐ Features

### 2D Modules
- **Velocity**: modifies velocity of a CharacterBody2d node, accelleration and accelleration curve are implemented.
- **Movement**: requires velocity module. Takes an input (axis or position) and uses a velocity module to move a CharacterBody2d node based on that input.

### Attributes Modules
- **Health**: manages an health value. Allows decrementation and incrementation of the value and a death signal is emitted when it reaches 0.
- **Damage**: requires health module. Allows dealing and taking damage. The base damage can be modified by passing modifiers to the methods. A critical attack is also implemented.

---

## 🧩 Installation

[Download](https://github.com/Cantox/GodotModules/archive/refs/heads/main.zip) and unzip the repo. For each needed module copy the corresponding folder (containing module scene (file .tscn) and module script (file .gd)) to your project's folder.

#### Dependent modules:
Some modules require other modules to work (ex. the Movement2D module requires the Velocity2D module). In those cases, after importing the module that you need, you will also have to import the required modules (which i'll call dependencies). Add the dependencies to the scene tree as siblings of the module. Finally, in the inspector tab, associate the dependencies to the corresponding attributes of the module.
