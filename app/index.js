const express = require('express')
const os = require('os');
const { machineIdSync } = require('node-machine-id');
const humanizeDuration = require('humanize-duration')

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

app.get('/', (req, res) => res.send(`
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hello Bulma!</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.2/css/bulma.min.css">
    <script defer src="https://use.fontawesome.com/releases/v5.3.1/js/all.js"></script>
  </head>
  <body>
    <section class="hero is-dark is-fullheight">
      <div class="hero-body">
        <div class="container">
          <h1 class="title">
            a simple nginx (or equivalent) serving a static file
          </h1>
          <h2 class="subtitle">
            that shows some info on the hosted machine
          </h2>
          <div class="field is-grouped is-grouped-multiline">
            ${generateInfo()}
          </div>
        </div>
      </div>
    </section>
  </body>
</html>
`))

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
