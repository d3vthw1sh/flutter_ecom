import nodemailer from "nodemailer";

export const sendPasswordResetEmail = async (token, email, name) => {
  const html = `
    <html>
        <body>
          <h3>Dear ${name},</h3>
          <p>Please click on the link below to reset your password.</p>
          <a href="http://localhost:3000/password-reset/${token}">Click here!</a>
        </body>
    </html>`;

  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_USER,  // Use environment variables
      pass: process.env.EMAIL_PASS,
    },
  });

  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: email,
    subject: "RuppTechs: Reset your password request.",
    html: html,
  };

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log(`Email sent to ${email}: ${info.response}`);
  } catch (error) {
    console.error(`Error sending email to ${email}:`, error);
  }
};
