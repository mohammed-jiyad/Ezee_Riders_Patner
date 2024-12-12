const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const { MongoClient, ObjectId } = require('mongodb');
const Grid = require('gridfs-stream');
const multer = require('multer'); // Add multer for handling file uploads

const app = express();

app.use(cors());
app.use(express.json());


const MONGO_URL = "mongodb+srv://jiyad:jiyad123@cluster0.y8hwo.mongodb.net/test?retryWrites=true&w=majority&appName=Cluster0";
const COLLECTION_NAME = "Users";
const FILE_COLLECTION_NAME = "Files";

let db;
let gfs;

// Set up multer for in-memory file storage
const storage = multer.memoryStorage(); // Store files in memory (buffer)
const upload = multer({ storage: storage }); // Multer middleware for handling file uploads


async function connect() {
  const client = new MongoClient(MONGO_URL);
  await client.connect();
  db = client.db();
  gfs = Grid(db, MongoClient);
  gfs.collection('user_files'); // Set GridFS collection
  const status = await db.admin().serverStatus();
  console.log("MongoDB Connection Successful:", status.ok ? "OK" : "Not OK");
}


async function insertUser(userData) {
  const collection = db.collection(COLLECTION_NAME);
  userData._id = userData.phonenumber;

  try {
    const result = await collection.insertOne(userData);
    if (result.acknowledged) {
      console.log(`User inserted with _id: ${userData._id}`);
    } else {
      console.log("Failed to insert user.");
    }
  } catch (e) {
    console.log("Error inserting user:", e);
  }
}

async function updateFormStatus(phoneNumber, formType, status) {
  const collection = db.collection(COLLECTION_NAME);
  const update = {};
  update[formType + 'Status'] = status; // Dynamically update form status

  try {
    await collection.updateOne({ phonenumber: phoneNumber }, { $set: update });
    console.log(`${formType} status updated to ${status}`);
  } catch (e) {
    console.log('Error updating form status:', e);
  }
}


async function addFieldToUser(phonenumber, userData) {
  const collection = db.collection(COLLECTION_NAME);
  try {
    await collection.updateOne(
      { phonenumber: phonenumber },
      { $set: userData }
    );
    console.log('User Updated');
  } catch (e) {
    console.log('Error updating user:', e);
  }
}


async function findUser(phonenumber) {
  const collection = db.collection(COLLECTION_NAME);
  const user = await collection.findOne({ phonenumber: phonenumber });
  return user !== null; // Returns true if user exists, otherwise false
}


async function uploadFileForUser(phoneNumber, fileData, fileName, uploadTitle) {
  try {
    // Create the file object with the specified title
    const file = {
      phoneNumber: phoneNumber,
      files: {
        [uploadTitle]: {
          fileName: fileName,
          fileData: fileData, // Store the file as a buffer
          uploadDate: new Date(),
        }
      }
    };

    // Insert file into the files collection
    const collection = db.collection(FILE_COLLECTION_NAME);
    const result = await collection.insertOne(file);

    if (result.acknowledged) {
      console.log("File uploaded with ObjectId:", result.insertedId);
    } else {
      console.error("Failed to insert file.");
    }

    
    const userCollection = db.collection(COLLECTION_NAME);
    const updateResult = await userCollection.updateOne(
      { phonenumber: phoneNumber }, // Find the user by phone number
      {
        $push: {
          files: {
          [uploadTitle]:{
            fileId: result.insertedId,  // MongoDB file ID
            fileName: fileName,
            uploadDate: new Date().toISOString(),
            },
          },
        },
      }
    );

    if (updateResult.modifiedCount > 0) {
      console.log("File linked to user with phone number:", phoneNumber);
    } else {
      console.log("No user found or no changes made while linking file.");
    }

  } catch (e) {
    console.log("Error uploading file or linking to user:", e);
  }
}


async function downloadFileFromGridFS(fileId) {
  try {
    const file = await gfs.files.findOne({ _id: new ObjectId(fileId) });  // Correct ObjectId usage
    if (!file) {
      console.log("File not found.");
      return null;
    }
    console.log("File found:", file.filename);

    const readstream = gfs.createReadStream({ _id: fileId });

    let fileData = [];
    readstream.on('data', (chunk) => {
      fileData.push(chunk);
    });
    readstream.on('end', () => {
      const buffer = Buffer.concat(fileData);
      console.log("File downloaded");
      return buffer;
    });
  } catch (e) {
    console.log("Error downloading file from GridFS:", e);
    return null;
  }
}

