// =============================================================================
// Task Service — HTTP Client for the Backend API
// =============================================================================
// Provides functions that map to each CRUD operation on the /api/tasks endpoint.
// The backend URL is injected via the REACT_APP_BACKEND_URL environment variable,
// which is set at build-time or through the Kubernetes deployment manifest.
// =============================================================================

import axios from "axios";

const API_BASE_URL = process.env.REACT_APP_BACKEND_URL;

if (!API_BASE_URL) {
  console.warn(
    "[TaskService] REACT_APP_BACKEND_URL is not set — API calls will fail."
  );
}

/** Fetch all tasks from the API */
export function getTasks() {
  return axios.get(API_BASE_URL);
}

/** Create a new task */
export function addTask(task) {
  return axios.post(API_BASE_URL, task);
}

/** Update an existing task by ID */
export function updateTask(id, task) {
  return axios.put(`${API_BASE_URL}/${id}`, task);
}

/** Delete a task by ID */
export function deleteTask(id) {
  return axios.delete(`${API_BASE_URL}/${id}`);
}
