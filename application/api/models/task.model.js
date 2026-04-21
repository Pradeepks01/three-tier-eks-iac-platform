// =============================================================================
// Task Model — MongoDB / Mongoose Schema
// =============================================================================
// Defines the shape of a "Task" document stored in the tasks collection.
// Each task has a text description and a completion flag.
// Timestamps are enabled so Mongoose automatically manages createdAt/updatedAt.
// =============================================================================

const mongoose = require("mongoose");

const taskSchema = new mongoose.Schema(
  {
    task: {
      type: String,
      required: [true, "Task description is required"],
      trim: true,
    },
    completed: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true, // Adds createdAt and updatedAt fields automatically
  }
);

module.exports = mongoose.model("Task", taskSchema);
