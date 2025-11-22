import mongoose from "mongoose";

const connectToDatabase = async () => {
  try {
    mongoose.set("strictQuery", false);
    const connect = await mongoose.connect(process.env.MONGO_URI);
    console.log(`MongoDb Connected: ${connect.connection.host}`);
  } catch (error) {
    console.error(`Error connecting to MongoDB: ${error.message}`);
    console.error("Continuing without DB connection (development fallback).");
    // Do not exit the process in development — allow the server to start.
    // Routes that require DB will still fail until MONGO_URI is fixed.
  }
};

export default connectToDatabase;
