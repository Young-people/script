#/bin/sh

filename=$1
parentClass=$2
outputPath=$3


echo "\
$1 = class(\"$1\",function() return $2:create() end) 

function $1:create() 
	local obj = $1:new() 
	obj:__init() 
	return obj 
end 
 
function $1:__init() 
 
end 

return $1 
		" > $3/$1.lua
