import mysql.connector

conn  = mysql.connector.connect(
  host='db',
  user="root",
  password="roott"
)
#  database="db_posts"
cursor = conn.cursor()

def executeScriptsFromFile(filename):
    fd = open(filename, 'r')
    sqlFile = fd.read()
    fd.close()
    sqlCommands = sqlFile.split(';')

    for command in sqlCommands:
        try:
            if command.strip() != '':
                cursor.execute(command)
        except IOError as msg:
            print ("Command skipped: ", msg)

executeScriptsFromFile('schema.sql')




cursor.execute("INSERT INTO posts (title, content) VALUES (%s, %s)",
            ('First Post', 'Content for the first post', ))

cursor.execute("INSERT INTO posts (title, content) VALUES (%s, %s)",
            ('Second Post', 'Content for the second post', ))


conn.commit()
cursor.close()
conn.close()


