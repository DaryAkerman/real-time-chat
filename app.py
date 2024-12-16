from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from flask_socketio import SocketIO, emit
from dotenv import load_dotenv
import os
from logging_config import setup_logging
from extensions import db
from models import User, Message

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY')
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('POSTGRESQL_URI')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize logging
logger = setup_logging(os.getenv('INSTRUMENTATION_KEY'))

# Initialize database
db.init_app(app)

# Initialize SocketIO
socketio = SocketIO(app)

@app.route('/')
def index():
    if 'user' in session:
        return redirect(url_for('chat'))
    return redirect(url_for('login'))

@app.route('/chat', methods=['GET', 'POST'])
def chat():
    if 'user' not in session:
        flash('Please log in to join the chat.', 'error')
        return redirect(url_for('login'))

    # Retrieve all messages for display
    messages = Message.query.order_by(Message.timestamp).all()
    return render_template('chat.html', messages=messages)

@socketio.on('send_message')
def handle_message(data):
    """Handle incoming messages from the client."""
    if 'user' not in session:
        logger.warning("Unauthorized user tried to send a message")
        return

    sender_username = session['user']
    message_text = data['message']

    if not message_text.strip():
        logger.warning(f"User '{sender_username}' tried to send an empty message")
        return

    # Save the message to the database
    sender = User.query.filter_by(username=sender_username).first()
    new_message = Message(sender_id=sender.id, message_text=message_text.strip())
    db.session.add(new_message)
    db.session.commit()

    # Log the message
    logger.info(f"Message sent by {sender_username}: {message_text}")

    # Broadcast the message to all connected clients
    emit('new_message', {
        'sender': sender_username,
        'message': message_text,
        'timestamp': new_message.timestamp.strftime('%H:%M:%S')
    }, broadcast=True)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        user = User.query.filter_by(username=username).first()
        if not user or not check_password_hash(user.password, password):
            logger.warning(f"Failed login attempt for username: {username}")
            flash('Invalid credentials!', 'error')
            return redirect(url_for('login'))

        # Set session
        session['user'] = user.username
        logger.info(f"User '{username}' logged in successfully")
        flash('Login successful!', 'success')
        return redirect(url_for('index'))

    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        if User.query.filter_by(username=username).first():
            logger.warning(f"Registration failed: Username '{username}' already exists")
            flash('Username already exists!', 'error')
            return redirect(url_for('register'))

        hashed_password = generate_password_hash(password, method='pbkdf2:sha256')
        new_user = User(username=username, password=hashed_password)
        db.session.add(new_user)
        db.session.commit()
        logger.info(f"User '{username}' registered successfully")
        flash('Registration successful!', 'success')
        return redirect(url_for('login'))

    return render_template('register.html')

@app.route('/logout', methods=['POST'])
def logout():
    user = session.pop('user', None)
    if user:
        logger.info(f"User '{user}' logged out")
        flash('You have been logged out.', 'success')
    return redirect(url_for('index'))

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    socketio.run(app, debug=True, host="0.0.0.0", port=5000)
