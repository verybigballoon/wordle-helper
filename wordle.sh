#!/bin/sh
FILE="wordle.words"
if [[ $1 == "-o" ]]; then
    FILE="wordle_possibles.txt"
    if [[ ! -e "$FILE" ]]; then
	curl https://gist.githubusercontent.com/kcwhite/bb598f1b3017b5477cb818c9b086a5d9/raw/5a0adbbb9830ed93a573cb87a7c14bb5dd0b1883/wordle_possibles.txt >wordle_possibles.txt
    fi
elif [[ $1 ]]; then
    FILE="$1"
else
    if [[ ! -e "$FILE" ]]; then
	grep -E "[A-Za-z]{5}" ../linux.words | tr A-Z a-z >wordle.words
    fi
fi

WORDS=$(cat "$FILE")

while :; do
    
    printf "Enter (new) wrong letters (q to quit): "
    read -r WRONG
    if [[ "$WRONG" == "q" ]]; then
	exit;
    fi
    WRONGEXP=$(echo "$WRONG" | sed "s/\(.*\)/\[\^\1]{5}/g")
    
    printf "Enter (new) misplaced letters (with hyphens for blanks): "
    read -r MISPLACED
    MISPLACEDEXP=$(echo "$MISPLACED" | sed -e "s/\([a-zA-Z]\)/\[\^\1]/g" | sed -e "s/-/./g")
    MISPLACED=$(echo "${MISPLACED}" | tr -d "\n-")
    
    printf "Enter (new) right letters (with hyphens for blanks): "
    read -r RIGHT 
    RIGHTEXP=$(echo "$RIGHT" | sed -e "s/-/./g")
    
    LETTERS=$(echo "$MISPLACED" | sed -e "s/\(.\)/\1 /g")

    for EXP in $WRONGEXP $MISPLACEDEXP $RIGHTEXP $LETTERS; do
	WORDS=$(echo "$WORDS" | grep -E "$EXP")
    done

    echo "$WORDS" | tr "\n" " "
    echo
done    


