import nodemailer from "nodemailer";

export const sendVerificationEmail = async (token, email, name) => {
  const html = `
    <html>
        <body>
            <h3>Dear ${name},</h3>
            <p>Thanks for signing up at RuppTechs!</p>
            <p>Use the link below to verify your email:</p>
            <a href="http://localhost:3000/email-verify/${token}">Click here!</a>
        </body>
    </html>
    `;

  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_USER,  // put your email in .env
      pass: process.env.EMAIL_PASS,  // put your email password/app password in .env
    },
  });

  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: email,
    subject: "Verify your email address",
    html: html,
  };

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log(`Email sent to ${email}: ${info.response}`);
  } catch (error) {
    console.error(`Error sending email to ${email}:`, error);
  }
};
