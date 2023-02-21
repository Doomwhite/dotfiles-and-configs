local directories = {}
local isPc = false

function directories.getIsPc()
	return isPc
end

function directories.getUser()
	if isPc then
		return "C:/Users/Cliente/"
	else
		return "C:/Users/adinelson.bruhmuller.MOVTECH/"
	end
end

return {
	directories = directories
}
