// =============================================================================
// Task Routes — RESTful CRUD Endpoints
// =============================================================================
// Provides Create, Read, Update, and Delete operations for tasks.
// All routes are mounted under /api/tasks by the server entry point.
//
//   POST   /api/tasks       → Create a new task
//   GET    /api/tasks       → Retrieve all tasks
//   PUT    /api/tasks/:id   → Update a task by ID (e.g. toggle completion)
//   DELETE /api/tasks/:id   → Delete a task by ID
// =============================================================================

const express = require("express");
const router = express.Router();
const Task = require("../models/task.model");

// ── CREATE — Add a new task ──
router.post("/", async (req, res) => {
  try {
    const task = await new Task(req.body).save();
    res.status(201).json(task);
  } catch (error) {
    console.error("[API] Error creating task:", error.message);
    res.status(500).json({ error: "Failed to create task" });
  }
});

// ── READ — List all tasks ──
router.get("/", async (_req, res) => {
  try {
    const tasks = await Task.find().sort({ createdAt: -1 });
    res.status(200).json(tasks);
  } catch (error) {
    console.error("[API] Error fetching tasks:", error.message);
    res.status(500).json({ error: "Failed to retrieve tasks" });
  }
});

// ── UPDATE — Modify an existing task by ID ──
router.put("/:id", async (req, res) => {
  try {
    const task = await Task.findByIdAndUpdate(req.params.id, req.body, {
      new: true, // Return the updated document instead of the original
    });
    if (!task) {
      return res.status(404).json({ error: "Task not found" });
    }
    res.status(200).json(task);
  } catch (error) {
    console.error("[API] Error updating task:", error.message);
    res.status(500).json({ error: "Failed to update task" });
  }
});

// ── DELETE — Remove a task by ID ──
router.delete("/:id", async (req, res) => {
  try {
    const task = await Task.findByIdAndDelete(req.params.id);
    if (!task) {
      return res.status(404).json({ error: "Task not found" });
    }
    res.status(200).json({ message: "Task deleted", task });
  } catch (error) {
    console.error("[API] Error deleting task:", error.message);
    res.status(500).json({ error: "Failed to delete task" });
  }
});

module.exports = router;
