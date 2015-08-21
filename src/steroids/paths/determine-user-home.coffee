
module.exports = ->
  if process.platform == 'win32'
    process.env.USERPROFILE
  else
    process.env.HOME
