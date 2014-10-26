for f in */; do
    echo "$f";
	cd "$f"
  	haxe build.hxml
  	cd ..
done