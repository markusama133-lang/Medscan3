from app import app as application, init_db

init_db()

if __name__ == "__main__":
    application.run()