async function getBooleanValuesByPhoneNumber(phoneNumber) {
  const collection = db.collection(COLLECTION_NAME);
  try {
    const user = await collection.findOne(
      { phonenumber: phoneNumber }, // Query the database by phone number
      {
        projection: {
          profilesubmit: 1,
          profilevalidate: 1,
          profilerejected :1,
          DLsubmit: 1,
          DLvalidate: 1,
          DLrejected :1,
          RCsubmit: 1,
          RCvalidate: 1,
          RCrejected :1,
          Vehiclesubmit: 1,
          Vehiclevalidate: 1,
          Vehiclerejected :1,
          Identitysubmit: 1,
          Identityvalidate: 1,
          Identityrejected :1,
          bankaccsubmit: 1,
          bankaccvalidate: 1,
          bankaccrejected :1,
        },
      }
    );

    if (user) {
      console.log("User data found:", user);
      return user; // Return the user data with the required Boolean fields
    } else {
      console.log("No user found with this phone number.");
      return null;
    }
  } catch (error) {
    console.error("Error fetching user data:", error);
    throw new Error("Error fetching user data");
  }
}


async function deleteFileFromGridFS(phoneNumber, fileId) {
  try {
    const fileObjectId = new ObjectId(fileId);  // Correct ObjectId usage

    await gfs.files.deleteOne({ _id: fileObjectId });
    await gfs.chunks.deleteMany({ files_id: fileObjectId });
    console.log("File deleted from GridFS with ID:", fileId);

    const collection = db.collection(COLLECTION_NAME);
    await collection.updateOne(
      { phonenumber: phoneNumber },
      {
        $pull: {
          files: { fileId: fileObjectId },
        },
      }
    );
    console.log("File unlinked from user with phone number:", phoneNumber);
  } catch (e) {
    console.log("Error deleting file from GridFS:", e);
  }
}


app.post('/insertUser', async (req, res) => {
  const userData = req.body;
  try {
    await insertUser(userData);
    res.status(200).json({ message: "User inserted" });
  } catch (e) {
    res.status(500).json({ message: "Error inserting user", error: e.message });
  }
});
app.post('/updateFormStatus', async (req, res) => {
  const { phoneNumber, formType, status } = req.body;
  try {
    await updateFormStatus(phoneNumber, formType, status);
    res.status(200).json({ message: `${formType} status updated successfully` });
  } catch (e) {
    res.status(500).json({ message: "Error updating form status", error: e.message });
  }
});

app.post('/addFieldToUser', async (req, res) => {
  const { phonenumber, userData } = req.body;
  try {
    await addFieldToUser(phonenumber, userData);
    res.status(200).json({ message: "User updated" });
  } catch (e) {
    res.status(500).json({ message: "Error updating user", error: e.message });
  }
});

app.get('/findUser/:phonenumber', async (req, res) => {
  const { phonenumber } = req.params;
  try {
    const userExists = await findUser(phonenumber);
    res.status(200).json({ exists: userExists });
  } catch (e) {
    res.status(500).json({ message: "Error finding user", error: e.message });
  }
});


app.post('/uploadFileForUser', upload.single('file'), async (req, res) => {
  try {
    // Log the incoming file and phoneNumber
    console.log("Received file:", req.file); // Logging file
    console.log("Received phoneNumber:", req.body.phoneNumber); 
    console.log("Received uploadTitle:", req.body.uploadTitle); 

    const phoneNumber = req.body.phoneNumber; 
    const fileData = req.file.buffer;
    const fileName = req.file.originalname;
    const uploadTitle = req.body.uploadTitle; 

    if (!phoneNumber || !fileData || !fileName || !uploadTitle) {
      return res.status(400).json({ message: "Missing phoneNumber, file data, or uploadTitle" });
    }

  
    await uploadFileForUser(phoneNumber, fileData, fileName, uploadTitle);
    res.status(200).json({ message: "File uploaded and linked to user" });
  } catch (e) {
    console.log("Error uploading file:", e);
    res.status(500).json({ message: "Error uploading file", error: e.message });
  }
});

app.get('/getBooleanValues/:phonenumber', async (req, res) => {
  const { phonenumber } = req.params;
  try {
    const userBooleans = await getBooleanValuesByPhoneNumber(phonenumber);
    if (userBooleans) {
      res.status(200).json(userBooleans);
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    res.status(500).json({ message: "Error retrieving user data", error: error.message });
  }
});


app.get('/downloadFileFromGridFS/:fileId', async (req, res) => {
  const { fileId } = req.params;
  try {
    const fileBuffer = await downloadFileFromGridFS(fileId);
    if (fileBuffer) {
      res.setHeader('Content-Type', 'application/octet-stream');
      res.send(fileBuffer);
    } else {
      res.status(404).json({ message: "File not found" });
    }
  } catch (e) {
    res.status(500).json({ message: "Error downloading file", error: e.message });
  }
});

app.delete('/deleteFileFromGridFS', async (req, res) => {
  const { phoneNumber, fileId } = req.body;
  try {
    await deleteFileFromGridFS(phoneNumber, fileId);
    res.status(200).json({ message: "File deleted" });
  } catch (e) {
    res.status(500).json({ message: "Error deleting file", error: e.message });
  }
});


app.listen(3000, '0.0.0.0', () => {
  connect();
  console.log('Server is running on http://localhost:3000');
});
