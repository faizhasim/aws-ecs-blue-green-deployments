const express = require('express')
const os = require('os')
const greeting = require('greeting')
const crypto = require('crypto')
const { machineIdSync } = require('node-machine-id')
const humanizeDuration = require('humanize-duration')
const { name, version } = require('./package.json')

const app = express()

const port = 80

const createTag = (title, value) => `
  <div class="control">
    <div class="tags has-addons">
      <span class="tag">${title}</span>
      <span class="tag is-info">${value}</span>
    </div>
  </div>
  `

const generateInfo = () => [
  createTag('hostname', os.hostname()),
  createTag('arch', os.arch()),
  createTag('cpu', os.cpus().length),
  createTag('platform', os.platform()),
  createTag('uptime', humanizeDuration(os.uptime() * 1000, { round: true, largest: 1 })),
  createTag('release', os.release()),
  createTag('username', os.userInfo().username),
  createTag('machine-id', machineIdSync().substring(0,6))
].join('\n')

const avatarUrl = () => {
  const id = input => String(
    parseInt(crypto.createHash('md5')
      .update(input)
      .digest('hex')
      .substring(0,6), 16)
  )[3];
  return `https://randomuser.me/api/portraits/lego/${id(os.hostname() + machineIdSync().substring(0,6) + version)}.jpg`;
}

app.get('/', (req, res) => res.send(`
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>papaadamango</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.2/css/bulma.min.css">
    <script defer src="https://use.fontawesome.com/releases/v5.3.1/js/all.js"></script>
    <style id="code">
    .speech-bubble {
      position: relative;
      background: #f5f5f5;
      border-radius: 1em;
      color: #363636;
      display: inline-block;
      padding: .5em 1em;
      text-align: left;
      bottom: 2em;
      max-width: 175px;
      bottom: 1em;
    }
    
    .speech-bubble:after  {
      content: '';
      position: absolute;
      bottom: 0;
      width: 0;
      height: 0;
      border: 0.906em solid transparent;
      border-top-color: #f5f5f5;
      border-bottom: 0;
      margin-left: -0.453em;
      margin-bottom: -0.906em;
    }
    
    @media screen and (min-width: 769px) {
      .speech-bubble {
        right: 1em;
      }
      .speech-bubble:after  {
        left: 4.5em;
        border-right: 0;
      }
      
      .fix-column-position {
        margin-top: -4.3em;
      }
    }
    
    @media screen and (max-width: 768px) {
      .speech-bubble {
        bottom: 0.7em;
        right: -2.5em;
        max-width: 200px;
        display: block;
      }
      .speech-bubble:after  {
        left: 5em;
        border-left: 0;
      }
    }
    </style>
  </head>
  <body>
    <section class="hero is-dark is-fullheight"">
      <div class="hero-body">
        <div class="container">
          <div class="columns">
            <div class="column is-one-fifth has-text-right fix-column-position">
              <div class="speech-bubble">
                <h1 style="font-size: large;">${greeting.random()}</h1>
                <h2 style="font-size: small;">Everything is awesome!</h2>
              </div>
              <figure class="image is-128x128 is-inline-block-tablet is-block-mobile">
                <img class="is-rounded" style="border: #f5f5f5 0.2em solid;" src="${avatarUrl()}">
              </figure>
            </div>
            <div class="column">
              <h1 class="title">
                ${name} @ ${version}
              </h1>
              <h2 class="subtitle">
                a simple nginx (or equivalent) serving a static file that shows some info on the hosted machine
              </h2>
              <div class="field is-grouped is-grouped-multiline">
                ${generateInfo()}
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </body>
</html>
`))

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
