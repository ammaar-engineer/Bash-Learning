# name=$(ls -la | awk '{print $2}')
fileList=$(ls -la)
fileName=($(echo "$fileList" | awk '{print $9}'))
# Use last field instead of $9
checkType() {
    if [ -f "$1" ]; then
        echo "File: "
    else
        echo "Folder: "
    fi
}
i=0
echo "======File list======"
for file in "${fileName[@]}"; do
    # ((i++))
    let i++
    echo "$i. $(checkType "$file")"$file""
done
echo "======File list======"