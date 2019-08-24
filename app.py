from flask import Flask, render_template, session, request, flash, redirect
import mysql.connector
import os
import hashlib

app = Flask(__name__)

db = mysql.connector.connect(
    host="localhost", user="root", passwd="", database="movie_ticket_system")
cursor = db.cursor(buffered=True)


def check_authentication():
    if session['uID']:
        return True
    else:
        return False
# index page
@app.route("/")  # decorator---default page
def index():
    session.clear()
    return render_template("index.html")

# login page
@app.route("/login", methods=["POST", "GET"])
def login():
    session.clear()
    errors = {}
    if request.method == "POST":
        try:
            userName = request.form['userName']
            password = request.form['password']

            hash_obj = hashlib.sha1(password.encode("utf8"))
            hex_dig = hash_obj.hexdigest()

            if userName == "":
                errors['userName'] = "user name is empty"

            if password == "":
                errors['password'] = "password is empty"

            if len(errors) is not 0:
                return render_template("login.html", errors=errors)

            cursor.execute(
                "SELECT * FROM users WHERE userName = %s AND password = %s", (userName, hex_dig))

            if cursor.rowcount == 0:
                errors['user'] = "User does not exist"
                return render_template("login.html", errors=errors)
            else:
                data = cursor.fetchone()
                session['uID'] = data[0]
                session['fullName'] = data[4]
                session['isAdmin'] = data[5]

                if data[5] == 1:
                    return redirect("/admin/dashboard")
                else:
                    return redirect("/profile")
        except Exception as e:
            flash(e)
            return render_template("error.html")
    return render_template("login.html", errors=errors)

# register page
@app.route("/register", methods=["POST", "GET"])
def register():
    session.clear()
    errors = {}
    if request.method == "POST":
        try:
            fullName = request.form['fullName']
            email = request.form['email']
            userName = request.form['userName']
            password = request.form['password']

            if fullName == "":
                errors['fullName'] = "Full name is empty"

            if email == "":
                errors['email'] = "email is empty"

            if userName == "":
                errors['userName'] = "User name is empty"

            if password == "":
                errors['password'] = "Password is empty"

            if len(errors) is not 0:
                return render_template("register.html", errors=errors)

            cursor.execute(
                "SELECT * FROM users WHERE email = %s OR userName = %s", (email, userName))
            print("I got here")
            if cursor.rowcount is not 0:
                data = cursor.fetchone()
                print(data)
                # convert varbinary to string
                if userName == data[1].decode('ascii'):
                    errors['userName'] = "User Name already exists"
                # convert varbinary to string
                if email == data[2].decode('ascii'):
                    errors['email'] = "Email already exists"
                return render_template("register.html", errors=errors)

            print("I got here")
            hash_obj = hashlib.sha1(password.encode("utf8"))
            hex_dig = hash_obj.hexdigest()
            cursor.execute("INSERT INTO users(fullName,email,userName,password) VALUES(%s,%s,%s,%s)",
                           (fullName, email, userName, hex_dig))

            db.commit()
            print("I got here")
            return redirect('/login')
        except Exception as e:
            flash(e)
            return render_template("error.html")
    return render_template("register.html", errors=errors)

# profile
@app.route("/profile", methods=["POST", "GET"])
def profile():
    if 'uID' not in session.keys():
        return redirect('/login')

    return render_template("profile.html")

# dashboard
@app.route("/admin/dashboard", methods=["POST", "GET"])
def dashboard():
    if 'uID' not in session.keys():
        return redirect('/login')
    return render_template("dashboard.html")

# admin_movies
@app.route("/admin/movies", methods=["POST", "GET"])
def admin_movies():
    if 'uID' not in session.keys():
        return redirect('/login')
    cursor.execute(
        "SELECT mID,movieName,isActive,inDate,userName FROM movies AS M INNER JOIN users AS U ON M.uID=U.uID GROUP BY mID")
    data = cursor.fetchall()
    print(data)
    return render_template("admin_movies.html", movies=data)

# insert_movies
@app.route("/admin/movies/insert", methods=["POST", "GET"])
def insert_movies():
    if 'uID' not in session.keys():
        return redirect('/login')
    errors = {}
    if request.method == "POST":
        try:
            movieName = request.form['movieName']
            isActive = request.form['isActive']

            if movieName == "":
                errors['movieName'] = "movie name is empty"

            if len(errors) is not 0:
                return render_template("insert_movie.html", errors=errors)
            else:
                cursor.execute("INSERT INTO movies(movieName,isActive,uID) VALUES(%s,%s,%s)", (
                    movieName, isActive, session['uID']))
                db.commit()
                return redirect("/admin/movies")

        except Exception as e:
            flash(e)
            return render_template("error.html")
    return render_template("insert_movie.html", errors=errors)

# admin_shows
@app.route("/admin/shows", methods=["POST", "GET"])
def shows():
    if 'uID' not in session.keys():
        return redirect('/login')
    return render_template("admin_shows.html")

# admin_bookings
@app.route("/admin/bookings", methods=["POST", "GET"])
def admin_bookings():
    if 'uID' not in session.keys():
        return redirect('/login')
    return render_template("admin_bookings.html")

# logout
@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")


if __name__ == "__main__":
    app.secret_key = os.urandom(12)
    app.run(debug=True)
    app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
else:
    print("not main")
