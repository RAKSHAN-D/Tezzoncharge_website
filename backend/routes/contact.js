import express from 'express';

const router = express.Router();

// Helper function to validate email
const isValidEmail = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

router.post('/', (req, res) => {
  try {
    const { name, email, message } = req.body;

    // Validation
    if (!name || typeof name !== 'string' || name.trim() === '') {
      return res.status(400).json({ error: "Name is required and must be a valid string." });
    }

    if (!email || !isValidEmail(email)) {
      return res.status(400).json({ error: "Valid email is required." });
    }

    if (!message || typeof message !== 'string' || message.trim() === '') {
      return res.status(400).json({ error: "Message is required and must be a valid string." });
    }

    // Log the contact info
    console.log("Contact Form Submitted:", { name: name.trim(), email: email.trim(), message: message.trim() });

    res.status(200).json({ message: "Thanks for reaching out! We'll get back to you soon." });
  } catch (error) {
    console.error("Contact form error:", error);
    res.status(500).json({ error: "Internal server error. Please try again later." });
  }
});

export default router;
