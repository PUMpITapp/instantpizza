CC=luac

#only parse
FLAGS=-p

EXEC=pushnews
SRC_FOLDER=src
SRC= $(wildcard $(SRC_FOLDER)/*.lua $(SRC_FOLDER)/*/*.lua)
OBJ= $(SRC:.lua=.out)

all: $(EXEC)

pushnews: $(SRC)
	$(CC) $(FLAGS) $(SRC)
