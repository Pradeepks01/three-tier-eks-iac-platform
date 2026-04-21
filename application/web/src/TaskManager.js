// =============================================================================
// TaskManager — State Management & Business Logic
// =============================================================================
// This class component encapsulates all task CRUD logic. The App component
// extends this class to inherit the handlers and state management, keeping
// the rendering layer separate from the data layer.
// =============================================================================

import { Component } from "react";
import {
  addTask,
  getTasks,
  updateTask,
  deleteTask,
} from "./services/task.service";

class TaskManager extends Component {
  state = { tasks: [], currentTask: "" };

  async componentDidMount() {
    try {
      const { data } = await getTasks();
      this.setState({ tasks: data });
    } catch (error) {
      console.error("[TaskManager] Failed to load tasks:", error.message);
    }
  }

  /** Sync the input field value with component state */
  handleChange = ({ currentTarget: input }) => {
    this.setState({ currentTask: input.value });
  };

  /** Create a new task and append it to the list */
  handleSubmit = async (e) => {
    e.preventDefault();
    const originalTasks = this.state.tasks;
    try {
      const { data } = await addTask({ task: this.state.currentTask });
      const tasks = [...originalTasks, data];
      this.setState({ tasks, currentTask: "" });
    } catch (error) {
      console.error("[TaskManager] Failed to add task:", error.message);
    }
  };

  /** Toggle the completion status of a task (optimistic UI update) */
  handleUpdate = async (taskId) => {
    const originalTasks = this.state.tasks;
    try {
      const tasks = [...originalTasks];
      const index = tasks.findIndex((task) => task._id === taskId);
      tasks[index] = { ...tasks[index], completed: !tasks[index].completed };
      this.setState({ tasks });
      await updateTask(taskId, { completed: tasks[index].completed });
    } catch (error) {
      // Revert to original state if the API call fails
      this.setState({ tasks: originalTasks });
      console.error("[TaskManager] Failed to update task:", error.message);
    }
  };

  /** Remove a task from the list (optimistic UI update) */
  handleDelete = async (taskId) => {
    const originalTasks = this.state.tasks;
    try {
      const tasks = originalTasks.filter((task) => task._id !== taskId);
      this.setState({ tasks });
      await deleteTask(taskId);
    } catch (error) {
      // Revert to original state if the API call fails
      this.setState({ tasks: originalTasks });
      console.error("[TaskManager] Failed to delete task:", error.message);
    }
  };
}

export default TaskManager;
