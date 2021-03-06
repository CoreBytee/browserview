local path = require('path')
local fs = require('fs')
local os = require('os')
local parseUrl = require('url').parse
local decodeURI = require('querystring').urldecode
local mimes = require('mime')

-- static files middleware
-- root - directory path required
-- options:
--  `maxAge` - browser cache maxAge in milliseconds, defaults to 0
--  `index` - default file name, defaults to 'index.html'
--  `hidden` - allow transfer of hidden files, defaults to false

function static(root, options)
	if not root then error('root is required') end

	root = path.normalize(root)

	options = options or {}
	options.index = options.index or 'index.html'
	options.maxAge = options.maxAge or 0

	return function(req, res, nxt)
		if req.method ~= 'GET' and req.method ~= 'HEAD' then return nxt() end

		local function serveFiles(route)
			fs.open(route, 'r', function(err, fd)
				if err then return nxt() end

				fs.fstat(fd, function(err, stat)
					if err then
						fs.close(fd)
						return nxt(err)
					end

					local headers
					local code = 200
					local etag = stat.size .. '-' .. stat.mtime.sec

					if etag == req.headers['if-none-match'] then code = 304 end

					res:setHeader('Content-Type', mimes.getType(route))
					res:setHeader('Content-Length', stat.size)
					res:setHeader('Last-Modified', os.date("!%a, %d %b %Y %H:%M:%S GMT", stat.mtime.sec))
					res:setHeader('Etag', etag)
					res:setHeader('Cache-Control', 'public, max-age=' .. (options.maxAge / 1000))

					-- skip directories
					if stat.is_directory then
						fs.close(fd)
						res:writeHead(302)
						res:setHeader('Location', req.url .. '/')
						return res:finish()
					end

					-- skip hidden files if no option specified
					if not options.hidden and '.' == path.basename(route):sub(1, 1) then
						fs.close(fd)
						return nxt()
					end

					res:writeHead(code)

					if req.method == 'HEAD' or code == 304 then
						fs.close(fd)
						return res:finish()
					end

					fs.createReadStream(route, { fd = fd }):pipe(res)
				end)
			end)
		end

		local url = parseUrl(req.url)
		local file = decodeURI(url.pathname)
		local filePath = path.normalize(path.join(root, file))

		local Sub = filePath:sub(#filePath)
		if options.index and Sub == '/' or Sub == '\\' then
			serveFiles(path.join(filePath, options.index))
		else
			serveFiles(filePath)
		end
	end
end

return static
