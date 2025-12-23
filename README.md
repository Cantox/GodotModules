# Godot Modules

A modular, composition-based set of reusable **Godot modules**.

This project follows a **composition-over-inheritance** approach, leveraging Godot’s scene system to build flexible and reusable gameplay behaviors.

---

## ⭐ Features

### 2D Modules
- **Velocity**: Modifies the velocity of a `CharacterBody2D` node. Acceleration and acceleration curves are supported.

- **Movement**: Requires the **Velocity** module. Takes an input (axis or mouse position) and moves a `CharacterBody2D` using the linked velocity module.

### Attribute Modules
- **Health**: Manages a health value with increment/decrement support. Emits a `death` signal when health reaches `0`.

- **Damage**: Requires the **Health** module. Supports dealing and receiving damage, damage modifiers, and critical attacks.

---

## 🧩 Installation

[Download](https://github.com/Cantox/GodotModules/archive/refs/heads/main.zip) the repository and unzip it.

### For each module you want to use:

- Copy the **corresponding module folder** (containing the `.tscn` scene and `.gd` script) into your project folder.

- **Open** the module’s scene (`.tscn` file).

    <details>
    <summary><strong>If dependency errors appear and the script won’t load</strong></summary>

    - Open the scene anyway (without loading the script)
    - Reassociate the script with the module *(drag the `.gd` file onto the module’s node)*
    - Save the scene

    </details>

- **Add** the module’s scene to your scene tree

- **Configure** the module’s exported properties from the **Inspector** tab
---

### Modules with dependencies

Some modules depend on others (e.g. **Movement2D** requires **Velocity2D**).   
In these cases:
- Import **both** the module and its dependencies
- Add dependency modules as **siblings** in the scene tree
- Assign dependencies in the **Inspector** by linking them to the module’s exported fields