import web
import sqlite3
import json
import traceback

urls = (
    '/scoreboard/info', 'scoreboard_info',
    '/scoreboard/update', 'scoreboard_update'
)

class scoreboard_info:
    def GET(self):
        con = None
        try:
            data = web.input(password="")
            if data.password != "98954740257108":
                return json.dumps([])
            con = sqlite3.connect("scoreboard.db", check_same_thread=False)
            cur = con.cursor()
            sql = "select * from score order by score desc limit 10"
            res = cur.execute(sql)
            res = res.fetchall()
            return json.dumps(res)
        except:
            pass
        finally:
            if con:
                con.close

class scoreboard_update:
    def GET(self):
        try:
            con = None
            data = web.input(password="", username="", score="")
            print(data)
            if data.password != "98954740257108" or data.username == "":
                return json.dumps({"code": 1})
            
            new_score = int(data.score)
            con = sqlite3.connect("scoreboard.db", check_same_thread=False)
            cur = con.cursor()
            sql = "select * from score where username='%s'"%data.username
            res = cur.execute(sql)
            res = res.fetchall()
            
            if len(res) == 0:
                sql = "INSERT INTO score (username, score) VALUES ('%s', %d)"%(data.username, new_score)
                res = cur.execute(sql)
                print(sql)
                con.commit()
                return json.dumps({"code": 0})

            old_score = int(res[0][1])
            if new_score > old_score:
                sql = "UPDATE score SET score ={score} WHERE username='{username}'".format(score=new_score, username=data.username)
                print(sql)
                res = cur.execute(sql)
                con.commit()
            return json.dumps({"code": 0})
        except:
            print("except")
            print(traceback.format_exc())
        finally:
            if con:
                con.close()
        return json.dumps({"code": 1})

if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()