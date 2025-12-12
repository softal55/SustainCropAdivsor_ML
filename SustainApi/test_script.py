import smtplib

smtp_server = 'sandbox.smtp.mailtrap.io'
smtp_port = 2525
smtp_username = '4d5c0d9cddaa3b'  # Replace with your Mailtrap username
smtp_password = '****03d2'  # Replace with your Mailtrap password

try:
    with smtplib.SMTP(smtp_server, smtp_port) as server:
        server.set_debuglevel(1)  # Enable SMTP communication logs
        server.starttls()  # Upgrade to secure connection
        server.login(smtp_username, smtp_password)
        print("Connection successful")
except Exception as e:
    print(f"Connection failed: {e}")
