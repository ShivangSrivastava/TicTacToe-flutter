from fastapi import FastAPI, WebSocket, HTTPException
import secrets
import datetime

app = FastAPI()

ACTIVE_GAMES = {}
PENDING_GAMES = {}


def refreshPendingGames():
    EXPIRED_CODE = []
    CURRENT_TIME = datetime.datetime.now()
    for code, creation_time in PENDING_GAMES.items():
        if CURRENT_TIME-creation_time > datetime.timedelta(hours=1):
            EXPIRED_CODE.append(code)

    for code in EXPIRED_CODE:
        del PENDING_GAMES[code]


@app.get("/newGameCode")
async def newGameCode():
    code = str(secrets.randbelow(10000))
    refreshPendingGames()
    while code in ACTIVE_GAMES or code in PENDING_GAMES:
        code = str(secrets.randbelow(10000))
    PENDING_GAMES[code] = datetime.datetime.now()
    return {
        "code": code,
    }


@app.get("/join/{gameCode:str}")
async def joinGame():
    if gameCode not in PENDING_GAMES:
        return HTTPException(status_code=404)
    del PENDING_GAMES[gameCode]
    _turn = secrets.choice(["x", "o"])
    ACTIVE_GAMES[gameCode] = {
        "xScore": 0,
        "oScore": 0,
        "turn": _turn,
        "msg": f"{_turn.capitalize()}'s turn",
        "board": ["" for _ in range(9)]
    }
    return ACTIVE_GAMES[gameCode]


@app.websocket("/game/{gameCode:str}")
async def gameEndPoint(websocket: WebSocket):
    websocket.accept()
    try:
        while True:
            game = Game(gameCode)
            data = await websocket.receive_text()
            if data == "reset":
                game.reset()
                websocket.send_json(ACTIVE_GAMES[gameCode])
            elif data == "join":
                websocket.send_text("joined")
            else:
                game.update(data)
                websocket.send_json(ACTIVE_GAMES[gameCode])

    except WebSocketDisconnect:
        del ACTIVE_GAMES[gameCode]


class Game:
    def __init__(self, gameCode, move):
        self.gameCode = gameCode
        self.data = ACTIVE_GAMES[self.gameCode]
        self.xScore = self.data["xScore"]
        self.oScore = self.data['oScore']
        self.turn = self.data["turn"]
        self.msg = self.data["msg"]
        self.board = self.data['board']
        self.move = None

    def update(self, move):
        self.move = move
        self.updateBoard()

        self.data["xScore"] = self.xScore
        self.data['oScore'] = self.oScore
        self.data["turn"] = self.turn
        self.data["msg"] = self.msg
        self.data['board'] = self.board

        ACTIVE_GAMES[self.gameCode] = self.data

    def updateScore(self, scoreWRTX):
        if scoreWRTX == 1:
            self.xScore += 1
            self.msg = "X wins"
        elif scoreWRTX == -1:
            self.oScore += 1
            self.msg = "O wins"
        elif scoreWRTX == 0:
            self.msg = "Tie"

    def updateBoard(self):
        if self.turn == "x":
            self.board[int(self.move)] = "x"
            self.turn = "o"
            self.msg = "O's Turn"

        elif self.turn == "o":
            self.board[int(self.move)] = "o"
            self.turn = "x"
            self.msg = "X's Turn"
        self.checkWinner()

    def checkWinner(self):
        winner = ""
        isTie = False

        if (self.board[0] == self.board[1] == self.board[2] and self.board[0] != ""):
            winner = self.board[0]
        elif (self.board[3] == self.board[4] == self.board[5] and self.board[3] != ""):
            winner = self.board[3]
        elif (self.board[6] == self.board[7] == self.board[8] and self.board[6] != ""):
            winner = self.board[6]
        elif (self.board[0] == self.board[3] == self.board[6] and self.board[0] != ""):
            winner = self.board[0]
        elif (self.board[1] == self.board[4] == self.board[7] and self.board[1] != ""):
            winner = self.board[1]
        elif (self.board[2] == self.board[5] == self.board[8] and self.board[2] != ""):
            winner = self.board[2]
        elif (self.board[0] == self.board[4] == self.board[8] and self.board[0] != ""):
            winner = self.board[0]
        elif (self.board[2] == self.board[4] == self.board[6] and self.board[2] != ""):
            winner = self.board[2]

        if winner == "":
            if "" not in self.board:
                isTie = True
        if isTie:
            self.updateScore(0)
            return
        if winner == "x":
            self.updateScore(1)
            return
        if winner == "o":
            self.updateScore(-1)
            return

    def reset(self):
        if self.msg in ["X wins", "O wins", "Tie"]:
            _turn = secrets.choice(["x", "o"])
            self.msg = f"{_turn.capitalize()}'s turn"
            self.board = ["" for _ in range(9)]
