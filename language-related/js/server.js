const express = require("express");

const app = express();

const PORT = process.env.PORT || 3000;

// Simulate a database of users
const fakeDatabase = {
  1: { name: "Alice", role: "Admin" },
  2: { name: "Bob", role: "User" },
};

app.get("/users/:id", (req, res) => {
  const userId = req.params.id;
  console.log(`Fetching user with ID: ${userId}`);
  const user = fakeDatabase[userId];

  setTimeout(() => {
    if (user) {
      console.log(`User found: ${JSON.stringify(user)}`);
      res.json(user);
    } else {
      res.status(404).json({ error: "User not found" });
    }
  }, 2000);
});


app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
