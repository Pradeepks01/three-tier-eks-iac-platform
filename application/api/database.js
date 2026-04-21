// =============================================================================
// MongoDB Connection Handler
// =============================================================================
// Establishes a connection to MongoDB using Mongoose. The connection string
// and optional credentials are read from environment variables, making this
// configuration portable across local development and Kubernetes deployments.
//
// Environment Variables:
//   MONGO_CONN_STR   — Full MongoDB connection URI (required)
//   USE_DB_AUTH      — Set to "true" to enable username/password auth
//   MONGO_USERNAME   — MongoDB username  (required when USE_DB_AUTH=true)
//   MONGO_PASSWORD   — MongoDB password  (required when USE_DB_AUTH=true)
// =============================================================================

const mongoose = require("mongoose");

module.exports = async () => {
  try {
    const connectionOptions = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    };

    // Attach credentials only when database authentication is explicitly enabled
    const useAuth = process.env.USE_DB_AUTH === "true";
    if (useAuth) {
      connectionOptions.user = process.env.MONGO_USERNAME;
      connectionOptions.pass = process.env.MONGO_PASSWORD;
      console.log("[DB] Authentication enabled — connecting with credentials.");
    }

    await mongoose.connect(process.env.MONGO_CONN_STR, connectionOptions);
    console.log("[DB] Successfully connected to MongoDB.");
  } catch (error) {
    console.error("[DB] Failed to connect to MongoDB:", error.message);
    // Exit with failure code so the container/pod gets restarted by K8s
    process.exit(1);
  }
};
