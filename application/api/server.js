// =============================================================================
// Three-Tier Application — API Server Entry Point
// =============================================================================
// This is the main Express.js entry point for the backend API layer.
// It connects to MongoDB, configures middleware, and exposes RESTful
// endpoints for task management under the /api/tasks route.
// =============================================================================

const express = require("express");
const cors = require("cors");
const connectToDatabase = require("./database");
const taskRoutes = require("./routes/task.routes");

const app = express();
const PORT = process.env.PORT || 8080;

// ── Establish database connection on startup ──
connectToDatabase();

// ── Middleware ──
app.use(express.json());
app.use(cors());

// ── Health check endpoint (used by Kubernetes liveness/readiness probes) ──
app.get("/ok", (_req, res) => {
  res.status(200).json({ status: "healthy", uptime: process.uptime() });
});

// ── API Routes ──
app.use("/api/tasks", taskRoutes);

// ── Start listening ──
app.listen(PORT, () => {
  console.log(`[API] Server is running on port ${PORT}`);
});
