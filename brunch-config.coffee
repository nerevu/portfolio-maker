exports.config =
  # See http://brunch.io/#documentation for docs.
  plugins:
    coffeelint:
      pattern: /^app\/.*\.coffee$/
      options:
        indentation:
          value: 2
          level: "error"

  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(?!app)/

    stylesheets:
      joinTo: 'stylesheets/app.css'

    templates:
      joinTo: 'javascripts/app.js'
