echo "$*"
for args in "$@"; do echo "pake anu $args"; done
echo "$$"
echo "$?"

ls amar

echo "$?"

for items in $(ls)
do 
    if [ -f "$items" ]; then
        echo "File: $items"
    else
        echo "Folder: $items"
    fi
done