_ = require('wegweg')({globals:on,shelljs:on})

Polly = (require 'aws-sdk').Polly
Stream = require 'stream'

polly = new Polly({
  region: 'us-east-1'
  accessKeyId: process.env.AWS_ACCESS
  secretAccessKey: process.env.AWS_SECRET
})

## primary export
module.exports = wow = {}

wow.sounds = """
  pet low
  peel now
  trinket
  tap
  grounding
  sheep
  silence
  drinking
  will
""".split '\n'

wow.create_mp3 = ((str,cb) ->
  if !_.exists(__dirname + '/output')
    mkdir __dirname + '/output'

  filename = __dirname + '/output/' + _.uri_title(str) + '.mp3'
  rm filename if _.exists(filename)

  log /Creating file/, _.base(filename)

  opt = {
    Text: str
    OutputFormat: 'mp3'
    VoiceId: 'Raveena'
    LanguageCode: 'en-US'
  }

  await polly.synthesizeSpeech opt, defer e,r
  if e then throw e

  require('fs').writeFileSync(filename,r.AudioStream)

  return cb null, true
)

##
if !module.parent

  # create mp3 files
  for x in wow.sounds
    await wow.create_mp3 x, defer e
    if e then throw e

  log /Finished/
  exit 0

