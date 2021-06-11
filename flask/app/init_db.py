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

executeScriptsFromFile('./app/schema.sql')



conn.commit()
cursor.close()
conn.close()


