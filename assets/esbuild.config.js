const esbuild = require('esbuild')

let opts = {
  entryPoints: ['js/app.js'],
  bundle: true,
  outdir: '../priv/static/js',
  external: ['phoenix', 'phoenix_html', 'phoenix_live_view']
}

esbuild.build(opts).catch(() => process.exit(1))
