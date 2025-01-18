import web

urls = (
    '/scoreboard/info', 'scoreboard_info',
    '/scoreboard/update', 'scoreboard_update'
)

class scoreboard_info:
    def GET(self):
        return "Hello, scoreboard_info!"

class scoreboard_update:
    def POST(self):
        return "Hello, scoreboard_update!"

if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()