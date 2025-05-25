# WarGame – Squeak OOP Project

This is a university project developed in [Squeak Smalltalk](https://squeak.org/), demonstrating object-oriented programming concepts through a simple war game simulation.

## 🎯 Project Overview

WarGame is a turn-based strategy game where players command units on a battlefield. The game showcases OOP principles such as encapsulation, inheritance, and polymorphism.

## 🧰 Technologies Used

- Squeak Smalltalk
- Morphic UI Framework

## 🚀 Getting Started

1. **Install Squeak**: Download and install Squeak from [squeak.org](https://squeak.org/downloads/).
2. **Load the Project**:
   - Open Squeak.
   - Use the File Browser to load `CardWarGame.st`.
3. **Add Resources**:
   - Place the images from the `photos` folder into the `Resources` directory within your Squeak environment.
4. **Run the Game**:
   - In a Workspace, execute:
     ```smalltalk
     WarGame new play.
     ```

## 🖼️ Screenshots

![Game Start](photos/screenshot1.png)
![Gameplay](photos/screenshot2.png)

## 🧠 Object-Oriented Concepts Demonstrated

- **Encapsulation**: Each game entity manages its own state and behavior.
- **Inheritance**: Shared behaviors are abstracted into superclass structures.
- **Polymorphism**: Game units respond differently to the same messages based on their class.
