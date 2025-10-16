# Flask Backend for Lost & Found Management System

from flask import Flask, render_template, request, redirect, url_for, flash
from db_config import get_connection

app = Flask(__name__)
app.secret_key = "lostfound_secret"

#Home Page
@app.route('/')
def home():
    return render_template('../LostFoundSystem/index.html')

#User Signup 
@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        phone = request.form['phone']
        role = 'student'
        password = request.form['password']

        conn = get_connection()
        if conn:
            cur = conn.cursor()
            # QUERY: Insert user details into users table
            cur.execute("""
                INSERT INTO users (user_id, name, email, phone, role, password)
                VALUES (users_seq.NEXTVAL, :1, :2, :3, :4, :5)
            """, (name, email, phone, role, password))
            conn.commit()
            cur.close()
            conn.close()
            flash("Registration successful! Please login.")
            return redirect(url_for('login'))
    return render_template('../LostFoundSystem/signup.html')


#User Login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        conn = get_connection()
        if conn:
            cur = conn.cursor()
            # QUERY: Validate user credentials
            cur.execute("""
                SELECT user_id, role FROM users
                WHERE email = :1 AND password = :2
            """, (email, password))
            user = cur.fetchone()
            cur.close()
            conn.close()

            if user:
                flash(f"Welcome back! Logged in as {email}")
                if user[1] == 'admin':
                    return redirect(url_for('admin_dashboard'))
                else:
                    return redirect(url_for('view_items'))
            else:
                flash("Invalid credentials!")
    return render_template('../LostFoundSystem/login.html')


#Admin Dashboard
@app.route('/admin_dashboard')
def admin_dashboard():
    return render_template('../LostFoundSystem/admin_dashboard.html')


#Report Lost Item
@app.route('/lost_form', methods=['GET', 'POST'])
def lost_form():
    if request.method == 'POST':
        item_name = request.form['item_name']
        category = request.form['category']
        description = request.form['description']
        location = request.form['location']
        date_lost = request.form['date_lost']
        user_id = request.form.get('user_id', 1)  # placeholder

        conn = get_connection()
        if conn:
            cur = conn.cursor()
            # QUERY: Insert new lost item
            cur.execute("""
                INSERT INTO lostitem (lost_id, user_id, item_name, category, description, location_lost, date_lost)
                VALUES (lostitem_seq.NEXTVAL, :1, :2, :3, :4, :5, TO_DATE(:6, 'YYYY-MM-DD'))
            """, (user_id, item_name, category, description, location, date_lost))
            conn.commit()
            cur.close()
            conn.close()
            flash("Lost item reported successfully!")
            return redirect(url_for('view_items'))
    return render_template('../LostFoundSystem/lost_form.html')


#Report Found Item
@app.route('/found_form', methods=['GET', 'POST'])
def found_form():
    if request.method == 'POST':
        item_name = request.form['item_name']
        category = request.form['category']
        description = request.form['description']
        location = request.form['location']
        date_found = request.form['date_found']
        user_id = request.form.get('user_id', 1)  # placeholder

        conn = get_connection()
        if conn:
            cur = conn.cursor()
            # QUERY: Insert new found item
            cur.execute("""
                INSERT INTO founditem (found_id, user_id, item_name, category, description, location_found, date_found)
                VALUES (found_seq.NEXTVAL, :1, :2, :3, :4, :5, TO_DATE(:6, 'YYYY-MM-DD'))
            """, (user_id, item_name, category, description, location, date_found))
            conn.commit()
            cur.close()
            conn.close()
            flash("Found item submitted successfully!")
            return redirect(url_for('view_items'))
    return render_template('../LostFoundSystem/found_form.html')


#View Items (Lost + Found)
@app.route('/view_items')
def view_items():
    conn = get_connection()
    lost_items = []
    found_items = []
    if conn:
        cur = conn.cursor()
        # QUERY 1: Get all lost items
        cur.execute("SELECT item_name, category, description, location_lost, date_lost FROM lostitem")
        lost_items = cur.fetchall()

        # QUERY 2: Get all found items
        cur.execute("SELECT item_name, category, description, location_found, date_found FROM founditem")
        found_items = cur.fetchall()

        cur.close()
        conn.close()
    return render_template('../LostFoundSystem/view_items.html',
                           lost_items=lost_items, found_items=found_items)

# Run the Flask Application

if __name__ == "__main__":
    app.run(debug=True)
