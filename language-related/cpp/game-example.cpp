#include <iostream>
#include <vector>
#include <string>
#include <memory>

using namespace std;

// We define a generic "GameObject" blueprint.
// The `virtual` keyword enables polymorphism, allowing different objects to be treated uniformly.
class GameObject {

  public:
  virtual ~GameObject () {
    cout<<name<<" destroyed "<<endl;
  }

  virtual void update() = 0; // pure virtual function, any subclass MUST implement this.

  void setName(string& new_name) {
    name = new_name;
  }  

  protected:
  string name;

};

// Player subclass
class Player: public GameObject {
  public:
  Player(const string& playerName) {
    name = playerName;
    cout<<"Player "<<name<<" has entered the game"<<endl;
  }
  /*
  All the attributes that a player may have and all the actions a player may make, which may include a change in the current game frame or the upcoming frames, all activity including the assocaition of the player object with the rest of the objects in a game frame may go here
  */

  void update() override {
    // Player specific logic will go here
    cout<<"Updating player "<<name<<endl;
  }


};

// Enemy subclass
class Enemy: public GameObject {
  public:
  Enemy(const string& enemyName, int damage) {
    this->damage = damage;
    name = enemyName;
    cout<<enemyName<<" (enemy) has spawned"<<endl;
  }

  /*
  Same as for the player object, all the data attributes and member functions of the enemy including its interaction with some other object in a game frame, may go here.
  */

  void update() override {
    cout<<"Updating enemy "<<name<<" planning to do "<<damage<<endl;
  }

  private:
  int damage;
};


int main() {

  // A vector to hold all objects in our "scene".
  // We use std::unique_ptr for automatic memory management (RAII).
  // When the unique_ptr goes out of scope, the memory is automatically freed. No manual `delete`!
  vector<unique_ptr<GameObject>> scene;

  scene.push_back(make_unique<Player>("Aatir"));
  scene.push_back(make_unique<Enemy>("Goblin", 10));
  scene.push_back(make_unique<Enemy>("Orc", 30));


  cout << "\n--- Game Loop Begins ---" << endl;

  for(const auto& obj: scene) {
    obj->update();
  }

  cout << "\n--- Game Loop Ends ---" << endl;

  // The 'scene' vector is about to be destroyed.
  // The std::unique_ptr in the vector will automatically call 'delete'
  // on each GameObject, cleaning up all memory.
  // Notice the "destroyed" messages print automatically.


  return 0;
}