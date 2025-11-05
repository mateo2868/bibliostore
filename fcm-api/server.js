import express from "express";
import admin from "firebase-admin";
import dotenv from "dotenv";

dotenv.config();

const app = express();
app.use(express.json());

// Inicializa Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert("./firebase-service-account.json"),
});

// Endpoint para enviar notificación
app.post("/send", async (req, res) => {
  try {
    const { token, title, body, data } = req.body;

    if (!token || !title || !body) {
      return res.status(400).json({
        message: "token, title y body son requeridos",
      });
    }

    const message = {
      token,
      notification: {
        title,
        body,
      },
      data: data || {},
    };

    const response = await admin.messaging().send(message);
    console.log("✅ Notificación enviada:", response);

    res.json({ message: "Notificación enviada correctamente", response });
  } catch (error) {
    console.error("❌ Error enviando notificación:", error);
    res.status(500).json({ error: error.message });
  }
});

// Iniciar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🚀 Servidor corriendo en puerto ${PORT}`));
