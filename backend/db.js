import mongoose from 'mongoose';

const connectToDatabase = async () => {
  try {
    mongoose.set('strictQuery', false);
    const connect = await mongoose.connect(process.env.MONGO_URI);
    console.log(`MongoDb Connected: ${connect.connection.host}`);
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1); // Exit app if DB connection fails
  }
};

export default connectToDatabase;
