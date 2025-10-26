import express from 'express';

const router = express.Router();

router.post('/', (req, res) => {
  const { name, email, message } = req.body;

  // For now, just log the contact info to console
  console.log("Contact Form Submitted:", { name, email, message });

  res.json({ message: "Thanks for reaching out! We'll get back to you." });
});

export default router;
